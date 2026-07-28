import Foundation

public enum AgentStatus: String, Codable, CaseIterable, Sendable {
    case idle
    case working
    case blocked
    case done
    case unknown

    public var urgency: Int {
        switch self {
        case .blocked: 5
        case .working: 4
        case .done: 3
        case .idle: 2
        case .unknown: 1
        }
    }
}

public struct HerdrSession: Codable, Equatable, Sendable {
    public let version: String
    public let protocolVersion: UInt
    public let focusedWorkspaceID: WorkspaceID?
    public let focusedTabID: TabID?
    public let focusedPaneID: PaneID?
    public let workspaces: [Workspace]
    public let tabs: [Tab]
    public let panes: [Pane]
    public let layouts: [HerdrLayoutSnapshot]
    public let agents: [Agent]

    public init(
        version: String,
        protocolVersion: UInt,
        focusedWorkspaceID: WorkspaceID?,
        focusedTabID: TabID?,
        focusedPaneID: PaneID?,
        workspaces: [Workspace],
        tabs: [Tab],
        panes: [Pane],
        layouts: [HerdrLayoutSnapshot] = [],
        agents: [Agent]
    ) {
        self.version = version
        self.protocolVersion = protocolVersion
        self.focusedWorkspaceID = focusedWorkspaceID
        self.focusedTabID = focusedTabID
        self.focusedPaneID = focusedPaneID
        self.workspaces = workspaces
        self.tabs = tabs
        self.panes = panes
        self.layouts = layouts
        self.agents = agents
    }

    public var focusedWorkspace: Workspace? {
        guard let focusedWorkspaceID else { return workspaces.first }
        return workspaces.first { $0.id == focusedWorkspaceID } ?? workspaces.first
    }

    public var focusedTab: Tab? {
        if let focusedTabID, let focused = tabs.first(where: { $0.id == focusedTabID }) {
            return focused
        }
        return focusedWorkspace.flatMap { workspace in
            tabs.first { $0.id == workspace.activeTabID }
                ?? tabs(in: workspace.id).first
        }
    }

    public var focusedPane: Pane? {
        if let focusedPaneID, let focused = panes.first(where: { $0.id == focusedPaneID }) {
            return focused
        }
        return focusedTab.flatMap {
            panes(in: $0.id).first(where: \.focused) ?? panes(in: $0.id).first
        }
    }

    public func tabs(in workspaceID: WorkspaceID) -> [Tab] {
        tabs.filter { $0.workspaceID == workspaceID }.sorted { $0.number < $1.number }
    }

    public func panes(in tabID: TabID) -> [Pane] {
        panes.filter { $0.tabID == tabID }
    }

    private enum CodingKeys: String, CodingKey {
        case version
        case protocolVersion = "protocol"
        case focusedWorkspaceID = "focused_workspace_id"
        case focusedTabID = "focused_tab_id"
        case focusedPaneID = "focused_pane_id"
        case workspaces
        case tabs
        case panes
        case layouts
        case agents
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        protocolVersion = try container.decode(UInt.self, forKey: .protocolVersion)
        focusedWorkspaceID = try container.decodeIfPresent(
            WorkspaceID.self,
            forKey: .focusedWorkspaceID
        )
        focusedTabID = try container.decodeIfPresent(TabID.self, forKey: .focusedTabID)
        focusedPaneID = try container.decodeIfPresent(PaneID.self, forKey: .focusedPaneID)
        workspaces = try container.decode([Workspace].self, forKey: .workspaces)
        tabs = try container.decode([Tab].self, forKey: .tabs)
        panes = try container.decode([Pane].self, forKey: .panes)
        layouts = try container.decodeIfPresent(
            [HerdrLayoutSnapshot].self,
            forKey: .layouts
        ) ?? []
        agents = try container.decode([Agent].self, forKey: .agents)
    }
}

public struct HerdrLayoutSnapshot: Codable, Equatable, Sendable {
    public let workspaceID: WorkspaceID
    public let tabID: TabID
    public let zoomed: Bool
    public let area: Rect
    public let focusedPaneID: PaneID
    public let panes: [Pane]
    public let splits: [Split]

    public struct Rect: Codable, Equatable, Sendable {
        public let x: UInt16
        public let y: UInt16
        public let width: UInt16
        public let height: UInt16
    }

    public struct Pane: Codable, Equatable, Sendable {
        public let paneID: PaneID
        public let focused: Bool
        public let rect: Rect

        private enum CodingKeys: String, CodingKey {
            case paneID = "pane_id"
            case focused
            case rect
        }
    }

    public struct Split: Codable, Equatable, Sendable {
        public let id: String
        public let direction: PaneLayout.SplitDirection
        public let ratio: Double
        public let rect: Rect
    }

    private enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case tabID = "tab_id"
        case zoomed
        case area
        case focusedPaneID = "focused_pane_id"
        case panes
        case splits
    }
}

public struct Workspace: Codable, Equatable, Identifiable, Sendable {
    public let id: WorkspaceID
    public let number: Int
    public let label: String
    public let focused: Bool
    public let paneCount: Int
    public let tabCount: Int
    public let activeTabID: TabID
    public let agentStatus: AgentStatus
    public let tokens: [String: String]?
    public let worktree: Worktree?

    public struct Worktree: Codable, Equatable, Sendable {
        public let repositoryName: String
        public let repositoryRoot: String
        public let checkoutPath: String
        public let isLinked: Bool

