import Foundation

public struct HerdrServerStatus: Codable, Equatable, Sendable {
    public let version: String
    public let protocolVersion: UInt

    private enum CodingKeys: String, CodingKey {
        case version
        case protocolVersion = "protocol"
    }
}

public struct HerdrWorkspaceCreation: Codable, Equatable, Sendable {
    public let workspace: Workspace
    public let tab: Tab
    public let rootPane: Pane

    private enum CodingKeys: String, CodingKey {
        case workspace
        case tab
        case rootPane = "root_pane"
    }
}

public struct HerdrTabCreation: Codable, Equatable, Sendable {
    public let tab: Tab
    public let rootPane: Pane

    private enum CodingKeys: String, CodingKey {
        case tab
        case rootPane = "root_pane"
    }
}

private struct EmptyParameters: Codable, Sendable {}

private struct WorkspaceTarget: Codable, Sendable {
    let workspaceID: WorkspaceID

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
    }
}

private struct TabTarget: Codable, Sendable {
    let tabID: TabID

    enum CodingKeys: String, CodingKey {
        case tabID = "tab_id"
    }
}

private struct PaneTarget: Codable, Sendable {
    let paneID: PaneID

    enum CodingKeys: String, CodingKey {
        case paneID = "pane_id"
    }
}

private struct WorkspaceCreateParameters: Codable, Sendable {
    let cwd: String?
    let focus: Bool
    let label: String?
    let env: [String: String]
}

private struct TabCreateParameters: Codable, Sendable {
    let workspaceID: WorkspaceID?
    let cwd: String?
    let focus: Bool
    let label: String?
    let env: [String: String]

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case cwd
        case focus
        case label
        case env
    }
}

private struct LayoutExportParameters: Codable, Sendable {
    let tabID: TabID?
    let paneID: PaneID?

    enum CodingKeys: String, CodingKey {
        case tabID = "tab_id"
        case paneID = "pane_id"
    }
}

private struct SplitRatioParameters: Codable, Sendable {
    let tabID: TabID
    let path: [Bool]
    let ratio: Double

    enum CodingKeys: String, CodingKey {
        case tabID = "tab_id"
        case path
        case ratio
    }
}

private struct SnapshotResult: Codable, Sendable {
    let snapshot: HerdrSession
}

private struct LayoutResult: Codable, Sendable {
    let layout: PaneLayout
}

private struct WorkspaceCreationResult: Codable, Sendable {
    let workspace: Workspace
    let tab: Tab
    let rootPane: Pane

    enum CodingKeys: String, CodingKey {
        case workspace
        case tab
        case rootPane = "root_pane"
    }
}

private struct TabCreationResult: Codable, Sendable {
    let tab: Tab
    let rootPane: Pane

    enum CodingKeys: String, CodingKey {
        case tab
        case rootPane = "root_pane"
    }
}

public protocol HerdrService: Sendable {
    var client: HerdrClient { get }
}

public extension HerdrService {
    func send<Parameters: Encodable & Sendable>(
        _ endpoint: HerdrEndpoint<Parameters>
    ) async throws -> HerdrResponseResult {
        try await client.send(endpoint)
    }
}

public struct HerdrServerService: HerdrService {
    public let client: HerdrClient
    init(client: HerdrClient) { self.client = client }

    public func ping() async throws -> HerdrServerStatus {
        try await client.request(
            method: .ping,
            params: EmptyParameters(),
            response: HerdrServerStatus.self
        )
    }
}

public struct HerdrNotificationService: HerdrService {
    public let client: HerdrClient
    init(client: HerdrClient) { self.client = client }
}

public struct HerdrWindowTitleService: HerdrService {
    public let client: HerdrClient
    init(client: HerdrClient) { self.client = client }
}

public struct HerdrSessionService: HerdrService {
    public let client: HerdrClient
    init(client: HerdrClient) { self.client = client }

    public func snapshot() async throws -> HerdrSession {
        let result = try await client.request(
            method: .sessionSnapshot,
            params: EmptyParameters(),
            response: SnapshotResult.self
        )
        try validateCompatibility(result.snapshot)
        return result.snapshot
    }
}

public struct HerdrWorkspaceService: HerdrService {
    public let client: HerdrClient
    init(client: HerdrClient) { self.client = client }

    public func focus(_ id: WorkspaceID) async throws {
        _ = try await client.request(
            method: .workspaceFocus,
            params: WorkspaceTarget(workspaceID: id),
            response: HerdrResponseResult.self
        )
        await client.mutationCompleted()
    }

