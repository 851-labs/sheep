import Foundation
import SheepApplication
import SheepDomain

public actor HerdrSessionRepositoryAdapter: HerdrSessionRepository {
    private let supervisor: any HerdrServerSupervisor
    private var client: HerdrSocketClient?
    private var continuations: [UUID: AsyncStream<SessionUpdate>.Continuation] = [:]
    private var currentSession: HerdrSession?
    private var runTask: Task<Void, Never>?
    private var subscriptionTask: Task<Void, Never>?
    private var refreshTask: Task<Void, Never>?

    public init(supervisor: any HerdrServerSupervisor) {
        self.supervisor = supervisor
    }

    deinit {
        runTask?.cancel()
        subscriptionTask?.cancel()
        refreshTask?.cancel()
    }

    public func observeSession() async -> AsyncStream<SessionUpdate> {
        let id = UUID()
        let (stream, continuation) = AsyncStream.makeStream(of: SessionUpdate.self)
        continuation.onTermination = { [weak self] _ in
            Task { await self?.removeContinuation(id) }
        }
        continuations[id] = continuation
        continuation.yield(SessionUpdate(
            connection: currentSession == nil ? .connecting : .connected,
            session: currentSession
        ))
        startIfNeeded()
        return stream
    }

    public func refresh() async {
        guard let client else { return }
        do {
            let session = try fetchSnapshot(using: client)
            currentSession = session
            broadcast(.init(connection: .connected, session: session))
        } catch {
            broadcast(.init(
                connection: .disconnected(error.localizedDescription),
                session: currentSession
            ))
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
            broadcast(.init(connection: .connecting, session: currentSession))
            do {
                let socketURL = try await supervisor.ensureRunning()
                let newClient = HerdrSocketClient(socketURL: socketURL)
                client = newClient
                let session = try fetchSnapshot(using: newClient)
                guard session.protocolVersion >= 17 else {
                    throw HerdrAPIError(
                        code: "incompatible_protocol",
                        message: "Sheep requires Herdr protocol 17 or newer."
                    )
                }
                currentSession = session
                broadcast(.init(connection: .connected, session: session))
                startSubscription(client: newClient, paneIDs: session.panes.map(\.id))
                retrySeconds = 1

                while !Task.isCancelled {
                    try await Task.sleep(for: .seconds(5))
                    await refresh()
                }
            } catch {
                client = nil
                broadcast(.init(
                    connection: .unavailable(error.localizedDescription),
                    session: currentSession
                ))
                try? await Task.sleep(for: .seconds(retrySeconds))
                retrySeconds = min(retrySeconds * 2, 10)
            }
        }
    }

    private func startSubscription(client: HerdrSocketClient, paneIDs: [PaneID]) {
        subscriptionTask?.cancel()
        let repository = self
        subscriptionTask = Task.detached {
            do {
                try client.subscribe(paneIDs: paneIDs) { _ in
                    Task { await repository.scheduleRefresh() }
                }
            } catch {
                await repository.subscriptionDisconnected(error)
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

    private func subscriptionDisconnected(_ error: Error) {
        broadcast(.init(
            connection: .disconnected(error.localizedDescription),
            session: currentSession
        ))
    }

    private func fetchSnapshot(using client: HerdrSocketClient) throws -> HerdrSession {
        let data = try client.request(method: "session.snapshot")
        return try JSONDecoder().decode(SessionSnapshotEnvelope.self, from: data).result.snapshot
    }

    private func command(_ method: String, params: [String: Any]) throws {
        guard let client else {
            throw HerdrAPIError(code: "disconnected", message: "Sheep is not connected to Herdr.")
        }
        _ = try client.request(method: method, params: params)
        scheduleRefresh()
    }

    private func broadcast(_ update: SessionUpdate) {
        continuations.values.forEach { $0.yield(update) }
    }

    private func removeContinuation(_ id: UUID) {
        continuations.removeValue(forKey: id)
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
