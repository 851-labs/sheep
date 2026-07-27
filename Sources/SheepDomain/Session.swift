import Foundation

public struct HerdrSession: Codable, Equatable, Sendable {
    public let version: String
    public let protocolVersion: UInt
    public let focusedWorkspaceID: WorkspaceID?
    public let focusedTabID: TabID?
    public let focusedPaneID: PaneID?
    public let workspaces: [Workspace]
    public let tabs: [Tab]
    public let panes: [Pane]
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
        self.agents = agents
    }

    public var focusedWorkspace: Workspace? {
        guard let focusedWorkspaceID else { return workspaces.first }
        return workspaces.first { $0.id == focusedWorkspaceID }
    }

    public var focusedTab: Tab? {
        guard let focusedTabID else {
            return focusedWorkspace.flatMap { workspace in
                tabs.first { $0.id == workspace.activeTabID }
            }
        }
        return tabs.first { $0.id == focusedTabID }
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
        case agents
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
    public let tokens: [String: String]
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

