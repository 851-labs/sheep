// Generated from Herdr protocol 17, schema 1.
// Do not edit by hand; run Tools/HerdrSDKGenerator/generate.mjs.
// To parse the JSON, add this file to your project and do:
//
//   let herdrEventTypes = try HerdrEventTypes(json)

import Foundation

// MARK: - HerdrEventTypes
public struct HerdrEventTypes: Codable, Sendable {
    public let eventEnvelope: HerdrEventEventEnvelope

    public enum CodingKeys: String, CodingKey {
        case eventEnvelope = "EventEnvelope"
    }

    public init(eventEnvelope: HerdrEventEventEnvelope) {
        self.eventEnvelope = eventEnvelope
    }
}

// MARK: HerdrEventTypes convenience initializers and mutators

public extension HerdrEventTypes {
    init(data: Data) throws {
        self = try newHerdrEventJSONDecoder().decode(HerdrEventTypes.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        eventEnvelope: HerdrEventEventEnvelope? = nil
    ) -> HerdrEventTypes {
        return HerdrEventTypes(
            eventEnvelope: eventEnvelope ?? self.eventEnvelope
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrEventJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrEventEventEnvelope
public struct HerdrEventEventEnvelope: Codable, Sendable {
    public let data: HerdrEventData
    public let event: HerdrEventEvent

    public enum CodingKeys: String, CodingKey {
        case data = "data"
        case event = "event"
    }

    public init(data: HerdrEventData, event: HerdrEventEvent) {
        self.data = data
        self.event = event
    }
}

// MARK: HerdrEventEventEnvelope convenience initializers and mutators

public extension HerdrEventEventEnvelope {
    init(data: Data) throws {
        self = try newHerdrEventJSONDecoder().decode(HerdrEventEventEnvelope.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        data: HerdrEventData? = nil,
        event: HerdrEventEvent? = nil
    ) -> HerdrEventEventEnvelope {
        return HerdrEventEventEnvelope(
            data: data ?? self.data,
            event: event ?? self.event
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrEventJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrEventData
public struct HerdrEventData: Codable, Sendable {
    public let type: HerdrEventEvent
    public let workspace: HerdrEventWorkspace?
    public let workspaceID: WorkspaceID?
    public let label: String?
    public let insertIndex: Int?
    public let workspaces: [HerdrEventWorkspace]?
    public let worktree: HerdrEventWorktree?
    public let alreadyOpen: Bool?
    public let forced: Bool?
    public let tab: HerdrEventTab?
    public let tabID: TabID?
    public let tabs: [HerdrEventTab]?
    public let pane: HerdrEventPane?
    public let paneID: PaneID?
    public let closedTabID: TabID?
    public let closedWorkspaceID: WorkspaceID?
    public let createdTab: HerdrEventTab?
    public let createdWorkspace: HerdrEventWorkspace?
    public let previousPaneID: PaneID?
    public let previousTabID: TabID?
    public let previousWorkspaceID: WorkspaceID?
    public let revision: Int?
    public let agent: String?
    public let finalStatus: HerdrEventAgentStatus?
    public let released: Bool?
    public let agentStatus: HerdrEventAgentStatus?
    public let displayAgent: String?
    public let stateLabels: [String: String]?
    public let title: String?
    public let layout: HerdrEventLayout?

    public enum CodingKeys: String, CodingKey {
        case type = "type"
        case workspace = "workspace"
        case workspaceID = "workspace_id"
        case label = "label"
        case insertIndex = "insert_index"
        case workspaces = "workspaces"
        case worktree = "worktree"
        case alreadyOpen = "already_open"
        case forced = "forced"
        case tab = "tab"
        case tabID = "tab_id"
        case tabs = "tabs"
        case pane = "pane"
        case paneID = "pane_id"
        case closedTabID = "closed_tab_id"
        case closedWorkspaceID = "closed_workspace_id"
        case createdTab = "created_tab"
        case createdWorkspace = "created_workspace"
        case previousPaneID = "previous_pane_id"
        case previousTabID = "previous_tab_id"
        case previousWorkspaceID = "previous_workspace_id"
        case revision = "revision"
        case agent = "agent"
        case finalStatus = "final_status"
        case released = "released"
        case agentStatus = "agent_status"
        case displayAgent = "display_agent"
        case stateLabels = "state_labels"
        case title = "title"
        case layout = "layout"
    }

    public init(type: HerdrEventEvent, workspace: HerdrEventWorkspace?, workspaceID: WorkspaceID?, label: String?, insertIndex: Int?, workspaces: [HerdrEventWorkspace]?, worktree: HerdrEventWorktree?, alreadyOpen: Bool?, forced: Bool?, tab: HerdrEventTab?, tabID: TabID?, tabs: [HerdrEventTab]?, pane: HerdrEventPane?, paneID: PaneID?, closedTabID: TabID?, closedWorkspaceID: WorkspaceID?, createdTab: HerdrEventTab?, createdWorkspace: HerdrEventWorkspace?, previousPaneID: PaneID?, previousTabID: TabID?, previousWorkspaceID: WorkspaceID?, revision: Int?, agent: String?, finalStatus: HerdrEventAgentStatus?, released: Bool?, agentStatus: HerdrEventAgentStatus?, displayAgent: String?, stateLabels: [String: String]?, title: String?, layout: HerdrEventLayout?) {
        self.type = type
        self.workspace = workspace
        self.workspaceID = workspaceID
        self.label = label
        self.insertIndex = insertIndex
        self.workspaces = workspaces
        self.worktree = worktree
        self.alreadyOpen = alreadyOpen
        self.forced = forced
        self.tab = tab
        self.tabID = tabID
        self.tabs = tabs
        self.pane = pane
        self.paneID = paneID
        self.closedTabID = closedTabID
        self.closedWorkspaceID = closedWorkspaceID
        self.createdTab = createdTab
        self.createdWorkspace = createdWorkspace
        self.previousPaneID = previousPaneID
        self.previousTabID = previousTabID
        self.previousWorkspaceID = previousWorkspaceID
        self.revision = revision
        self.agent = agent
        self.finalStatus = finalStatus
        self.released = released
        self.agentStatus = agentStatus
        self.displayAgent = displayAgent
        self.stateLabels = stateLabels
        self.title = title
        self.layout = layout
    }
}

// MARK: HerdrEventData convenience initializers and mutators

public extension HerdrEventData {
    init(data: Data) throws {
        self = try newHerdrEventJSONDecoder().decode(HerdrEventData.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        type: HerdrEventEvent? = nil,
        workspace: HerdrEventWorkspace?? = nil,
        workspaceID: WorkspaceID?? = nil,
        label: String?? = nil,
        insertIndex: Int?? = nil,
        workspaces: [HerdrEventWorkspace]?? = nil,
        worktree: HerdrEventWorktree?? = nil,
        alreadyOpen: Bool?? = nil,
        forced: Bool?? = nil,
        tab: HerdrEventTab?? = nil,
        tabID: TabID?? = nil,
        tabs: [HerdrEventTab]?? = nil,
        pane: HerdrEventPane?? = nil,
        paneID: PaneID?? = nil,
        closedTabID: TabID?? = nil,
        closedWorkspaceID: WorkspaceID?? = nil,
        createdTab: HerdrEventTab?? = nil,
        createdWorkspace: HerdrEventWorkspace?? = nil,
        previousPaneID: PaneID?? = nil,
        previousTabID: TabID?? = nil,
        previousWorkspaceID: WorkspaceID?? = nil,
        revision: Int?? = nil,
        agent: String?? = nil,
        finalStatus: HerdrEventAgentStatus?? = nil,
        released: Bool?? = nil,
        agentStatus: HerdrEventAgentStatus?? = nil,
        displayAgent: String?? = nil,
        stateLabels: [String: String]?? = nil,
        title: String?? = nil,
        layout: HerdrEventLayout?? = nil
    ) -> HerdrEventData {
        return HerdrEventData(
            type: type ?? self.type,
            workspace: workspace ?? self.workspace,
            workspaceID: workspaceID ?? self.workspaceID,
            label: label ?? self.label,
            insertIndex: insertIndex ?? self.insertIndex,
            workspaces: workspaces ?? self.workspaces,
            worktree: worktree ?? self.worktree,
            alreadyOpen: alreadyOpen ?? self.alreadyOpen,
            forced: forced ?? self.forced,
            tab: tab ?? self.tab,
            tabID: tabID ?? self.tabID,
            tabs: tabs ?? self.tabs,
            pane: pane ?? self.pane,
            paneID: paneID ?? self.paneID,
            closedTabID: closedTabID ?? self.closedTabID,
            closedWorkspaceID: closedWorkspaceID ?? self.closedWorkspaceID,
            createdTab: createdTab ?? self.createdTab,
            createdWorkspace: createdWorkspace ?? self.createdWorkspace,
            previousPaneID: previousPaneID ?? self.previousPaneID,
            previousTabID: previousTabID ?? self.previousTabID,
            previousWorkspaceID: previousWorkspaceID ?? self.previousWorkspaceID,
            revision: revision ?? self.revision,
            agent: agent ?? self.agent,
            finalStatus: finalStatus ?? self.finalStatus,
            released: released ?? self.released,
            agentStatus: agentStatus ?? self.agentStatus,
            displayAgent: displayAgent ?? self.displayAgent,
            stateLabels: stateLabels ?? self.stateLabels,
            title: title ?? self.title,
            layout: layout ?? self.layout
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrEventJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrEventAgentStatus: String, Codable, Sendable {
    case blocked = "blocked"
    case done = "done"
    case idle = "idle"
    case unknown = "unknown"
    case working = "working"
}

// MARK: - HerdrEventTab
public struct HerdrEventTab: Codable, Sendable {
    public let agentStatus: HerdrEventAgentStatus
    public let focused: Bool
    public let label: String
    public let number: Int
    public let paneCount: Int
    public let tabID: TabID
    public let workspaceID: WorkspaceID

    public enum CodingKeys: String, CodingKey {
        case agentStatus = "agent_status"
        case focused = "focused"
        case label = "label"
        case number = "number"
        case paneCount = "pane_count"
        case tabID = "tab_id"
        case workspaceID = "workspace_id"
    }

    public init(agentStatus: HerdrEventAgentStatus, focused: Bool, label: String, number: Int, paneCount: Int, tabID: TabID, workspaceID: WorkspaceID) {
        self.agentStatus = agentStatus
        self.focused = focused
        self.label = label
        self.number = number
        self.paneCount = paneCount
        self.tabID = tabID
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrEventTab convenience initializers and mutators

public extension HerdrEventTab {
    init(data: Data) throws {
        self = try newHerdrEventJSONDecoder().decode(HerdrEventTab.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        agentStatus: HerdrEventAgentStatus? = nil,
        focused: Bool? = nil,
        label: String? = nil,
        number: Int? = nil,
        paneCount: Int? = nil,
        tabID: TabID? = nil,
        workspaceID: WorkspaceID? = nil
    ) -> HerdrEventTab {
        return HerdrEventTab(
            agentStatus: agentStatus ?? self.agentStatus,
            focused: focused ?? self.focused,
            label: label ?? self.label,
            number: number ?? self.number,
            paneCount: paneCount ?? self.paneCount,
            tabID: tabID ?? self.tabID,
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrEventJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrEventWorkspace
public struct HerdrEventWorkspace: Codable, Sendable {
    public let activeTabID: TabID
    public let agentStatus: HerdrEventAgentStatus
    public let focused: Bool
    public let label: String
    public let number: Int
    public let paneCount: Int
    public let tabCount: Int
    public let tokens: [String: String]?
    public let workspaceID: WorkspaceID
    public let worktree: HerdrEventWorktreeClass?

    public enum CodingKeys: String, CodingKey {
        case activeTabID = "active_tab_id"
        case agentStatus = "agent_status"
        case focused = "focused"
        case label = "label"
        case number = "number"
        case paneCount = "pane_count"
        case tabCount = "tab_count"
        case tokens = "tokens"
        case workspaceID = "workspace_id"
        case worktree = "worktree"
    }

    public init(activeTabID: TabID, agentStatus: HerdrEventAgentStatus, focused: Bool, label: String, number: Int, paneCount: Int, tabCount: Int, tokens: [String: String]?, workspaceID: WorkspaceID, worktree: HerdrEventWorktreeClass?) {
        self.activeTabID = activeTabID
        self.agentStatus = agentStatus
        self.focused = focused
        self.label = label
        self.number = number
        self.paneCount = paneCount
        self.tabCount = tabCount
        self.tokens = tokens
        self.workspaceID = workspaceID
        self.worktree = worktree
    }
}

// MARK: HerdrEventWorkspace convenience initializers and mutators

public extension HerdrEventWorkspace {
    init(data: Data) throws {
        self = try newHerdrEventJSONDecoder().decode(HerdrEventWorkspace.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        activeTabID: TabID? = nil,
        agentStatus: HerdrEventAgentStatus? = nil,
        focused: Bool? = nil,
        label: String? = nil,
        number: Int? = nil,
        paneCount: Int? = nil,
        tabCount: Int? = nil,
        tokens: [String: String]?? = nil,
        workspaceID: WorkspaceID? = nil,
        worktree: HerdrEventWorktreeClass?? = nil
    ) -> HerdrEventWorkspace {
        return HerdrEventWorkspace(
            activeTabID: activeTabID ?? self.activeTabID,
            agentStatus: agentStatus ?? self.agentStatus,
            focused: focused ?? self.focused,
            label: label ?? self.label,
            number: number ?? self.number,
            paneCount: paneCount ?? self.paneCount,
            tabCount: tabCount ?? self.tabCount,
            tokens: tokens ?? self.tokens,
            workspaceID: workspaceID ?? self.workspaceID,
            worktree: worktree ?? self.worktree
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrEventJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrEventWorktreeClass
public struct HerdrEventWorktreeClass: Codable, Sendable {
    public let checkoutPath: String
    public let isLinkedWorktree: Bool
    public let repoKey: String
    public let repoName: String
    public let repoRoot: String

    public enum CodingKeys: String, CodingKey {
        case checkoutPath = "checkout_path"
        case isLinkedWorktree = "is_linked_worktree"
        case repoKey = "repo_key"
        case repoName = "repo_name"
        case repoRoot = "repo_root"
    }

    public init(checkoutPath: String, isLinkedWorktree: Bool, repoKey: String, repoName: String, repoRoot: String) {
        self.checkoutPath = checkoutPath
        self.isLinkedWorktree = isLinkedWorktree
        self.repoKey = repoKey
        self.repoName = repoName
        self.repoRoot = repoRoot
    }
}

// MARK: HerdrEventWorktreeClass convenience initializers and mutators

public extension HerdrEventWorktreeClass {
    init(data: Data) throws {
        self = try newHerdrEventJSONDecoder().decode(HerdrEventWorktreeClass.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        checkoutPath: String? = nil,
        isLinkedWorktree: Bool? = nil,
        repoKey: String? = nil,
        repoName: String? = nil,
        repoRoot: String? = nil
    ) -> HerdrEventWorktreeClass {
        return HerdrEventWorktreeClass(
            checkoutPath: checkoutPath ?? self.checkoutPath,
            isLinkedWorktree: isLinkedWorktree ?? self.isLinkedWorktree,
            repoKey: repoKey ?? self.repoKey,
            repoName: repoName ?? self.repoName,
            repoRoot: repoRoot ?? self.repoRoot
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrEventJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrEventLayout
public struct HerdrEventLayout: Codable, Sendable {
    public let area: HerdrEventArea
    public let focusedPaneID: PaneID
    public let panes: [HerdrEventPaneElement]
    public let splits: [HerdrEventSplitElement]
    public let tabID: TabID
    public let workspaceID: WorkspaceID
    public let zoomed: Bool

    public enum CodingKeys: String, CodingKey {
        case area = "area"
        case focusedPaneID = "focused_pane_id"
        case panes = "panes"
        case splits = "splits"
        case tabID = "tab_id"
        case workspaceID = "workspace_id"
        case zoomed = "zoomed"
    }

    public init(area: HerdrEventArea, focusedPaneID: PaneID, panes: [HerdrEventPaneElement], splits: [HerdrEventSplitElement], tabID: TabID, workspaceID: WorkspaceID, zoomed: Bool) {
        self.area = area
        self.focusedPaneID = focusedPaneID
        self.panes = panes
        self.splits = splits
        self.tabID = tabID
        self.workspaceID = workspaceID
        self.zoomed = zoomed
    }
}

// MARK: HerdrEventLayout convenience initializers and mutators

public extension HerdrEventLayout {
    init(data: Data) throws {
        self = try newHerdrEventJSONDecoder().decode(HerdrEventLayout.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        area: HerdrEventArea? = nil,
        focusedPaneID: PaneID? = nil,
        panes: [HerdrEventPaneElement]? = nil,
        splits: [HerdrEventSplitElement]? = nil,
        tabID: TabID? = nil,
        workspaceID: WorkspaceID? = nil,
        zoomed: Bool? = nil
    ) -> HerdrEventLayout {
        return HerdrEventLayout(
            area: area ?? self.area,
            focusedPaneID: focusedPaneID ?? self.focusedPaneID,
            panes: panes ?? self.panes,
            splits: splits ?? self.splits,
            tabID: tabID ?? self.tabID,
            workspaceID: workspaceID ?? self.workspaceID,
            zoomed: zoomed ?? self.zoomed
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrEventJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrEventArea
public struct HerdrEventArea: Codable, Sendable {
    public let height: Int
    public let width: Int
    public let x: Int
    public let y: Int

    public enum CodingKeys: String, CodingKey {
        case height = "height"
        case width = "width"
        case x = "x"
        case y = "y"
    }

    public init(height: Int, width: Int, x: Int, y: Int) {
        self.height = height
        self.width = width
        self.x = x
        self.y = y
    }
}

// MARK: HerdrEventArea convenience initializers and mutators

public extension HerdrEventArea {
    init(data: Data) throws {
        self = try newHerdrEventJSONDecoder().decode(HerdrEventArea.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        height: Int? = nil,
        width: Int? = nil,
        x: Int? = nil,
        y: Int? = nil
    ) -> HerdrEventArea {
        return HerdrEventArea(
            height: height ?? self.height,
            width: width ?? self.width,
            x: x ?? self.x,
            y: y ?? self.y
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrEventJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrEventPaneElement
public struct HerdrEventPaneElement: Codable, Sendable {
    public let focused: Bool
    public let paneID: PaneID
    public let rect: HerdrEventArea

    public enum CodingKeys: String, CodingKey {
        case focused = "focused"
        case paneID = "pane_id"
        case rect = "rect"
    }

    public init(focused: Bool, paneID: PaneID, rect: HerdrEventArea) {
        self.focused = focused
        self.paneID = paneID
        self.rect = rect
    }
}

// MARK: HerdrEventPaneElement convenience initializers and mutators

public extension HerdrEventPaneElement {
    init(data: Data) throws {
        self = try newHerdrEventJSONDecoder().decode(HerdrEventPaneElement.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        focused: Bool? = nil,
        paneID: PaneID? = nil,
        rect: HerdrEventArea? = nil
    ) -> HerdrEventPaneElement {
        return HerdrEventPaneElement(
            focused: focused ?? self.focused,
            paneID: paneID ?? self.paneID,
            rect: rect ?? self.rect
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrEventJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrEventSplitElement
public struct HerdrEventSplitElement: Codable, Sendable {
    public let direction: HerdrEventDirection
    public let id: String
    public let ratio: Double
    public let rect: HerdrEventArea

    public enum CodingKeys: String, CodingKey {
        case direction = "direction"
        case id = "id"
        case ratio = "ratio"
        case rect = "rect"
    }

    public init(direction: HerdrEventDirection, id: String, ratio: Double, rect: HerdrEventArea) {
        self.direction = direction
        self.id = id
        self.ratio = ratio
        self.rect = rect
    }
}

// MARK: HerdrEventSplitElement convenience initializers and mutators

public extension HerdrEventSplitElement {
    init(data: Data) throws {
        self = try newHerdrEventJSONDecoder().decode(HerdrEventSplitElement.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        direction: HerdrEventDirection? = nil,
        id: String? = nil,
        ratio: Double? = nil,
        rect: HerdrEventArea? = nil
    ) -> HerdrEventSplitElement {
        return HerdrEventSplitElement(
            direction: direction ?? self.direction,
            id: id ?? self.id,
            ratio: ratio ?? self.ratio,
            rect: rect ?? self.rect
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrEventJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrEventDirection: String, Codable, Sendable {
    case directionRight = "right"
    case down = "down"
}

// MARK: - HerdrEventPane
public struct HerdrEventPane: Codable, Sendable {
    public let agent: String?
    public let agentSession: HerdrEventAgentSessionClass?
    public let agentStatus: HerdrEventAgentStatus
    public let cwd: String?
    public let displayAgent: String?
    public let focused: Bool
    public let foregroundCwd: String?
    public let label: String?
    public let paneID: PaneID
    public let revision: Int
    public let scroll: HerdrEventScrollClass?
    public let stateLabels: [String: String]?
    public let tabID: TabID
    public let terminalID: TerminalID
    public let terminalTitle: String?
    public let terminalTitleStripped: String?
    public let title: String?
    public let tokens: [String: String]?
    public let workspaceID: WorkspaceID

    public enum CodingKeys: String, CodingKey {
        case agent = "agent"
        case agentSession = "agent_session"
        case agentStatus = "agent_status"
        case cwd = "cwd"
        case displayAgent = "display_agent"
        case focused = "focused"
        case foregroundCwd = "foreground_cwd"
        case label = "label"
        case paneID = "pane_id"
        case revision = "revision"
        case scroll = "scroll"
        case stateLabels = "state_labels"
        case tabID = "tab_id"
        case terminalID = "terminal_id"
        case terminalTitle = "terminal_title"
        case terminalTitleStripped = "terminal_title_stripped"
        case title = "title"
        case tokens = "tokens"
        case workspaceID = "workspace_id"
    }

    public init(agent: String?, agentSession: HerdrEventAgentSessionClass?, agentStatus: HerdrEventAgentStatus, cwd: String?, displayAgent: String?, focused: Bool, foregroundCwd: String?, label: String?, paneID: PaneID, revision: Int, scroll: HerdrEventScrollClass?, stateLabels: [String: String]?, tabID: TabID, terminalID: TerminalID, terminalTitle: String?, terminalTitleStripped: String?, title: String?, tokens: [String: String]?, workspaceID: WorkspaceID) {
        self.agent = agent
        self.agentSession = agentSession
        self.agentStatus = agentStatus
        self.cwd = cwd
        self.displayAgent = displayAgent
        self.focused = focused
        self.foregroundCwd = foregroundCwd
        self.label = label
        self.paneID = paneID
        self.revision = revision
        self.scroll = scroll
        self.stateLabels = stateLabels
        self.tabID = tabID
        self.terminalID = terminalID
        self.terminalTitle = terminalTitle
        self.terminalTitleStripped = terminalTitleStripped
        self.title = title
        self.tokens = tokens
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrEventPane convenience initializers and mutators

public extension HerdrEventPane {
    init(data: Data) throws {
        self = try newHerdrEventJSONDecoder().decode(HerdrEventPane.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        agent: String?? = nil,
        agentSession: HerdrEventAgentSessionClass?? = nil,
        agentStatus: HerdrEventAgentStatus? = nil,
        cwd: String?? = nil,
        displayAgent: String?? = nil,
        focused: Bool? = nil,
        foregroundCwd: String?? = nil,
        label: String?? = nil,
        paneID: PaneID? = nil,
        revision: Int? = nil,
        scroll: HerdrEventScrollClass?? = nil,
        stateLabels: [String: String]?? = nil,
        tabID: TabID? = nil,
        terminalID: TerminalID? = nil,
        terminalTitle: String?? = nil,
        terminalTitleStripped: String?? = nil,
        title: String?? = nil,
        tokens: [String: String]?? = nil,
        workspaceID: WorkspaceID? = nil
    ) -> HerdrEventPane {
        return HerdrEventPane(
            agent: agent ?? self.agent,
            agentSession: agentSession ?? self.agentSession,
            agentStatus: agentStatus ?? self.agentStatus,
            cwd: cwd ?? self.cwd,
            displayAgent: displayAgent ?? self.displayAgent,
            focused: focused ?? self.focused,
            foregroundCwd: foregroundCwd ?? self.foregroundCwd,
            label: label ?? self.label,
            paneID: paneID ?? self.paneID,
            revision: revision ?? self.revision,
            scroll: scroll ?? self.scroll,
            stateLabels: stateLabels ?? self.stateLabels,
            tabID: tabID ?? self.tabID,
            terminalID: terminalID ?? self.terminalID,
            terminalTitle: terminalTitle ?? self.terminalTitle,
            terminalTitleStripped: terminalTitleStripped ?? self.terminalTitleStripped,
            title: title ?? self.title,
            tokens: tokens ?? self.tokens,
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrEventJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrEventAgentSessionClass
public struct HerdrEventAgentSessionClass: Codable, Sendable {
    public let agent: String
    public let kind: HerdrEventKind
    public let source: String
    public let value: String

    public enum CodingKeys: String, CodingKey {
        case agent = "agent"
        case kind = "kind"
        case source = "source"
        case value = "value"
    }

    public init(agent: String, kind: HerdrEventKind, source: String, value: String) {
        self.agent = agent
        self.kind = kind
        self.source = source
        self.value = value
    }
}

// MARK: HerdrEventAgentSessionClass convenience initializers and mutators

public extension HerdrEventAgentSessionClass {
    init(data: Data) throws {
        self = try newHerdrEventJSONDecoder().decode(HerdrEventAgentSessionClass.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        agent: String? = nil,
        kind: HerdrEventKind? = nil,
        source: String? = nil,
        value: String? = nil
    ) -> HerdrEventAgentSessionClass {
        return HerdrEventAgentSessionClass(
            agent: agent ?? self.agent,
            kind: kind ?? self.kind,
            source: source ?? self.source,
            value: value ?? self.value
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrEventJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrEventKind: String, Codable, Sendable {
    case id = "id"
    case path = "path"
}

// MARK: - HerdrEventScrollClass
public struct HerdrEventScrollClass: Codable, Sendable {
    public let maxOffsetFromBottom: Int
    public let offsetFromBottom: Int
    public let viewportRows: Int

    public enum CodingKeys: String, CodingKey {
        case maxOffsetFromBottom = "max_offset_from_bottom"
        case offsetFromBottom = "offset_from_bottom"
        case viewportRows = "viewport_rows"
    }

    public init(maxOffsetFromBottom: Int, offsetFromBottom: Int, viewportRows: Int) {
        self.maxOffsetFromBottom = maxOffsetFromBottom
        self.offsetFromBottom = offsetFromBottom
        self.viewportRows = viewportRows
    }
}

// MARK: HerdrEventScrollClass convenience initializers and mutators

public extension HerdrEventScrollClass {
    init(data: Data) throws {
        self = try newHerdrEventJSONDecoder().decode(HerdrEventScrollClass.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        maxOffsetFromBottom: Int? = nil,
        offsetFromBottom: Int? = nil,
        viewportRows: Int? = nil
    ) -> HerdrEventScrollClass {
        return HerdrEventScrollClass(
            maxOffsetFromBottom: maxOffsetFromBottom ?? self.maxOffsetFromBottom,
            offsetFromBottom: offsetFromBottom ?? self.offsetFromBottom,
            viewportRows: viewportRows ?? self.viewportRows
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrEventJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrEventEvent: String, Codable, Sendable {
    case layoutUpdated = "layout_updated"
    case paneAgentDetected = "pane_agent_detected"
    case paneAgentStatusChanged = "pane_agent_status_changed"
    case paneClosed = "pane_closed"
    case paneCreated = "pane_created"
    case paneExited = "pane_exited"
    case paneFocused = "pane_focused"
    case paneMoved = "pane_moved"
    case paneOutputChanged = "pane_output_changed"
    case paneUpdated = "pane_updated"
    case tabClosed = "tab_closed"
    case tabCreated = "tab_created"
    case tabFocused = "tab_focused"
    case tabMoved = "tab_moved"
    case tabRenamed = "tab_renamed"
    case workspaceClosed = "workspace_closed"
    case workspaceCreated = "workspace_created"
    case workspaceFocused = "workspace_focused"
    case workspaceMetadataUpdated = "workspace_metadata_updated"
    case workspaceMoved = "workspace_moved"
    case workspaceRenamed = "workspace_renamed"
    case workspaceUpdated = "workspace_updated"
    case worktreeCreated = "worktree_created"
    case worktreeOpened = "worktree_opened"
    case worktreeRemoved = "worktree_removed"
}

// MARK: - HerdrEventWorktree
public struct HerdrEventWorktree: Codable, Sendable {
    public let branch: String?
    public let isBare: Bool
    public let isDetached: Bool
    public let isLinkedWorktree: Bool
    public let isPrunable: Bool
    public let label: String
    public let openWorkspaceID: WorkspaceID?
    public let path: String

    public enum CodingKeys: String, CodingKey {
        case branch = "branch"
        case isBare = "is_bare"
        case isDetached = "is_detached"
        case isLinkedWorktree = "is_linked_worktree"
        case isPrunable = "is_prunable"
        case label = "label"
        case openWorkspaceID = "open_workspace_id"
        case path = "path"
    }

    public init(branch: String?, isBare: Bool, isDetached: Bool, isLinkedWorktree: Bool, isPrunable: Bool, label: String, openWorkspaceID: WorkspaceID?, path: String) {
        self.branch = branch
        self.isBare = isBare
        self.isDetached = isDetached
        self.isLinkedWorktree = isLinkedWorktree
        self.isPrunable = isPrunable
        self.label = label
        self.openWorkspaceID = openWorkspaceID
        self.path = path
    }
}

// MARK: HerdrEventWorktree convenience initializers and mutators

public extension HerdrEventWorktree {
    init(data: Data) throws {
        self = try newHerdrEventJSONDecoder().decode(HerdrEventWorktree.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        branch: String?? = nil,
        isBare: Bool? = nil,
        isDetached: Bool? = nil,
        isLinkedWorktree: Bool? = nil,
        isPrunable: Bool? = nil,
        label: String? = nil,
        openWorkspaceID: WorkspaceID?? = nil,
        path: String? = nil
    ) -> HerdrEventWorktree {
        return HerdrEventWorktree(
            branch: branch ?? self.branch,
            isBare: isBare ?? self.isBare,
            isDetached: isDetached ?? self.isDetached,
            isLinkedWorktree: isLinkedWorktree ?? self.isLinkedWorktree,
            isPrunable: isPrunable ?? self.isPrunable,
            label: label ?? self.label,
            openWorkspaceID: openWorkspaceID ?? self.openWorkspaceID,
            path: path ?? self.path
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrEventJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newHerdrEventJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newHerdrEventJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
