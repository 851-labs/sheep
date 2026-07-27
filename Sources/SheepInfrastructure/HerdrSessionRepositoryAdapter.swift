import Foundation
import SheepApplication
import SheepDomain

public actor HerdrSessionRepositoryAdapter: HerdrSessionRepository {
    private let supervisor: any HerdrServerSupervisor
    private var client: HerdrSocketClient?
    private var continuations: [UUID: AsyncStream<SessionUpdate>.Continuation] = [:]
    private var connectionState: ConnectionState = .connecting
    private var currentSession: HerdrSession?
    private var runTask: Task<Void, Never>?
    private var subscriptionTask: Task<Void, Never>?
    private var subscription: HerdrEventSubscription?
    private var subscriptionPaneIDs: Set<PaneID> = []
    private var reconnectReason: String?
    private var refreshTask: Task<Void, Never>?

    public init(supervisor: any HerdrServerSupervisor) {
        self.supervisor = supervisor
    }

    deinit {
        runTask?.cancel()
        subscriptionTask?.cancel()
        subscription?.cancel()
        refreshTask?.cancel()
    }

    public func observeSession() async -> AsyncStream<SessionUpdate> {
        let id = UUID()
        let (stream, continuation) = AsyncStream.makeStream(of: SessionUpdate.self)
        continuation.onTermination = { [weak self] _ in
            Task { await self?.removeContinuation(id) }
        }
        continuations[id] = continuation
        continuation.yield(SessionUpdate(connection: connectionState, session: currentSession))
        startIfNeeded()
        return stream
    }

    public func refresh() async {
        guard let client else { return }
        do {
            try refreshSnapshot(using: client)
        } catch {
            requestReconnect(error.localizedDescription)
        }
    }

    public func focusWorkspace(_ id: WorkspaceID) async throws {
        try command("workspace.focus", params: ["workspace_id": id.rawValue])
    }

    public func focusTab(_ id: TabID) async throws {
        try command("tab.focus", params: ["tab_id": id.rawValue])
    }

    public func focusPane(_ id: PaneID) async throws {
        try command("pane.focus", params: ["pane_id": id.rawValue])
    }

    public func createWorkspace(cwd: URL) async throws {
        try command("workspace.create", params: [
            "cwd": cwd.path,
            "label": cwd.lastPathComponent,
            "focus": true,
        ])
    }

    public func createTab(workspaceID: WorkspaceID) async throws {
        try command("tab.create", params: [
            "workspace_id": workspaceID.rawValue,
            "focus": true,
        ])
    }

    public func exportLayout(tabID: TabID) async throws -> PaneLayout {
        guard let client else {
            throw HerdrAPIError(code: "disconnected", message: "Sheep is not connected to Herdr.")
        }
        let data = try client.request(
            method: "layout.export",
            params: ["tab_id": tabID.rawValue]
        )
        return try JSONDecoder().decode(LayoutExportEnvelope.self, from: data).result.layout
    }

    public func setSplitRatio(tabID: TabID, path: [Bool], ratio: Double) async throws {
        try command("layout.set_split_ratio", params: [
            "tab_id": tabID.rawValue,
            "path": path,
            "ratio": ratio,
        ])
    }

    private func startIfNeeded() {
        guard runTask == nil else { return }
        runTask = Task { [weak self] in
            await self?.run()
        }
    }

    private func run() async {
        var retrySeconds: UInt64 = 1
        while !Task.isCancelled {
            publish(currentSession == nil ? .connecting : connectionState)
            do {
                let socketURL = try await supervisor.ensureRunning()
                let newClient = HerdrSocketClient(socketURL: socketURL)
                let session = try fetchSnapshot(using: newClient)
                try validateCompatibility(session)
                client = newClient
                currentSession = session
                reconnectReason = nil
                try startSubscription(client: newClient, paneIDs: Set(session.panes.map(\.id)))
                publish(.connected)
                retrySeconds = 1

                var secondsUntilSafetyRefresh = 5
                while !Task.isCancelled {
                    try await Task.sleep(for: .seconds(1))
                    if let reconnectReason {
                        throw HerdrAPIError(code: "subscription_lost", message: reconnectReason)
                    }
                    secondsUntilSafetyRefresh -= 1
                    if secondsUntilSafetyRefresh == 0 {
                        try refreshSnapshot(using: newClient)
                        secondsUntilSafetyRefresh = 5
                    }
                }
            } catch {
                stopSubscription()
                client = nil
                reconnectReason = nil
                publish(currentSession == nil
                    ? .unavailable(error.localizedDescription)
                    : .disconnected(error.localizedDescription))
                try? await Task.sleep(for: .seconds(retrySeconds))
                retrySeconds = min(retrySeconds * 2, 10)
            }
        }
    }

    private func startSubscription(
        client: HerdrSocketClient,
        paneIDs: Set<PaneID>
    ) throws {
        let next = try client.makeSubscription(paneIDs: paneIDs.sorted {
            $0.rawValue < $1.rawValue
        })
        let previous = subscription
        subscription = next
        subscriptionPaneIDs = paneIDs
        subscriptionTask?.cancel()
        previous?.cancel()
        let repository = self
        subscriptionTask = Task.detached {
            do {
                try next.run { _ in
                    Task { await repository.scheduleRefresh() }
                }
            } catch {
                await repository.subscriptionDisconnected(error, id: next.id)
            }
        }
    }

    private func scheduleRefresh() {
        refreshTask?.cancel()
        refreshTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(75))
            await self?.refresh()
        }
    }

    private func subscriptionDisconnected(_ error: Error, id: UUID) {
        guard subscription?.id == id else { return }
        requestReconnect(error.localizedDescription)
    }

    private func fetchSnapshot(using client: HerdrSocketClient) throws -> HerdrSession {
        let data = try client.request(method: "session.snapshot")
        return try JSONDecoder().decode(SessionSnapshotEnvelope.self, from: data).result.snapshot
    }

    private func refreshSnapshot(using client: HerdrSocketClient) throws {
        let session = try fetchSnapshot(using: client)
        try validateCompatibility(session)
        currentSession = session
        let paneIDs = Set(session.panes.map(\.id))
        if paneIDs != subscriptionPaneIDs {
            try startSubscription(client: client, paneIDs: paneIDs)
        }
        publish(.connected)
    }

    private func command(_ method: String, params: [String: Any]) throws {
        guard let client else {
            throw HerdrAPIError(code: "disconnected", message: "Sheep is not connected to Herdr.")
        }
        _ = try client.request(method: method, params: params)
        scheduleRefresh()
    }

    private func requestReconnect(_ reason: String) {
        reconnectReason = reason
        publish(.disconnected(reason))
    }

    private func stopSubscription() {
        let active = subscription
        subscription = nil
        subscriptionPaneIDs = []
        subscriptionTask?.cancel()
        subscriptionTask = nil
        active?.cancel()
    }

    private func validateCompatibility(_ session: HerdrSession) throws {
        guard session.protocolVersion >= 17 else {
            throw HerdrAPIError(
                code: "incompatible_protocol",
                message: "Sheep requires Herdr protocol 17 or newer; the server reports \(session.protocolVersion)."
            )
        }
        let version = session.version
            .split(separator: "-").first?
            .split(separator: ".")
            .prefix(3)
            .map { Int($0) ?? 0 } ?? []
        let padded = version + Array(repeating: 0, count: max(0, 3 - version.count))
        guard padded.lexicographicallyPrecedes([0, 7, 5]) == false else {
            throw HerdrAPIError(
                code: "incompatible_version",
                message: "Sheep requires Herdr 0.7.5 or newer; the server reports \(session.version)."
            )
        }
    }

    private func publish(_ state: ConnectionState) {
        connectionState = state
        let update = SessionUpdate(connection: state, session: currentSession)
        continuations.values.forEach { $0.yield(update) }
    }

    private func removeContinuation(_ id: UUID) {
        continuations.removeValue(forKey: id)
        if continuations.isEmpty {
            runTask?.cancel()
            runTask = nil
            refreshTask?.cancel()
            refreshTask = nil
            stopSubscription()
            client = nil
            connectionState = .connecting
        }
    }
}

private struct SessionSnapshotEnvelope: Decodable {
    let result: Result

    struct Result: Decodable {
        let snapshot: HerdrSession
    }
}

private struct LayoutExportEnvelope: Decodable {
    let result: Result

    struct Result: Decodable {
        let layout: PaneLayout
    }
}