    public func create(
        cwd: URL? = nil,
        focus: Bool = true,
        label: String? = nil,
        environment: [String: String] = [:]
    ) async throws -> HerdrWorkspaceCreation {
        let result = try await client.request(
            method: .workspaceCreate,
            params: WorkspaceCreateParameters(
                cwd: cwd?.path,
                focus: focus,
                label: label ?? cwd?.lastPathComponent,
                env: environment
            ),
            response: WorkspaceCreationResult.self
        )
        await client.mutationCompleted()
        return HerdrWorkspaceCreation(
            workspace: result.workspace,
            tab: result.tab,
            rootPane: result.rootPane
        )
    }
}

public struct HerdrWorktreeService: HerdrService {
    public let client: HerdrClient
    init(client: HerdrClient) { self.client = client }
}

public struct HerdrTabService: HerdrService {
    public let client: HerdrClient
    init(client: HerdrClient) { self.client = client }

    public func focus(_ id: TabID) async throws {
        _ = try await client.request(
            method: .tabFocus,
            params: TabTarget(tabID: id),
            response: HerdrResponseResult.self
        )
        await client.mutationCompleted()
    }

    public func create(
        in workspaceID: WorkspaceID? = nil,
        cwd: URL? = nil,
        focus: Bool = true,
        label: String? = nil,
        environment: [String: String] = [:]
    ) async throws -> HerdrTabCreation {
        let result = try await client.request(
            method: .tabCreate,
            params: TabCreateParameters(
                workspaceID: workspaceID,
                cwd: cwd?.path,
                focus: focus,
                label: label,
                env: environment
            ),
            response: TabCreationResult.self
        )
        await client.mutationCompleted()
        return HerdrTabCreation(tab: result.tab, rootPane: result.rootPane)
    }
}

public struct HerdrPaneService: HerdrService {
    public let client: HerdrClient
    init(client: HerdrClient) { self.client = client }

    public func focus(_ id: PaneID) async throws {
        _ = try await client.request(
            method: .paneFocus,
            params: PaneTarget(paneID: id),
            response: HerdrResponseResult.self
        )
        await client.mutationCompleted()
    }
}

public struct HerdrLayoutService: HerdrService {
    public let client: HerdrClient
    init(client: HerdrClient) { self.client = client }

    public func export(tabID: TabID? = nil, paneID: PaneID? = nil) async throws -> PaneLayout {
        try await client.request(
            method: .layoutExport,
            params: LayoutExportParameters(tabID: tabID, paneID: paneID),
            response: LayoutResult.self
        ).layout
    }

    @discardableResult
    public func setSplitRatio(
        tabID: TabID,
        path: [Bool],
        ratio: Double
    ) async throws -> PaneLayout {
        let layout = try await client.request(
            method: .layoutSetSplitRatio,
            params: SplitRatioParameters(tabID: tabID, path: path, ratio: ratio),
            response: LayoutResult.self
        ).layout
        await client.mutationCompleted()
        return layout
    }
}

public struct HerdrAgentService: HerdrService {
    public let client: HerdrClient
    init(client: HerdrClient) { self.client = client }
}

public struct HerdrIntegrationService: HerdrService {
    public let client: HerdrClient
    init(client: HerdrClient) { self.client = client }
}

public struct HerdrPluginService: HerdrService {
    public let client: HerdrClient
    init(client: HerdrClient) { self.client = client }
}

func validateCompatibility(_ session: HerdrSession) throws {
    guard session.protocolVersion == UInt(HerdrProtocolMetadata.protocolVersion) else {
        throw HerdrCompatibilityError.protocolMismatch(
            expected: HerdrProtocolMetadata.protocolVersion,
            actual: session.protocolVersion
        )
    }
    let actual = semanticVersion(session.version)
    let minimum = [0, 7, 5]
    guard !actual.lexicographicallyPrecedes(minimum) else {
        throw HerdrCompatibilityError.versionTooOld(
            minimum: "0.7.5",
            actual: session.version
        )
    }
}

private func semanticVersion(_ value: String) -> [Int] {
    let components = value
        .split(separator: "-").first?
        .split(separator: ".")
        .prefix(3)
        .map { Int($0) ?? 0 } ?? []
    return components + Array(repeating: 0, count: max(0, 3 - components.count))
}
