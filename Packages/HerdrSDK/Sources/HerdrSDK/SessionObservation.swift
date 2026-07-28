import Foundation

public enum HerdrConnectionState: Equatable, Sendable {
    case connecting
    case connected
    case disconnected(String)
    case unavailable(String)
}

public struct HerdrSessionUpdate: Equatable, Sendable {
    public let connection: HerdrConnectionState
    public let session: HerdrSession?

    public init(connection: HerdrConnectionState, session: HerdrSession?) {
        self.connection = connection
        self.session = session
    }
}

public protocol HerdrSessionClient: Sendable {
    func sessionUpdates() async -> AsyncStream<HerdrSessionUpdate>
    func refreshSession() async
    func focusWorkspace(_ id: WorkspaceID) async throws
    func focusTab(_ id: TabID) async throws
    func focusPane(_ id: PaneID) async throws
    func createWorkspace(cwd: URL) async throws
    func createTab(workspaceID: WorkspaceID) async throws
    func exportLayout(tabID: TabID) async throws -> PaneLayout
    func setSplitRatio(tabID: TabID, path: [Bool], ratio: Double) async throws
}

extension HerdrClient: HerdrSessionClient {
    public func focusWorkspace(_ id: WorkspaceID) async throws {
        try await workspaces.focus(id)
    }

    public func focusTab(_ id: TabID) async throws {
        try await tabs.focus(id)
    }

    public func focusPane(_ id: PaneID) async throws {
        try await panes.focus(id)
    }

    public func createWorkspace(cwd: URL) async throws {
        _ = try await workspaces.create(cwd: cwd)
    }

    public func createTab(workspaceID: WorkspaceID) async throws {
        _ = try await tabs.create(in: workspaceID)
    }

    public func exportLayout(tabID: TabID) async throws -> PaneLayout {
        try await layouts.export(tabID: tabID)
    }

    public func setSplitRatio(
        tabID: TabID,
        path: [Bool],
        ratio: Double
    ) async throws {
        _ = try await layouts.setSplitRatio(tabID: tabID, path: path, ratio: ratio)
    }
}

let lifecycleFilters = [
    "workspace.created",
    "workspace.updated",
    "workspace.metadata_updated",
    "workspace.renamed",
    "workspace.moved",
    "workspace.closed",
    "workspace.focused",
    "worktree.created",
    "worktree.opened",
    "worktree.removed",
    "tab.created",
    "tab.closed",
    "tab.focused",
    "tab.renamed",
    "tab.moved",
    "pane.created",
    "pane.closed",
    "pane.updated",
    "pane.focused",
    "pane.moved",
    "pane.exited",
    "pane.agent_detected",
    "layout.updated",
].map { HerdrEventFilter(type: $0) }

extension HerdrClient {
    public func sessionUpdates() async -> AsyncStream<HerdrSessionUpdate> {
        let id = UUID()
        let (stream, continuation) = AsyncStream.makeStream(of: HerdrSessionUpdate.self)
        continuation.onTermination = { [weak self] _ in
            Task { await self?.removeSessionContinuation(id) }
        }
        sessionContinuations[id] = continuation
        continuation.yield(
            HerdrSessionUpdate(connection: sessionConnection, session: currentSession)
        )
        startSessionObservationIfNeeded()
        return stream
    }

    public func refreshSession() async {
        do {
            try await refreshAuthoritativeSnapshot()
        } catch {
            requestSessionReconnect(error.localizedDescription)
        }
    }

    func mutationCompleted() {
        scheduleSessionRefresh()
    }

    private func startSessionObservationIfNeeded() {
        guard sessionRunTask == nil else { return }
        sessionRunTask = Task { [weak self] in
            await self?.runSessionObservation()
        }
    }

    private func runSessionObservation() async {
        var retrySeconds: UInt64 = 1
        while !Task.isCancelled {
            publishSession(currentSession == nil ? .connecting : sessionConnection)
            do {
                let snapshot = try await sessions.snapshot()
                currentSession = snapshot
                sessionReconnectReason = nil
                try await startSessionEventSubscription(
                    paneIDs: Set(snapshot.panes.map(\.id))
                )
                publishSession(.connected)
                retrySeconds = 1

                var secondsUntilSafetyRefresh = 5
                while !Task.isCancelled {
                    try await Task.sleep(for: .seconds(1))
                    if let reason = sessionReconnectReason {
                        throw HerdrAPIError(code: "subscription_lost", message: reason)
                    }
                    secondsUntilSafetyRefresh -= 1
                    if secondsUntilSafetyRefresh == 0 {
                        try await refreshAuthoritativeSnapshot()
                        secondsUntilSafetyRefresh = 5
                    }
                }
            } catch {
                stopSessionEventSubscription()
                sessionReconnectReason = nil
                publishSession(
                    currentSession == nil
                        ? .unavailable(error.localizedDescription)
                        : .disconnected(error.localizedDescription)
                )
                try? await Task.sleep(for: .seconds(retrySeconds))
                retrySeconds = min(retrySeconds * 2, 10)
            }
        }
    }

    private func refreshAuthoritativeSnapshot() async throws {
        guard sessionRunTask != nil else { return }
        let snapshot = try await sessions.snapshot()
        currentSession = snapshot
        let paneIDs = Set(snapshot.panes.map(\.id))
        if paneIDs != subscribedPaneIDs {
            try await startSessionEventSubscription(paneIDs: paneIDs)
        }
        publishSession(.connected)
    }

    private func startSessionEventSubscription(paneIDs: Set<PaneID>) async throws {
        let filters = lifecycleFilters
            + paneIDs.sorted { $0.rawValue < $1.rawValue }
                .map(HerdrEventFilter.paneAgentStatusChanged)
        let next = try await makeEventConnection(filters: filters)
        let previous = sessionEventConnection
        sessionEventConnection = next
        subscribedPaneIDs = paneIDs
        sessionEventTask?.cancel()
        previous?.cancel()

        let owner = self
        sessionEventTask = Task.detached {
            do {
                try next.run { _ in
                    Task { await owner.scheduleSessionRefresh() }
                }
            } catch {
                await owner.sessionSubscriptionDisconnected(
                    error,
                    connection: next
                )
            }
        }
    }

    private func sessionSubscriptionDisconnected(
        _ error: Error,
        connection: HerdrEventConnection
    ) {
        guard sessionEventConnection === connection else { return }
        requestSessionReconnect(error.localizedDescription)
    }

    private func scheduleSessionRefresh() {
        guard sessionRunTask != nil else { return }
        sessionRefreshTask?.cancel()
        sessionRefreshTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(75))
            await self?.refreshSession()
        }
    }

    private func requestSessionReconnect(_ reason: String) {
        sessionReconnectReason = reason
        publishSession(.disconnected(reason))
    }

    private func stopSessionEventSubscription() {
        let active = sessionEventConnection
        sessionEventConnection = nil
        subscribedPaneIDs = []
        sessionEventTask?.cancel()
        sessionEventTask = nil
        active?.cancel()
    }

    private func publishSession(_ state: HerdrConnectionState) {
        sessionConnection = state
        let update = HerdrSessionUpdate(connection: state, session: currentSession)
        sessionContinuations.values.forEach { $0.yield(update) }
    }

    private func removeSessionContinuation(_ id: UUID) {
        sessionContinuations.removeValue(forKey: id)
        guard sessionContinuations.isEmpty else { return }
        sessionRunTask?.cancel()
        sessionRunTask = nil
        sessionRefreshTask?.cancel()
        sessionRefreshTask = nil
        stopSessionEventSubscription()
        sessionConnection = .connecting
    }
}
