import Foundation
import SheepDomain

public enum ConnectionState: Equatable, Sendable {
    case connecting
    case connected
    case disconnected(String)
    case unavailable(String)
}

public struct SessionUpdate: Equatable, Sendable {
    public let connection: ConnectionState
    public let session: HerdrSession?

    public init(connection: ConnectionState, session: HerdrSession?) {
        self.connection = connection
        self.session = session
    }
}

public protocol HerdrSessionRepository: Sendable {
    func observeSession() async -> AsyncStream<SessionUpdate>
    func refresh() async
    func focusWorkspace(_ id: WorkspaceID) async throws
    func focusTab(_ id: TabID) async throws
    func focusPane(_ id: PaneID) async throws
    func createWorkspace(cwd: URL) async throws
    func createTab(workspaceID: WorkspaceID) async throws
    func exportLayout(tabID: TabID) async throws -> PaneLayout
    func setSplitRatio(tabID: TabID, path: [Bool], ratio: Double) async throws
}

public protocol HerdrServerSupervisor: Sendable {
    func ensureRunning() async throws -> URL
}

public protocol GitStatusProvider: Sendable {
    func summary(for directory: URL) async -> GitSummary?
}