        private enum CodingKeys: String, CodingKey {
            case repositoryName = "repo_name"
            case repositoryRoot = "repo_root"
            case checkoutPath = "checkout_path"
            case isLinked = "is_linked_worktree"
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id = "workspace_id"
        case number
        case label
        case focused
        case paneCount = "pane_count"
        case tabCount = "tab_count"
        case activeTabID = "active_tab_id"
        case agentStatus = "agent_status"
        case tokens
        case worktree
    }
}

public struct Tab: Codable, Equatable, Identifiable, Sendable {
    public let id: TabID
    public let workspaceID: WorkspaceID
    public let number: Int
    public let label: String
    public let focused: Bool
    public let paneCount: Int
    public let agentStatus: AgentStatus

    private enum CodingKeys: String, CodingKey {
        case id = "tab_id"
        case workspaceID = "workspace_id"
        case number
        case label
        case focused
        case paneCount = "pane_count"
        case agentStatus = "agent_status"
    }
}

public struct Pane: Codable, Equatable, Identifiable, Sendable {
    public let id: PaneID
    public let terminalID: TerminalID
    public let workspaceID: WorkspaceID
    public let tabID: TabID
    public let focused: Bool
    public let cwd: String?
    public let foregroundCWD: String?
    public let label: String?
    public let agent: String?
    public let title: String?
    public let terminalTitle: String?
    public let displayAgent: String?
    public let agentStatus: AgentStatus
    public let revision: UInt64

    public var displayTitle: String {
        displayAgent ?? title ?? terminalTitle ?? label ?? agent ?? "terminal"
    }

    private enum CodingKeys: String, CodingKey {
        case id = "pane_id"
        case terminalID = "terminal_id"
        case workspaceID = "workspace_id"
        case tabID = "tab_id"
        case focused
        case cwd
        case foregroundCWD = "foreground_cwd"
        case label
        case agent
        case title
        case terminalTitle = "terminal_title_stripped"
        case displayAgent = "display_agent"
        case agentStatus = "agent_status"
        case revision
    }
}

public struct Agent: Codable, Equatable, Identifiable, Sendable {
    public var id: PaneID { paneID }
    public let terminalID: TerminalID
    public let name: String?
    public let agent: String?
    public let title: String?
    public let terminalTitle: String?
    public let displayAgent: String?
    public let agentStatus: AgentStatus
    public let workspaceID: WorkspaceID
    public let tabID: TabID
    public let paneID: PaneID
    public let focused: Bool
    public let cwd: String?
    public let foregroundCWD: String?
    public let revision: UInt64

    public var displayName: String {
        displayAgent ?? agent ?? name ?? "agent"
    }

    public var displayContext: String {
        title ?? terminalTitle ?? foregroundCWD ?? cwd ?? ""
    }

    private enum CodingKeys: String, CodingKey {
        case terminalID = "terminal_id"
        case name
        case agent
        case title
        case terminalTitle = "terminal_title_stripped"
        case displayAgent = "display_agent"
        case agentStatus = "agent_status"
        case workspaceID = "workspace_id"
        case tabID = "tab_id"
        case paneID = "pane_id"
        case focused
        case cwd
        case foregroundCWD = "foreground_cwd"
        case revision
    }
}

public struct PaneLayout: Codable, Equatable, Sendable {
    public let workspaceID: WorkspaceID
    public let tabID: TabID
    public let zoomed: Bool
    public let focusedPaneID: PaneID
    public let root: Node

    public init(
        workspaceID: WorkspaceID,
        tabID: TabID,
        zoomed: Bool,
        focusedPaneID: PaneID,
        root: Node
    ) {
        self.workspaceID = workspaceID
        self.tabID = tabID
        self.zoomed = zoomed
        self.focusedPaneID = focusedPaneID
        self.root = root
    }

    private enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case tabID = "tab_id"
        case zoomed
        case focusedPaneID = "focused_pane_id"
        case root
    }

    public indirect enum Node: Equatable, Sendable {
        case pane(PaneID)
        case split(direction: SplitDirection, ratio: Double, first: Node, second: Node)

        public func paneIDs() -> [PaneID] {
            switch self {
            case let .pane(id): [id]
            case let .split(_, _, first, second): first.paneIDs() + second.paneIDs()
            }
        }

        public func leavesWithPaths(path: [Bool] = []) -> [(paneID: PaneID, path: [Bool])] {
            switch self {
            case let .pane(id):
                [(id, path)]
            case let .split(_, _, first, second):
                first.leavesWithPaths(path: path + [false])
                    + second.leavesWithPaths(path: path + [true])
            }
        }
    }

    public enum SplitDirection: String, Codable, Equatable, Sendable {
        case right
        case down
    }

    public var visibleRoot: Node {
        zoomed ? .pane(focusedPaneID) : root
    }
}

extension PaneLayout.Node: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case paneID = "pane_id"
        case direction
        case ratio
        case first
        case second
    }

    private enum Kind: String, Codable {
        case pane
        case split
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Kind.self, forKey: .type) {
        case .pane:
            self = .pane(try container.decode(PaneID.self, forKey: .paneID))
        case .split:
            self = .split(
                direction: try container.decode(PaneLayout.SplitDirection.self, forKey: .direction),
                ratio: try container.decode(Double.self, forKey: .ratio),
                first: try container.decode(Self.self, forKey: .first),
                second: try container.decode(Self.self, forKey: .second)
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .pane(id):
            try container.encode(Kind.pane, forKey: .type)
            try container.encode(id, forKey: .paneID)
        case let .split(direction, ratio, first, second):
            try container.encode(Kind.split, forKey: .type)
            try container.encode(direction, forKey: .direction)
            try container.encode(ratio, forKey: .ratio)
            try container.encode(first, forKey: .first)
            try container.encode(second, forKey: .second)
        }
    }
}
