// Generated from Herdr protocol 17, schema 1.
// Do not edit by hand; run Scripts/generate-herdr-sdk.mjs.
// To parse the JSON, add this file to your project and do:
//
//   let herdrResponseTypes = try HerdrResponseTypes(json)

import Foundation

// MARK: - HerdrResponseTypes
public struct HerdrResponseTypes: Codable, Sendable {
    public let responseResult: HerdrResponseResponse

    public enum CodingKeys: String, CodingKey {
        case responseResult = "ResponseResult"
    }

    public init(responseResult: HerdrResponseResponse) {
        self.responseResult = responseResult
    }
}

// MARK: HerdrResponseTypes convenience initializers and mutators

public extension HerdrResponseTypes {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseTypes.self, from: data)
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
        responseResult: HerdrResponseResponse? = nil
    ) -> HerdrResponseTypes {
        return HerdrResponseTypes(
            responseResult: responseResult ?? self.responseResult
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseResponse
public struct HerdrResponseResponse: Codable, Sendable {
    public let capabilities: HerdrResponseCapabilitiesClass?
    public let responseProtocol: Int?
    public let type: HerdrResponseResponseResultType
    public let version: String?
    public let snapshot: HerdrResponseSnapshot?
    public let workspace: HerdrResponseWorkspaceElement?
    public let rootPane: HerdrResponseRootPaneElement?
    public let tab: HerdrResponseTabElement?
    public let workspaces: [HerdrResponseWorkspaceElement]?
    public let source: HerdrResponseAgent?
    public let worktrees: [HerdrResponseDataWorktree]?
    public let worktree: HerdrResponseDataWorktree?
    public let alreadyOpen: Bool?
    public let forced: Bool?
    public let path: String?
    public let workspaceID: WorkspaceID?
    public let tabs: [HerdrResponseTabElement]?
    public let agent: HerdrResponseAgentElement?
    public let argv: [String]?
    public let agents: [HerdrResponseAgentElement]?
    public let active: Bool?
    public let label: String?
    public let pane: HerdrResponseRootPaneElement?
    public let panes: [HerdrResponseRootPaneElement]?
    public let swap: HerdrResponseSwap?
    public let moveResult: HerdrResponseMoveResult?
    public let zoom: HerdrResponseZoom?
    public let layout: HerdrResponseResponseResultLayout?
    public let processInfo: HerdrResponseProcessInfo?
    public let neighbor: HerdrResponseNeighbor?
    public let edges: HerdrResponseEdges?
    public let focus: HerdrResponseFocus?
    public let resize: HerdrResponseRes?
    public let read: HerdrResponseRead?
    public let cellHeightPx: Int?
    public let cellWidthPx: Int?
    public let explain: HerdrResponseJSONValue?
    public let event: HerdrResponseEventClass?
    public let matchedLine: String?
    public let paneID: PaneID?
    public let revision: Int?
    public let reason: HerdrResponseReason?
    public let shown: Bool?
    public let changed: Bool?
    public let details: HerdrResponseDetails?
    public let target: HerdrResponseTarget?
    public let manifests: [HerdrResponseManifestElement]?
    public let lastCheckUnix: Int?
    public let lastResult: String?
    public let plugin: HerdrResponsePlugin?
    public let plugins: [HerdrResponsePlugin]?
    public let pluginID: String?
    public let removed: Bool?
    public let actions: [HerdrResponseResponseResultAction]?
    public let action: HerdrResponseResponseResultAction?
    public let context: HerdrResponseContext?
    public let log: HerdrResponseLog?
    public let logs: [HerdrResponseLog]?
    public let pluginPane: HerdrResponsePluginPaneClass?
    public let diagnostics: [String]?
    public let status: HerdrResponseResponseResultStatus?

    public enum CodingKeys: String, CodingKey {
        case capabilities = "capabilities"
        case responseProtocol = "protocol"
        case type = "type"
        case version = "version"
        case snapshot = "snapshot"
        case workspace = "workspace"
        case rootPane = "root_pane"
        case tab = "tab"
        case workspaces = "workspaces"
        case source = "source"
        case worktrees = "worktrees"
        case worktree = "worktree"
        case alreadyOpen = "already_open"
        case forced = "forced"
        case path = "path"
        case workspaceID = "workspace_id"
        case tabs = "tabs"
        case agent = "agent"
        case argv = "argv"
        case agents = "agents"
        case active = "active"
        case label = "label"
        case pane = "pane"
        case panes = "panes"
        case swap = "swap"
        case moveResult = "move_result"
        case zoom = "zoom"
        case layout = "layout"
        case processInfo = "process_info"
        case neighbor = "neighbor"
        case edges = "edges"
        case focus = "focus"
        case resize = "resize"
        case read = "read"
        case cellHeightPx = "cell_height_px"
        case cellWidthPx = "cell_width_px"
        case explain = "explain"
        case event = "event"
        case matchedLine = "matched_line"
        case paneID = "pane_id"
        case revision = "revision"
        case reason = "reason"
        case shown = "shown"
        case changed = "changed"
        case details = "details"
        case target = "target"
        case manifests = "manifests"
        case lastCheckUnix = "last_check_unix"
        case lastResult = "last_result"
        case plugin = "plugin"
        case plugins = "plugins"
        case pluginID = "plugin_id"
        case removed = "removed"
        case actions = "actions"
        case action = "action"
        case context = "context"
        case log = "log"
        case logs = "logs"
        case pluginPane = "plugin_pane"
        case diagnostics = "diagnostics"
        case status = "status"
    }

    public init(capabilities: HerdrResponseCapabilitiesClass?, responseProtocol: Int?, type: HerdrResponseResponseResultType, version: String?, snapshot: HerdrResponseSnapshot?, workspace: HerdrResponseWorkspaceElement?, rootPane: HerdrResponseRootPaneElement?, tab: HerdrResponseTabElement?, workspaces: [HerdrResponseWorkspaceElement]?, source: HerdrResponseAgent?, worktrees: [HerdrResponseDataWorktree]?, worktree: HerdrResponseDataWorktree?, alreadyOpen: Bool?, forced: Bool?, path: String?, workspaceID: WorkspaceID?, tabs: [HerdrResponseTabElement]?, agent: HerdrResponseAgentElement?, argv: [String]?, agents: [HerdrResponseAgentElement]?, active: Bool?, label: String?, pane: HerdrResponseRootPaneElement?, panes: [HerdrResponseRootPaneElement]?, swap: HerdrResponseSwap?, moveResult: HerdrResponseMoveResult?, zoom: HerdrResponseZoom?, layout: HerdrResponseResponseResultLayout?, processInfo: HerdrResponseProcessInfo?, neighbor: HerdrResponseNeighbor?, edges: HerdrResponseEdges?, focus: HerdrResponseFocus?, resize: HerdrResponseRes?, read: HerdrResponseRead?, cellHeightPx: Int?, cellWidthPx: Int?, explain: HerdrResponseJSONValue?, event: HerdrResponseEventClass?, matchedLine: String?, paneID: PaneID?, revision: Int?, reason: HerdrResponseReason?, shown: Bool?, changed: Bool?, details: HerdrResponseDetails?, target: HerdrResponseTarget?, manifests: [HerdrResponseManifestElement]?, lastCheckUnix: Int?, lastResult: String?, plugin: HerdrResponsePlugin?, plugins: [HerdrResponsePlugin]?, pluginID: String?, removed: Bool?, actions: [HerdrResponseResponseResultAction]?, action: HerdrResponseResponseResultAction?, context: HerdrResponseContext?, log: HerdrResponseLog?, logs: [HerdrResponseLog]?, pluginPane: HerdrResponsePluginPaneClass?, diagnostics: [String]?, status: HerdrResponseResponseResultStatus?) {
        self.capabilities = capabilities
        self.responseProtocol = responseProtocol
        self.type = type
        self.version = version
        self.snapshot = snapshot
        self.workspace = workspace
        self.rootPane = rootPane
        self.tab = tab
        self.workspaces = workspaces
        self.source = source
        self.worktrees = worktrees
        self.worktree = worktree
        self.alreadyOpen = alreadyOpen
        self.forced = forced
        self.path = path
        self.workspaceID = workspaceID
        self.tabs = tabs
        self.agent = agent
        self.argv = argv
        self.agents = agents
        self.active = active
        self.label = label
        self.pane = pane
        self.panes = panes
        self.swap = swap
        self.moveResult = moveResult
        self.zoom = zoom
        self.layout = layout
        self.processInfo = processInfo
        self.neighbor = neighbor
        self.edges = edges
        self.focus = focus
        self.resize = resize
        self.read = read
        self.cellHeightPx = cellHeightPx
        self.cellWidthPx = cellWidthPx
        self.explain = explain
        self.event = event
        self.matchedLine = matchedLine
        self.paneID = paneID
        self.revision = revision
        self.reason = reason
        self.shown = shown
        self.changed = changed
        self.details = details
        self.target = target
        self.manifests = manifests
        self.lastCheckUnix = lastCheckUnix
        self.lastResult = lastResult
        self.plugin = plugin
        self.plugins = plugins
        self.pluginID = pluginID
        self.removed = removed
        self.actions = actions
        self.action = action
        self.context = context
        self.log = log
        self.logs = logs
        self.pluginPane = pluginPane
        self.diagnostics = diagnostics
        self.status = status
    }
}

// MARK: HerdrResponseResponse convenience initializers and mutators

public extension HerdrResponseResponse {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseResponse.self, from: data)
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
        capabilities: HerdrResponseCapabilitiesClass?? = nil,
        responseProtocol: Int?? = nil,
        type: HerdrResponseResponseResultType? = nil,
        version: String?? = nil,
        snapshot: HerdrResponseSnapshot?? = nil,
        workspace: HerdrResponseWorkspaceElement?? = nil,
        rootPane: HerdrResponseRootPaneElement?? = nil,
        tab: HerdrResponseTabElement?? = nil,
        workspaces: [HerdrResponseWorkspaceElement]?? = nil,
        source: HerdrResponseAgent?? = nil,
        worktrees: [HerdrResponseDataWorktree]?? = nil,
        worktree: HerdrResponseDataWorktree?? = nil,
        alreadyOpen: Bool?? = nil,
        forced: Bool?? = nil,
        path: String?? = nil,
        workspaceID: WorkspaceID?? = nil,
        tabs: [HerdrResponseTabElement]?? = nil,
        agent: HerdrResponseAgentElement?? = nil,
        argv: [String]?? = nil,
        agents: [HerdrResponseAgentElement]?? = nil,
        active: Bool?? = nil,
        label: String?? = nil,
        pane: HerdrResponseRootPaneElement?? = nil,
        panes: [HerdrResponseRootPaneElement]?? = nil,
        swap: HerdrResponseSwap?? = nil,
        moveResult: HerdrResponseMoveResult?? = nil,
        zoom: HerdrResponseZoom?? = nil,
        layout: HerdrResponseResponseResultLayout?? = nil,
        processInfo: HerdrResponseProcessInfo?? = nil,
        neighbor: HerdrResponseNeighbor?? = nil,
        edges: HerdrResponseEdges?? = nil,
        focus: HerdrResponseFocus?? = nil,
        resize: HerdrResponseRes?? = nil,
        read: HerdrResponseRead?? = nil,
        cellHeightPx: Int?? = nil,
        cellWidthPx: Int?? = nil,
        explain: HerdrResponseJSONValue?? = nil,
        event: HerdrResponseEventClass?? = nil,
        matchedLine: String?? = nil,
        paneID: PaneID?? = nil,
        revision: Int?? = nil,
        reason: HerdrResponseReason?? = nil,
        shown: Bool?? = nil,
        changed: Bool?? = nil,
        details: HerdrResponseDetails?? = nil,
        target: HerdrResponseTarget?? = nil,
        manifests: [HerdrResponseManifestElement]?? = nil,
        lastCheckUnix: Int?? = nil,
        lastResult: String?? = nil,
        plugin: HerdrResponsePlugin?? = nil,
        plugins: [HerdrResponsePlugin]?? = nil,
        pluginID: String?? = nil,
        removed: Bool?? = nil,
        actions: [HerdrResponseResponseResultAction]?? = nil,
        action: HerdrResponseResponseResultAction?? = nil,
        context: HerdrResponseContext?? = nil,
        log: HerdrResponseLog?? = nil,
        logs: [HerdrResponseLog]?? = nil,
        pluginPane: HerdrResponsePluginPaneClass?? = nil,
        diagnostics: [String]?? = nil,
        status: HerdrResponseResponseResultStatus?? = nil
    ) -> HerdrResponseResponse {
        return HerdrResponseResponse(
            capabilities: capabilities ?? self.capabilities,
            responseProtocol: responseProtocol ?? self.responseProtocol,
            type: type ?? self.type,
            version: version ?? self.version,
            snapshot: snapshot ?? self.snapshot,
            workspace: workspace ?? self.workspace,
            rootPane: rootPane ?? self.rootPane,
            tab: tab ?? self.tab,
            workspaces: workspaces ?? self.workspaces,
            source: source ?? self.source,
            worktrees: worktrees ?? self.worktrees,
            worktree: worktree ?? self.worktree,
            alreadyOpen: alreadyOpen ?? self.alreadyOpen,
            forced: forced ?? self.forced,
            path: path ?? self.path,
            workspaceID: workspaceID ?? self.workspaceID,
            tabs: tabs ?? self.tabs,
            agent: agent ?? self.agent,
            argv: argv ?? self.argv,
            agents: agents ?? self.agents,
            active: active ?? self.active,
            label: label ?? self.label,
            pane: pane ?? self.pane,
            panes: panes ?? self.panes,
            swap: swap ?? self.swap,
            moveResult: moveResult ?? self.moveResult,
            zoom: zoom ?? self.zoom,
            layout: layout ?? self.layout,
            processInfo: processInfo ?? self.processInfo,
            neighbor: neighbor ?? self.neighbor,
            edges: edges ?? self.edges,
            focus: focus ?? self.focus,
            resize: resize ?? self.resize,
            read: read ?? self.read,
            cellHeightPx: cellHeightPx ?? self.cellHeightPx,
            cellWidthPx: cellWidthPx ?? self.cellWidthPx,
            explain: explain ?? self.explain,
            event: event ?? self.event,
            matchedLine: matchedLine ?? self.matchedLine,
            paneID: paneID ?? self.paneID,
            revision: revision ?? self.revision,
            reason: reason ?? self.reason,
            shown: shown ?? self.shown,
            changed: changed ?? self.changed,
            details: details ?? self.details,
            target: target ?? self.target,
            manifests: manifests ?? self.manifests,
            lastCheckUnix: lastCheckUnix ?? self.lastCheckUnix,
            lastResult: lastResult ?? self.lastResult,
            plugin: plugin ?? self.plugin,
            plugins: plugins ?? self.plugins,
            pluginID: pluginID ?? self.pluginID,
            removed: removed ?? self.removed,
            actions: actions ?? self.actions,
            action: action ?? self.action,
            context: context ?? self.context,
            log: log ?? self.log,
            logs: logs ?? self.logs,
            pluginPane: pluginPane ?? self.pluginPane,
            diagnostics: diagnostics ?? self.diagnostics,
            status: status ?? self.status
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseResponseResultAction
public struct HerdrResponseResponseResultAction: Codable, Sendable {
    public let actionID: String
    public let command: [String]
    public let contexts: [HerdrResponseContextElement]?
    public let description: String?
    public let platforms: [HerdrResponsePlatformElement]?
    public let pluginID: String
    public let title: String

    public enum CodingKeys: String, CodingKey {
        case actionID = "action_id"
        case command = "command"
        case contexts = "contexts"
        case description = "description"
        case platforms = "platforms"
        case pluginID = "plugin_id"
        case title = "title"
    }

    public init(actionID: String, command: [String], contexts: [HerdrResponseContextElement]?, description: String?, platforms: [HerdrResponsePlatformElement]?, pluginID: String, title: String) {
        self.actionID = actionID
        self.command = command
        self.contexts = contexts
        self.description = description
        self.platforms = platforms
        self.pluginID = pluginID
        self.title = title
    }
}

// MARK: HerdrResponseResponseResultAction convenience initializers and mutators

public extension HerdrResponseResponseResultAction {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseResponseResultAction.self, from: data)
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
        actionID: String? = nil,
        command: [String]? = nil,
        contexts: [HerdrResponseContextElement]?? = nil,
        description: String?? = nil,
        platforms: [HerdrResponsePlatformElement]?? = nil,
        pluginID: String? = nil,
        title: String? = nil
    ) -> HerdrResponseResponseResultAction {
        return HerdrResponseResponseResultAction(
            actionID: actionID ?? self.actionID,
            command: command ?? self.command,
            contexts: contexts ?? self.contexts,
            description: description ?? self.description,
            platforms: platforms ?? self.platforms,
            pluginID: pluginID ?? self.pluginID,
            title: title ?? self.title
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseContextElement: String, Codable, Sendable {
    case global = "global"
    case pane = "pane"
    case selection = "selection"
    case tab = "tab"
    case workspace = "workspace"
}

public enum HerdrResponsePlatformElement: String, Codable, Sendable {
    case linux = "linux"
    case macos = "macos"
    case windows = "windows"
}

// MARK: - HerdrResponseAgentElement
public struct HerdrResponseAgentElement: Codable, Sendable {
    public let agent: String?
    public let agentSession: HerdrResponseAgentSessionClass?
    public let agentStatus: HerdrResponseAgentStatus
    public let cwd: String?
    public let displayAgent: String?
    public let focused: Bool
    public let foregroundCwd: String?
    public let interactiveReady: Bool?
    public let launchPending: Bool?
    public let name: String?
    public let paneID: PaneID
    public let revision: Int
    public let screenDetectionSkipped: Bool?
    public let stateChangeSeq: Int?
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
        case interactiveReady = "interactive_ready"
        case launchPending = "launch_pending"
        case name = "name"
        case paneID = "pane_id"
        case revision = "revision"
        case screenDetectionSkipped = "screen_detection_skipped"
        case stateChangeSeq = "state_change_seq"
        case stateLabels = "state_labels"
        case tabID = "tab_id"
        case terminalID = "terminal_id"
        case terminalTitle = "terminal_title"
        case terminalTitleStripped = "terminal_title_stripped"
        case title = "title"
        case tokens = "tokens"
        case workspaceID = "workspace_id"
    }

    public init(agent: String?, agentSession: HerdrResponseAgentSessionClass?, agentStatus: HerdrResponseAgentStatus, cwd: String?, displayAgent: String?, focused: Bool, foregroundCwd: String?, interactiveReady: Bool?, launchPending: Bool?, name: String?, paneID: PaneID, revision: Int, screenDetectionSkipped: Bool?, stateChangeSeq: Int?, stateLabels: [String: String]?, tabID: TabID, terminalID: TerminalID, terminalTitle: String?, terminalTitleStripped: String?, title: String?, tokens: [String: String]?, workspaceID: WorkspaceID) {
        self.agent = agent
        self.agentSession = agentSession
        self.agentStatus = agentStatus
        self.cwd = cwd
        self.displayAgent = displayAgent
        self.focused = focused
        self.foregroundCwd = foregroundCwd
        self.interactiveReady = interactiveReady
        self.launchPending = launchPending
        self.name = name
        self.paneID = paneID
        self.revision = revision
        self.screenDetectionSkipped = screenDetectionSkipped
        self.stateChangeSeq = stateChangeSeq
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

// MARK: HerdrResponseAgentElement convenience initializers and mutators

public extension HerdrResponseAgentElement {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseAgentElement.self, from: data)
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
        agentSession: HerdrResponseAgentSessionClass?? = nil,
        agentStatus: HerdrResponseAgentStatus? = nil,
        cwd: String?? = nil,
        displayAgent: String?? = nil,
        focused: Bool? = nil,
        foregroundCwd: String?? = nil,
        interactiveReady: Bool?? = nil,
        launchPending: Bool?? = nil,
        name: String?? = nil,
        paneID: PaneID? = nil,
        revision: Int? = nil,
        screenDetectionSkipped: Bool?? = nil,
        stateChangeSeq: Int?? = nil,
        stateLabels: [String: String]?? = nil,
        tabID: TabID? = nil,
        terminalID: TerminalID? = nil,
        terminalTitle: String?? = nil,
        terminalTitleStripped: String?? = nil,
        title: String?? = nil,
        tokens: [String: String]?? = nil,
        workspaceID: WorkspaceID? = nil
    ) -> HerdrResponseAgentElement {
        return HerdrResponseAgentElement(
            agent: agent ?? self.agent,
            agentSession: agentSession ?? self.agentSession,
            agentStatus: agentStatus ?? self.agentStatus,
            cwd: cwd ?? self.cwd,
            displayAgent: displayAgent ?? self.displayAgent,
            focused: focused ?? self.focused,
            foregroundCwd: foregroundCwd ?? self.foregroundCwd,
            interactiveReady: interactiveReady ?? self.interactiveReady,
            launchPending: launchPending ?? self.launchPending,
            name: name ?? self.name,
            paneID: paneID ?? self.paneID,
            revision: revision ?? self.revision,
            screenDetectionSkipped: screenDetectionSkipped ?? self.screenDetectionSkipped,
            stateChangeSeq: stateChangeSeq ?? self.stateChangeSeq,
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
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseAgentSessionClass
public struct HerdrResponseAgentSessionClass: Codable, Sendable {
    public let agent: String
    public let kind: HerdrResponseAgentSessionKind
    public let source: String
    public let value: String

    public enum CodingKeys: String, CodingKey {
        case agent = "agent"
        case kind = "kind"
        case source = "source"
        case value = "value"
    }

    public init(agent: String, kind: HerdrResponseAgentSessionKind, source: String, value: String) {
        self.agent = agent
        self.kind = kind
        self.source = source
        self.value = value
    }
}

// MARK: HerdrResponseAgentSessionClass convenience initializers and mutators

public extension HerdrResponseAgentSessionClass {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseAgentSessionClass.self, from: data)
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
        kind: HerdrResponseAgentSessionKind? = nil,
        source: String? = nil,
        value: String? = nil
    ) -> HerdrResponseAgentSessionClass {
        return HerdrResponseAgentSessionClass(
            agent: agent ?? self.agent,
            kind: kind ?? self.kind,
            source: source ?? self.source,
            value: value ?? self.value
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseAgentSessionKind: String, Codable, Sendable {
    case id = "id"
    case path = "path"
}

public enum HerdrResponseAgentStatus: String, Codable, Sendable {
    case blocked = "blocked"
    case done = "done"
    case idle = "idle"
    case unknown = "unknown"
    case working = "working"
}

// MARK: - HerdrResponseCapabilitiesClass
public struct HerdrResponseCapabilitiesClass: Codable, Sendable {
    public let detachedServerDaemon: Bool?
    public let liveHandoff: Bool

    public enum CodingKeys: String, CodingKey {
        case detachedServerDaemon = "detached_server_daemon"
        case liveHandoff = "live_handoff"
    }

    public init(detachedServerDaemon: Bool?, liveHandoff: Bool) {
        self.detachedServerDaemon = detachedServerDaemon
        self.liveHandoff = liveHandoff
    }
}

// MARK: HerdrResponseCapabilitiesClass convenience initializers and mutators

public extension HerdrResponseCapabilitiesClass {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseCapabilitiesClass.self, from: data)
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
        detachedServerDaemon: Bool?? = nil,
        liveHandoff: Bool? = nil
    ) -> HerdrResponseCapabilitiesClass {
        return HerdrResponseCapabilitiesClass(
            detachedServerDaemon: detachedServerDaemon ?? self.detachedServerDaemon,
            liveHandoff: liveHandoff ?? self.liveHandoff
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseContext
public struct HerdrResponseContext: Codable, Sendable {
    public let clickedURL: String?
    public let correlationID: String?
    public let focusedPaneAgent: String?
    public let focusedPaneCwd: String?
    public let focusedPaneID: PaneID?
    public let focusedPaneStatus: HerdrResponseAgentStatus?
    public let invocationSource: String?
    public let linkHandlerID: String?
    public let selectedText: String?
    public let tabID: TabID?
    public let tabLabel: String?
    public let workspaceCwd: String?
    public let workspaceID: WorkspaceID?
    public let workspaceLabel: String?
    public let worktree: HerdrResponseContextWorktree?

    public enum CodingKeys: String, CodingKey {
        case clickedURL = "clicked_url"
        case correlationID = "correlation_id"
        case focusedPaneAgent = "focused_pane_agent"
        case focusedPaneCwd = "focused_pane_cwd"
        case focusedPaneID = "focused_pane_id"
        case focusedPaneStatus = "focused_pane_status"
        case invocationSource = "invocation_source"
        case linkHandlerID = "link_handler_id"
        case selectedText = "selected_text"
        case tabID = "tab_id"
        case tabLabel = "tab_label"
        case workspaceCwd = "workspace_cwd"
        case workspaceID = "workspace_id"
        case workspaceLabel = "workspace_label"
        case worktree = "worktree"
    }

    public init(clickedURL: String?, correlationID: String?, focusedPaneAgent: String?, focusedPaneCwd: String?, focusedPaneID: PaneID?, focusedPaneStatus: HerdrResponseAgentStatus?, invocationSource: String?, linkHandlerID: String?, selectedText: String?, tabID: TabID?, tabLabel: String?, workspaceCwd: String?, workspaceID: WorkspaceID?, workspaceLabel: String?, worktree: HerdrResponseContextWorktree?) {
        self.clickedURL = clickedURL
        self.correlationID = correlationID
        self.focusedPaneAgent = focusedPaneAgent
        self.focusedPaneCwd = focusedPaneCwd
        self.focusedPaneID = focusedPaneID
        self.focusedPaneStatus = focusedPaneStatus
        self.invocationSource = invocationSource
        self.linkHandlerID = linkHandlerID
        self.selectedText = selectedText
        self.tabID = tabID
        self.tabLabel = tabLabel
        self.workspaceCwd = workspaceCwd
        self.workspaceID = workspaceID
        self.workspaceLabel = workspaceLabel
        self.worktree = worktree
    }
}

// MARK: HerdrResponseContext convenience initializers and mutators

public extension HerdrResponseContext {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseContext.self, from: data)
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
        clickedURL: String?? = nil,
        correlationID: String?? = nil,
        focusedPaneAgent: String?? = nil,
        focusedPaneCwd: String?? = nil,
        focusedPaneID: PaneID?? = nil,
        focusedPaneStatus: HerdrResponseAgentStatus?? = nil,
        invocationSource: String?? = nil,
        linkHandlerID: String?? = nil,
        selectedText: String?? = nil,
        tabID: TabID?? = nil,
        tabLabel: String?? = nil,
        workspaceCwd: String?? = nil,
        workspaceID: WorkspaceID?? = nil,
        workspaceLabel: String?? = nil,
        worktree: HerdrResponseContextWorktree?? = nil
    ) -> HerdrResponseContext {
        return HerdrResponseContext(
            clickedURL: clickedURL ?? self.clickedURL,
            correlationID: correlationID ?? self.correlationID,
            focusedPaneAgent: focusedPaneAgent ?? self.focusedPaneAgent,
            focusedPaneCwd: focusedPaneCwd ?? self.focusedPaneCwd,
            focusedPaneID: focusedPaneID ?? self.focusedPaneID,
            focusedPaneStatus: focusedPaneStatus ?? self.focusedPaneStatus,
            invocationSource: invocationSource ?? self.invocationSource,
            linkHandlerID: linkHandlerID ?? self.linkHandlerID,
            selectedText: selectedText ?? self.selectedText,
            tabID: tabID ?? self.tabID,
            tabLabel: tabLabel ?? self.tabLabel,
            workspaceCwd: workspaceCwd ?? self.workspaceCwd,
            workspaceID: workspaceID ?? self.workspaceID,
            workspaceLabel: workspaceLabel ?? self.workspaceLabel,
            worktree: worktree ?? self.worktree
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseContextWorktree
public struct HerdrResponseContextWorktree: Codable, Sendable {
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

// MARK: HerdrResponseContextWorktree convenience initializers and mutators

public extension HerdrResponseContextWorktree {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseContextWorktree.self, from: data)
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
    ) -> HerdrResponseContextWorktree {
        return HerdrResponseContextWorktree(
            checkoutPath: checkoutPath ?? self.checkoutPath,
            isLinkedWorktree: isLinkedWorktree ?? self.isLinkedWorktree,
            repoKey: repoKey ?? self.repoKey,
            repoName: repoName ?? self.repoName,
            repoRoot: repoRoot ?? self.repoRoot
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseDetails
public struct HerdrResponseDetails: Codable, Sendable {
    public let messages: [String]

    public enum CodingKeys: String, CodingKey {
        case messages = "messages"
    }

    public init(messages: [String]) {
        self.messages = messages
    }
}

// MARK: HerdrResponseDetails convenience initializers and mutators

public extension HerdrResponseDetails {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseDetails.self, from: data)
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
        messages: [String]? = nil
    ) -> HerdrResponseDetails {
        return HerdrResponseDetails(
            messages: messages ?? self.messages
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseEdges
public struct HerdrResponseEdges: Codable, Sendable {
    public let down: Bool
    public let layout: HerdrResponseLayoutElement
    public let edgesLeft: Bool
    public let paneID: PaneID
    public let edgesRight: Bool
    public let up: Bool

    public enum CodingKeys: String, CodingKey {
        case down = "down"
        case layout = "layout"
        case edgesLeft = "left"
        case paneID = "pane_id"
        case edgesRight = "right"
        case up = "up"
    }

    public init(down: Bool, layout: HerdrResponseLayoutElement, edgesLeft: Bool, paneID: PaneID, edgesRight: Bool, up: Bool) {
        self.down = down
        self.layout = layout
        self.edgesLeft = edgesLeft
        self.paneID = paneID
        self.edgesRight = edgesRight
        self.up = up
    }
}

// MARK: HerdrResponseEdges convenience initializers and mutators

public extension HerdrResponseEdges {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseEdges.self, from: data)
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
        down: Bool? = nil,
        layout: HerdrResponseLayoutElement? = nil,
        edgesLeft: Bool? = nil,
        paneID: PaneID? = nil,
        edgesRight: Bool? = nil,
        up: Bool? = nil
    ) -> HerdrResponseEdges {
        return HerdrResponseEdges(
            down: down ?? self.down,
            layout: layout ?? self.layout,
            edgesLeft: edgesLeft ?? self.edgesLeft,
            paneID: paneID ?? self.paneID,
            edgesRight: edgesRight ?? self.edgesRight,
            up: up ?? self.up
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseLayoutElement
public struct HerdrResponseLayoutElement: Codable, Sendable {
    public let area: HerdrResponseArea
    public let focusedPaneID: PaneID
    public let panes: [HerdrResponseLayoutPane]
    public let splits: [HerdrResponseSplitElement]
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

    public init(area: HerdrResponseArea, focusedPaneID: PaneID, panes: [HerdrResponseLayoutPane], splits: [HerdrResponseSplitElement], tabID: TabID, workspaceID: WorkspaceID, zoomed: Bool) {
        self.area = area
        self.focusedPaneID = focusedPaneID
        self.panes = panes
        self.splits = splits
        self.tabID = tabID
        self.workspaceID = workspaceID
        self.zoomed = zoomed
    }
}

// MARK: HerdrResponseLayoutElement convenience initializers and mutators

public extension HerdrResponseLayoutElement {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseLayoutElement.self, from: data)
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
        area: HerdrResponseArea? = nil,
        focusedPaneID: PaneID? = nil,
        panes: [HerdrResponseLayoutPane]? = nil,
        splits: [HerdrResponseSplitElement]? = nil,
        tabID: TabID? = nil,
        workspaceID: WorkspaceID? = nil,
        zoomed: Bool? = nil
    ) -> HerdrResponseLayoutElement {
        return HerdrResponseLayoutElement(
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
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseArea
public struct HerdrResponseArea: Codable, Sendable {
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

// MARK: HerdrResponseArea convenience initializers and mutators

public extension HerdrResponseArea {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseArea.self, from: data)
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
    ) -> HerdrResponseArea {
        return HerdrResponseArea(
            height: height ?? self.height,
            width: width ?? self.width,
            x: x ?? self.x,
            y: y ?? self.y
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseLayoutPane
public struct HerdrResponseLayoutPane: Codable, Sendable {
    public let focused: Bool
    public let paneID: PaneID
    public let rect: HerdrResponseArea

    public enum CodingKeys: String, CodingKey {
        case focused = "focused"
        case paneID = "pane_id"
        case rect = "rect"
    }

    public init(focused: Bool, paneID: PaneID, rect: HerdrResponseArea) {
        self.focused = focused
        self.paneID = paneID
        self.rect = rect
    }
}

// MARK: HerdrResponseLayoutPane convenience initializers and mutators

public extension HerdrResponseLayoutPane {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseLayoutPane.self, from: data)
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
        rect: HerdrResponseArea? = nil
    ) -> HerdrResponseLayoutPane {
        return HerdrResponseLayoutPane(
            focused: focused ?? self.focused,
            paneID: paneID ?? self.paneID,
            rect: rect ?? self.rect
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseSplitElement
public struct HerdrResponseSplitElement: Codable, Sendable {
    public let direction: HerdrResponseSplitDirection
    public let id: String
    public let ratio: Double
    public let rect: HerdrResponseArea

    public enum CodingKeys: String, CodingKey {
        case direction = "direction"
        case id = "id"
        case ratio = "ratio"
        case rect = "rect"
    }

    public init(direction: HerdrResponseSplitDirection, id: String, ratio: Double, rect: HerdrResponseArea) {
        self.direction = direction
        self.id = id
        self.ratio = ratio
        self.rect = rect
    }
}

// MARK: HerdrResponseSplitElement convenience initializers and mutators

public extension HerdrResponseSplitElement {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseSplitElement.self, from: data)
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
        direction: HerdrResponseSplitDirection? = nil,
        id: String? = nil,
        ratio: Double? = nil,
        rect: HerdrResponseArea? = nil
    ) -> HerdrResponseSplitElement {
        return HerdrResponseSplitElement(
            direction: direction ?? self.direction,
            id: id ?? self.id,
            ratio: ratio ?? self.ratio,
            rect: rect ?? self.rect
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseSplitDirection: String, Codable, Sendable {
    case directionRight = "right"
    case down = "down"
}

// MARK: - HerdrResponseEventClass
public struct HerdrResponseEventClass: Codable, Sendable {
    public let data: HerdrResponseData
    public let event: HerdrResponseEventEnum

    public enum CodingKeys: String, CodingKey {
        case data = "data"
        case event = "event"
    }

    public init(data: HerdrResponseData, event: HerdrResponseEventEnum) {
        self.data = data
        self.event = event
    }
}

// MARK: HerdrResponseEventClass convenience initializers and mutators

public extension HerdrResponseEventClass {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseEventClass.self, from: data)
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
        data: HerdrResponseData? = nil,
        event: HerdrResponseEventEnum? = nil
    ) -> HerdrResponseEventClass {
        return HerdrResponseEventClass(
            data: data ?? self.data,
            event: event ?? self.event
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseData
public struct HerdrResponseData: Codable, Sendable {
    public let type: HerdrResponseEventEnum
    public let workspace: HerdrResponseWorkspaceElement?
    public let workspaceID: WorkspaceID?
    public let label: String?
    public let insertIndex: Int?
    public let workspaces: [HerdrResponseWorkspaceElement]?
    public let worktree: HerdrResponseDataWorktree?
    public let alreadyOpen: Bool?
    public let forced: Bool?
    public let tab: HerdrResponseTabElement?
    public let tabID: TabID?
    public let tabs: [HerdrResponseTabElement]?
    public let pane: HerdrResponseRootPaneElement?
    public let paneID: PaneID?
    public let closedTabID: TabID?
    public let closedWorkspaceID: WorkspaceID?
    public let createdTab: HerdrResponseTabElement?
    public let createdWorkspace: HerdrResponseWorkspaceElement?
    public let previousPaneID: PaneID?
    public let previousTabID: TabID?
    public let previousWorkspaceID: WorkspaceID?
    public let revision: Int?
    public let agent: String?
    public let finalStatus: HerdrResponseAgentStatus?
    public let released: Bool?
    public let agentStatus: HerdrResponseAgentStatus?
    public let displayAgent: String?
    public let stateLabels: [String: String]?
    public let title: String?
    public let layout: HerdrResponseLayoutElement?

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

    public init(type: HerdrResponseEventEnum, workspace: HerdrResponseWorkspaceElement?, workspaceID: WorkspaceID?, label: String?, insertIndex: Int?, workspaces: [HerdrResponseWorkspaceElement]?, worktree: HerdrResponseDataWorktree?, alreadyOpen: Bool?, forced: Bool?, tab: HerdrResponseTabElement?, tabID: TabID?, tabs: [HerdrResponseTabElement]?, pane: HerdrResponseRootPaneElement?, paneID: PaneID?, closedTabID: TabID?, closedWorkspaceID: WorkspaceID?, createdTab: HerdrResponseTabElement?, createdWorkspace: HerdrResponseWorkspaceElement?, previousPaneID: PaneID?, previousTabID: TabID?, previousWorkspaceID: WorkspaceID?, revision: Int?, agent: String?, finalStatus: HerdrResponseAgentStatus?, released: Bool?, agentStatus: HerdrResponseAgentStatus?, displayAgent: String?, stateLabels: [String: String]?, title: String?, layout: HerdrResponseLayoutElement?) {
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

// MARK: HerdrResponseData convenience initializers and mutators

public extension HerdrResponseData {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseData.self, from: data)
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
        type: HerdrResponseEventEnum? = nil,
        workspace: HerdrResponseWorkspaceElement?? = nil,
        workspaceID: WorkspaceID?? = nil,
        label: String?? = nil,
        insertIndex: Int?? = nil,
        workspaces: [HerdrResponseWorkspaceElement]?? = nil,
        worktree: HerdrResponseDataWorktree?? = nil,
        alreadyOpen: Bool?? = nil,
        forced: Bool?? = nil,
        tab: HerdrResponseTabElement?? = nil,
        tabID: TabID?? = nil,
        tabs: [HerdrResponseTabElement]?? = nil,
        pane: HerdrResponseRootPaneElement?? = nil,
        paneID: PaneID?? = nil,
        closedTabID: TabID?? = nil,
        closedWorkspaceID: WorkspaceID?? = nil,
        createdTab: HerdrResponseTabElement?? = nil,
        createdWorkspace: HerdrResponseWorkspaceElement?? = nil,
        previousPaneID: PaneID?? = nil,
        previousTabID: TabID?? = nil,
        previousWorkspaceID: WorkspaceID?? = nil,
        revision: Int?? = nil,
        agent: String?? = nil,
        finalStatus: HerdrResponseAgentStatus?? = nil,
        released: Bool?? = nil,
        agentStatus: HerdrResponseAgentStatus?? = nil,
        displayAgent: String?? = nil,
        stateLabels: [String: String]?? = nil,
        title: String?? = nil,
        layout: HerdrResponseLayoutElement?? = nil
    ) -> HerdrResponseData {
        return HerdrResponseData(
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
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseTabElement
public struct HerdrResponseTabElement: Codable, Sendable {
    public let agentStatus: HerdrResponseAgentStatus
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

    public init(agentStatus: HerdrResponseAgentStatus, focused: Bool, label: String, number: Int, paneCount: Int, tabID: TabID, workspaceID: WorkspaceID) {
        self.agentStatus = agentStatus
        self.focused = focused
        self.label = label
        self.number = number
        self.paneCount = paneCount
        self.tabID = tabID
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrResponseTabElement convenience initializers and mutators

public extension HerdrResponseTabElement {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseTabElement.self, from: data)
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
        agentStatus: HerdrResponseAgentStatus? = nil,
        focused: Bool? = nil,
        label: String? = nil,
        number: Int? = nil,
        paneCount: Int? = nil,
        tabID: TabID? = nil,
        workspaceID: WorkspaceID? = nil
    ) -> HerdrResponseTabElement {
        return HerdrResponseTabElement(
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
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseWorkspaceElement
public struct HerdrResponseWorkspaceElement: Codable, Sendable {
    public let activeTabID: TabID
    public let agentStatus: HerdrResponseAgentStatus
    public let focused: Bool
    public let label: String
    public let number: Int
    public let paneCount: Int
    public let tabCount: Int
    public let tokens: [String: String]?
    public let workspaceID: WorkspaceID
    public let worktree: HerdrResponseContextWorktree?

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

    public init(activeTabID: TabID, agentStatus: HerdrResponseAgentStatus, focused: Bool, label: String, number: Int, paneCount: Int, tabCount: Int, tokens: [String: String]?, workspaceID: WorkspaceID, worktree: HerdrResponseContextWorktree?) {
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

// MARK: HerdrResponseWorkspaceElement convenience initializers and mutators

public extension HerdrResponseWorkspaceElement {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseWorkspaceElement.self, from: data)
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
        agentStatus: HerdrResponseAgentStatus? = nil,
        focused: Bool? = nil,
        label: String? = nil,
        number: Int? = nil,
        paneCount: Int? = nil,
        tabCount: Int? = nil,
        tokens: [String: String]?? = nil,
        workspaceID: WorkspaceID? = nil,
        worktree: HerdrResponseContextWorktree?? = nil
    ) -> HerdrResponseWorkspaceElement {
        return HerdrResponseWorkspaceElement(
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
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseRootPaneElement
public struct HerdrResponseRootPaneElement: Codable, Sendable {
    public let agent: String?
    public let agentSession: HerdrResponseAgentSessionClass?
    public let agentStatus: HerdrResponseAgentStatus
    public let cwd: String?
    public let displayAgent: String?
    public let focused: Bool
    public let foregroundCwd: String?
    public let label: String?
    public let paneID: PaneID
    public let revision: Int
    public let scroll: HerdrResponseScrollClass?
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

    public init(agent: String?, agentSession: HerdrResponseAgentSessionClass?, agentStatus: HerdrResponseAgentStatus, cwd: String?, displayAgent: String?, focused: Bool, foregroundCwd: String?, label: String?, paneID: PaneID, revision: Int, scroll: HerdrResponseScrollClass?, stateLabels: [String: String]?, tabID: TabID, terminalID: TerminalID, terminalTitle: String?, terminalTitleStripped: String?, title: String?, tokens: [String: String]?, workspaceID: WorkspaceID) {
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

// MARK: HerdrResponseRootPaneElement convenience initializers and mutators

public extension HerdrResponseRootPaneElement {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseRootPaneElement.self, from: data)
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
        agentSession: HerdrResponseAgentSessionClass?? = nil,
        agentStatus: HerdrResponseAgentStatus? = nil,
        cwd: String?? = nil,
        displayAgent: String?? = nil,
        focused: Bool? = nil,
        foregroundCwd: String?? = nil,
        label: String?? = nil,
        paneID: PaneID? = nil,
        revision: Int? = nil,
        scroll: HerdrResponseScrollClass?? = nil,
        stateLabels: [String: String]?? = nil,
        tabID: TabID? = nil,
        terminalID: TerminalID? = nil,
        terminalTitle: String?? = nil,
        terminalTitleStripped: String?? = nil,
        title: String?? = nil,
        tokens: [String: String]?? = nil,
        workspaceID: WorkspaceID? = nil
    ) -> HerdrResponseRootPaneElement {
        return HerdrResponseRootPaneElement(
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
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseScrollClass
public struct HerdrResponseScrollClass: Codable, Sendable {
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

// MARK: HerdrResponseScrollClass convenience initializers and mutators

public extension HerdrResponseScrollClass {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseScrollClass.self, from: data)
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
    ) -> HerdrResponseScrollClass {
        return HerdrResponseScrollClass(
            maxOffsetFromBottom: maxOffsetFromBottom ?? self.maxOffsetFromBottom,
            offsetFromBottom: offsetFromBottom ?? self.offsetFromBottom,
            viewportRows: viewportRows ?? self.viewportRows
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseEventEnum: String, Codable, Sendable {
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

// MARK: - HerdrResponseDataWorktree
public struct HerdrResponseDataWorktree: Codable, Sendable {
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

// MARK: HerdrResponseDataWorktree convenience initializers and mutators

public extension HerdrResponseDataWorktree {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseDataWorktree.self, from: data)
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
    ) -> HerdrResponseDataWorktree {
        return HerdrResponseDataWorktree(
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
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseFocus
public struct HerdrResponseFocus: Codable, Sendable {
    public let changed: Bool
    public let focusedPaneID: PaneID?
    public let layout: HerdrResponseLayoutElement
    public let reason: HerdrResponseFocusReason?
    public let sourcePaneID: PaneID

    public enum CodingKeys: String, CodingKey {
        case changed = "changed"
        case focusedPaneID = "focused_pane_id"
        case layout = "layout"
        case reason = "reason"
        case sourcePaneID = "source_pane_id"
    }

    public init(changed: Bool, focusedPaneID: PaneID?, layout: HerdrResponseLayoutElement, reason: HerdrResponseFocusReason?, sourcePaneID: PaneID) {
        self.changed = changed
        self.focusedPaneID = focusedPaneID
        self.layout = layout
        self.reason = reason
        self.sourcePaneID = sourcePaneID
    }
}

// MARK: HerdrResponseFocus convenience initializers and mutators

public extension HerdrResponseFocus {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseFocus.self, from: data)
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
        changed: Bool? = nil,
        focusedPaneID: PaneID?? = nil,
        layout: HerdrResponseLayoutElement? = nil,
        reason: HerdrResponseFocusReason?? = nil,
        sourcePaneID: PaneID? = nil
    ) -> HerdrResponseFocus {
        return HerdrResponseFocus(
            changed: changed ?? self.changed,
            focusedPaneID: focusedPaneID ?? self.focusedPaneID,
            layout: layout ?? self.layout,
            reason: reason ?? self.reason,
            sourcePaneID: sourcePaneID ?? self.sourcePaneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseFocusReason: String, Codable, Sendable {
    case noNeighbor = "no_neighbor"
}

// MARK: - HerdrResponseResponseResultLayout
public struct HerdrResponseResponseResultLayout: Codable, Sendable {
    public let area: HerdrResponseArea?
    public let focusedPaneID: PaneID
    public let panes: [HerdrResponseLayoutPane]?
    public let splits: [HerdrResponseSplitElement]?
    public let tabID: TabID
    public let workspaceID: WorkspaceID
    public let zoomed: Bool
    public let root: HerdrResponseRoot?

    public enum CodingKeys: String, CodingKey {
        case area = "area"
        case focusedPaneID = "focused_pane_id"
        case panes = "panes"
        case splits = "splits"
        case tabID = "tab_id"
        case workspaceID = "workspace_id"
        case zoomed = "zoomed"
        case root = "root"
    }

    public init(area: HerdrResponseArea?, focusedPaneID: PaneID, panes: [HerdrResponseLayoutPane]?, splits: [HerdrResponseSplitElement]?, tabID: TabID, workspaceID: WorkspaceID, zoomed: Bool, root: HerdrResponseRoot?) {
        self.area = area
        self.focusedPaneID = focusedPaneID
        self.panes = panes
        self.splits = splits
        self.tabID = tabID
        self.workspaceID = workspaceID
        self.zoomed = zoomed
        self.root = root
    }
}

// MARK: HerdrResponseResponseResultLayout convenience initializers and mutators

public extension HerdrResponseResponseResultLayout {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseResponseResultLayout.self, from: data)
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
        area: HerdrResponseArea?? = nil,
        focusedPaneID: PaneID? = nil,
        panes: [HerdrResponseLayoutPane]?? = nil,
        splits: [HerdrResponseSplitElement]?? = nil,
        tabID: TabID? = nil,
        workspaceID: WorkspaceID? = nil,
        zoomed: Bool? = nil,
        root: HerdrResponseRoot?? = nil
    ) -> HerdrResponseResponseResultLayout {
        return HerdrResponseResponseResultLayout(
            area: area ?? self.area,
            focusedPaneID: focusedPaneID ?? self.focusedPaneID,
            panes: panes ?? self.panes,
            splits: splits ?? self.splits,
            tabID: tabID ?? self.tabID,
            workspaceID: workspaceID ?? self.workspaceID,
            zoomed: zoomed ?? self.zoomed,
            root: root ?? self.root
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseRoot
public final class HerdrResponseRoot: Codable, Sendable {
    public let command: [String]?
    public let cwd: String?
    public let env: [String: String]?
    public let label: String?
    public let paneID: PaneID?
    public let type: HerdrResponseRootType
    public let direction: HerdrResponseSplitDirection?
    public let first: HerdrResponseRoot?
    public let ratio: Double?
    public let second: HerdrResponseRoot?

    public enum CodingKeys: String, CodingKey {
        case command = "command"
        case cwd = "cwd"
        case env = "env"
        case label = "label"
        case paneID = "pane_id"
        case type = "type"
        case direction = "direction"
        case first = "first"
        case ratio = "ratio"
        case second = "second"
    }

    public init(command: [String]?, cwd: String?, env: [String: String]?, label: String?, paneID: PaneID?, type: HerdrResponseRootType, direction: HerdrResponseSplitDirection?, first: HerdrResponseRoot?, ratio: Double?, second: HerdrResponseRoot?) {
        self.command = command
        self.cwd = cwd
        self.env = env
        self.label = label
        self.paneID = paneID
        self.type = type
        self.direction = direction
        self.first = first
        self.ratio = ratio
        self.second = second
    }
}

// MARK: HerdrResponseRoot convenience initializers and mutators

public extension HerdrResponseRoot {
    convenience init(data: Data) throws {
        let me = try newHerdrResponseJSONDecoder().decode(HerdrResponseRoot.self, from: data)
        self.init(command: me.command, cwd: me.cwd, env: me.env, label: me.label, paneID: me.paneID, type: me.type, direction: me.direction, first: me.first, ratio: me.ratio, second: me.second)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        command: [String]?? = nil,
        cwd: String?? = nil,
        env: [String: String]?? = nil,
        label: String?? = nil,
        paneID: PaneID?? = nil,
        type: HerdrResponseRootType? = nil,
        direction: HerdrResponseSplitDirection?? = nil,
        first: HerdrResponseRoot?? = nil,
        ratio: Double?? = nil,
        second: HerdrResponseRoot?? = nil
    ) -> HerdrResponseRoot {
        return HerdrResponseRoot(
            command: command ?? self.command,
            cwd: cwd ?? self.cwd,
            env: env ?? self.env,
            label: label ?? self.label,
            paneID: paneID ?? self.paneID,
            type: type ?? self.type,
            direction: direction ?? self.direction,
            first: first ?? self.first,
            ratio: ratio ?? self.ratio,
            second: second ?? self.second
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseRootType: String, Codable, Sendable {
    case pane = "pane"
    case split = "split"
}

// MARK: - HerdrResponseLog
public struct HerdrResponseLog: Codable, Sendable {
    public let actionID: String?
    public let command: [String]
    public let error: String?
    public let event: String?
    public let exitCode: Int?
    public let finishedUnixMS: Int?
    public let logID: String
    public let pluginID: String
    public let startedUnixMS: Int
    public let status: HerdrResponseLogStatus
    public let stderr: String?
    public let stdout: String?

    public enum CodingKeys: String, CodingKey {
        case actionID = "action_id"
        case command = "command"
        case error = "error"
        case event = "event"
        case exitCode = "exit_code"
        case finishedUnixMS = "finished_unix_ms"
        case logID = "log_id"
        case pluginID = "plugin_id"
        case startedUnixMS = "started_unix_ms"
        case status = "status"
        case stderr = "stderr"
        case stdout = "stdout"
    }

    public init(actionID: String?, command: [String], error: String?, event: String?, exitCode: Int?, finishedUnixMS: Int?, logID: String, pluginID: String, startedUnixMS: Int, status: HerdrResponseLogStatus, stderr: String?, stdout: String?) {
        self.actionID = actionID
        self.command = command
        self.error = error
        self.event = event
        self.exitCode = exitCode
        self.finishedUnixMS = finishedUnixMS
        self.logID = logID
        self.pluginID = pluginID
        self.startedUnixMS = startedUnixMS
        self.status = status
        self.stderr = stderr
        self.stdout = stdout
    }
}

// MARK: HerdrResponseLog convenience initializers and mutators

public extension HerdrResponseLog {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseLog.self, from: data)
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
        actionID: String?? = nil,
        command: [String]? = nil,
        error: String?? = nil,
        event: String?? = nil,
        exitCode: Int?? = nil,
        finishedUnixMS: Int?? = nil,
        logID: String? = nil,
        pluginID: String? = nil,
        startedUnixMS: Int? = nil,
        status: HerdrResponseLogStatus? = nil,
        stderr: String?? = nil,
        stdout: String?? = nil
    ) -> HerdrResponseLog {
        return HerdrResponseLog(
            actionID: actionID ?? self.actionID,
            command: command ?? self.command,
            error: error ?? self.error,
            event: event ?? self.event,
            exitCode: exitCode ?? self.exitCode,
            finishedUnixMS: finishedUnixMS ?? self.finishedUnixMS,
            logID: logID ?? self.logID,
            pluginID: pluginID ?? self.pluginID,
            startedUnixMS: startedUnixMS ?? self.startedUnixMS,
            status: status ?? self.status,
            stderr: stderr ?? self.stderr,
            stdout: stdout ?? self.stdout
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseLogStatus: String, Codable, Sendable {
    case failed = "failed"
    case running = "running"
    case succeeded = "succeeded"
}

// MARK: - HerdrResponseManifestElement
public struct HerdrResponseManifestElement: Codable, Sendable {
    public let activeVersion: String?
    public let agent: String
    public let cachedRemoteVersion: String?
    public let localOverrideShadowingRemote: Bool
    public let remoteLastCheckedUnix: Int?
    public let remoteUpdateError: String?
    public let remoteUpdateResult: String?
    public let source: String
    public let sourceKind: String
    public let warning: String?

    public enum CodingKeys: String, CodingKey {
        case activeVersion = "active_version"
        case agent = "agent"
        case cachedRemoteVersion = "cached_remote_version"
        case localOverrideShadowingRemote = "local_override_shadowing_remote"
        case remoteLastCheckedUnix = "remote_last_checked_unix"
        case remoteUpdateError = "remote_update_error"
        case remoteUpdateResult = "remote_update_result"
        case source = "source"
        case sourceKind = "source_kind"
        case warning = "warning"
    }

    public init(activeVersion: String?, agent: String, cachedRemoteVersion: String?, localOverrideShadowingRemote: Bool, remoteLastCheckedUnix: Int?, remoteUpdateError: String?, remoteUpdateResult: String?, source: String, sourceKind: String, warning: String?) {
        self.activeVersion = activeVersion
        self.agent = agent
        self.cachedRemoteVersion = cachedRemoteVersion
        self.localOverrideShadowingRemote = localOverrideShadowingRemote
        self.remoteLastCheckedUnix = remoteLastCheckedUnix
        self.remoteUpdateError = remoteUpdateError
        self.remoteUpdateResult = remoteUpdateResult
        self.source = source
        self.sourceKind = sourceKind
        self.warning = warning
    }
}

// MARK: HerdrResponseManifestElement convenience initializers and mutators

public extension HerdrResponseManifestElement {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseManifestElement.self, from: data)
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
        activeVersion: String?? = nil,
        agent: String? = nil,
        cachedRemoteVersion: String?? = nil,
        localOverrideShadowingRemote: Bool? = nil,
        remoteLastCheckedUnix: Int?? = nil,
        remoteUpdateError: String?? = nil,
        remoteUpdateResult: String?? = nil,
        source: String? = nil,
        sourceKind: String? = nil,
        warning: String?? = nil
    ) -> HerdrResponseManifestElement {
        return HerdrResponseManifestElement(
            activeVersion: activeVersion ?? self.activeVersion,
            agent: agent ?? self.agent,
            cachedRemoteVersion: cachedRemoteVersion ?? self.cachedRemoteVersion,
            localOverrideShadowingRemote: localOverrideShadowingRemote ?? self.localOverrideShadowingRemote,
            remoteLastCheckedUnix: remoteLastCheckedUnix ?? self.remoteLastCheckedUnix,
            remoteUpdateError: remoteUpdateError ?? self.remoteUpdateError,
            remoteUpdateResult: remoteUpdateResult ?? self.remoteUpdateResult,
            source: source ?? self.source,
            sourceKind: sourceKind ?? self.sourceKind,
            warning: warning ?? self.warning
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseMoveResult
public struct HerdrResponseMoveResult: Codable, Sendable {
    public let changed: Bool
    public let closedTabID: TabID?
    public let closedWorkspaceID: WorkspaceID?
    public let createdTab: HerdrResponseTabElement?
    public let createdWorkspace: HerdrResponseWorkspaceElement?
    public let focusedPaneID: PaneID
    public let pane: HerdrResponseRootPaneElement
    public let previousPaneID: PaneID
    public let previousTabID: TabID
    public let previousWorkspaceID: WorkspaceID
    public let reason: HerdrResponseMoveResultReason?
    public let sourceLayout: HerdrResponseLayoutElement?
    public let targetLayout: HerdrResponseLayoutElement

    public enum CodingKeys: String, CodingKey {
        case changed = "changed"
        case closedTabID = "closed_tab_id"
        case closedWorkspaceID = "closed_workspace_id"
        case createdTab = "created_tab"
        case createdWorkspace = "created_workspace"
        case focusedPaneID = "focused_pane_id"
        case pane = "pane"
        case previousPaneID = "previous_pane_id"
        case previousTabID = "previous_tab_id"
        case previousWorkspaceID = "previous_workspace_id"
        case reason = "reason"
        case sourceLayout = "source_layout"
        case targetLayout = "target_layout"
    }

    public init(changed: Bool, closedTabID: TabID?, closedWorkspaceID: WorkspaceID?, createdTab: HerdrResponseTabElement?, createdWorkspace: HerdrResponseWorkspaceElement?, focusedPaneID: PaneID, pane: HerdrResponseRootPaneElement, previousPaneID: PaneID, previousTabID: TabID, previousWorkspaceID: WorkspaceID, reason: HerdrResponseMoveResultReason?, sourceLayout: HerdrResponseLayoutElement?, targetLayout: HerdrResponseLayoutElement) {
        self.changed = changed
        self.closedTabID = closedTabID
        self.closedWorkspaceID = closedWorkspaceID
        self.createdTab = createdTab
        self.createdWorkspace = createdWorkspace
        self.focusedPaneID = focusedPaneID
        self.pane = pane
        self.previousPaneID = previousPaneID
        self.previousTabID = previousTabID
        self.previousWorkspaceID = previousWorkspaceID
        self.reason = reason
        self.sourceLayout = sourceLayout
        self.targetLayout = targetLayout
    }
}

// MARK: HerdrResponseMoveResult convenience initializers and mutators

public extension HerdrResponseMoveResult {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseMoveResult.self, from: data)
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
        changed: Bool? = nil,
        closedTabID: TabID?? = nil,
        closedWorkspaceID: WorkspaceID?? = nil,
        createdTab: HerdrResponseTabElement?? = nil,
        createdWorkspace: HerdrResponseWorkspaceElement?? = nil,
        focusedPaneID: PaneID? = nil,
        pane: HerdrResponseRootPaneElement? = nil,
        previousPaneID: PaneID? = nil,
        previousTabID: TabID? = nil,
        previousWorkspaceID: WorkspaceID? = nil,
        reason: HerdrResponseMoveResultReason?? = nil,
        sourceLayout: HerdrResponseLayoutElement?? = nil,
        targetLayout: HerdrResponseLayoutElement? = nil
    ) -> HerdrResponseMoveResult {
        return HerdrResponseMoveResult(
            changed: changed ?? self.changed,
            closedTabID: closedTabID ?? self.closedTabID,
            closedWorkspaceID: closedWorkspaceID ?? self.closedWorkspaceID,
            createdTab: createdTab ?? self.createdTab,
            createdWorkspace: createdWorkspace ?? self.createdWorkspace,
            focusedPaneID: focusedPaneID ?? self.focusedPaneID,
            pane: pane ?? self.pane,
            previousPaneID: previousPaneID ?? self.previousPaneID,
            previousTabID: previousTabID ?? self.previousTabID,
            previousWorkspaceID: previousWorkspaceID ?? self.previousWorkspaceID,
            reason: reason ?? self.reason,
            sourceLayout: sourceLayout ?? self.sourceLayout,
            targetLayout: targetLayout ?? self.targetLayout
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseMoveResultReason: String, Codable, Sendable {
    case sameTab = "same_tab"
    case zoomedTab = "zoomed_tab"
}

// MARK: - HerdrResponseNeighbor
public struct HerdrResponseNeighbor: Codable, Sendable {
    public let direction: HerdrResponseNeighborDirection
    public let layout: HerdrResponseLayoutElement
    public let neighborPaneID: PaneID?
    public let paneID: PaneID

    public enum CodingKeys: String, CodingKey {
        case direction = "direction"
        case layout = "layout"
        case neighborPaneID = "neighbor_pane_id"
        case paneID = "pane_id"
    }

    public init(direction: HerdrResponseNeighborDirection, layout: HerdrResponseLayoutElement, neighborPaneID: PaneID?, paneID: PaneID) {
        self.direction = direction
        self.layout = layout
        self.neighborPaneID = neighborPaneID
        self.paneID = paneID
    }
}

// MARK: HerdrResponseNeighbor convenience initializers and mutators

public extension HerdrResponseNeighbor {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseNeighbor.self, from: data)
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
        direction: HerdrResponseNeighborDirection? = nil,
        layout: HerdrResponseLayoutElement? = nil,
        neighborPaneID: PaneID?? = nil,
        paneID: PaneID? = nil
    ) -> HerdrResponseNeighbor {
        return HerdrResponseNeighbor(
            direction: direction ?? self.direction,
            layout: layout ?? self.layout,
            neighborPaneID: neighborPaneID ?? self.neighborPaneID,
            paneID: paneID ?? self.paneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseNeighborDirection: String, Codable, Sendable {
    case directionLeft = "left"
    case directionRight = "right"
    case down = "down"
    case up = "up"
}

// MARK: - HerdrResponsePlugin
public struct HerdrResponsePlugin: Codable, Sendable {
    public let actions: [HerdrResponseActionElement]?
    public let build: [HerdrResponseBuildElement]?
    public let description: String?
    public let enabled: Bool
    public let events: [HerdrResponseEventElement]?
    public let linkHandlers: [HerdrResponseLinkHandlerElement]?
    public let manifestPath: String
    public let minHerdrVersion: String?
    public let name: String
    public let panes: [HerdrResponsePluginPane]?
    public let platforms: [HerdrResponsePlatformElement]?
    public let pluginID: String
    public let pluginRoot: String
    public let source: HerdrResponsePluginSource?
    public let startup: [HerdrResponseStartupElement]?
    public let version: String
    /// Warnings collected at link time or on registry load (e.g. unknown event names,
    /// missing manifest file). Non-fatal — the entry is kept and surfaced by plugin.list.
    public let warnings: [String]?

    public enum CodingKeys: String, CodingKey {
        case actions = "actions"
        case build = "build"
        case description = "description"
        case enabled = "enabled"
        case events = "events"
        case linkHandlers = "link_handlers"
        case manifestPath = "manifest_path"
        case minHerdrVersion = "min_herdr_version"
        case name = "name"
        case panes = "panes"
        case platforms = "platforms"
        case pluginID = "plugin_id"
        case pluginRoot = "plugin_root"
        case source = "source"
        case startup = "startup"
        case version = "version"
        case warnings = "warnings"
    }

    public init(actions: [HerdrResponseActionElement]?, build: [HerdrResponseBuildElement]?, description: String?, enabled: Bool, events: [HerdrResponseEventElement]?, linkHandlers: [HerdrResponseLinkHandlerElement]?, manifestPath: String, minHerdrVersion: String?, name: String, panes: [HerdrResponsePluginPane]?, platforms: [HerdrResponsePlatformElement]?, pluginID: String, pluginRoot: String, source: HerdrResponsePluginSource?, startup: [HerdrResponseStartupElement]?, version: String, warnings: [String]?) {
        self.actions = actions
        self.build = build
        self.description = description
        self.enabled = enabled
        self.events = events
        self.linkHandlers = linkHandlers
        self.manifestPath = manifestPath
        self.minHerdrVersion = minHerdrVersion
        self.name = name
        self.panes = panes
        self.platforms = platforms
        self.pluginID = pluginID
        self.pluginRoot = pluginRoot
        self.source = source
        self.startup = startup
        self.version = version
        self.warnings = warnings
    }
}

// MARK: HerdrResponsePlugin convenience initializers and mutators

public extension HerdrResponsePlugin {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponsePlugin.self, from: data)
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
        actions: [HerdrResponseActionElement]?? = nil,
        build: [HerdrResponseBuildElement]?? = nil,
        description: String?? = nil,
        enabled: Bool? = nil,
        events: [HerdrResponseEventElement]?? = nil,
        linkHandlers: [HerdrResponseLinkHandlerElement]?? = nil,
        manifestPath: String? = nil,
        minHerdrVersion: String?? = nil,
        name: String? = nil,
        panes: [HerdrResponsePluginPane]?? = nil,
        platforms: [HerdrResponsePlatformElement]?? = nil,
        pluginID: String? = nil,
        pluginRoot: String? = nil,
        source: HerdrResponsePluginSource?? = nil,
        startup: [HerdrResponseStartupElement]?? = nil,
        version: String? = nil,
        warnings: [String]?? = nil
    ) -> HerdrResponsePlugin {
        return HerdrResponsePlugin(
            actions: actions ?? self.actions,
            build: build ?? self.build,
            description: description ?? self.description,
            enabled: enabled ?? self.enabled,
            events: events ?? self.events,
            linkHandlers: linkHandlers ?? self.linkHandlers,
            manifestPath: manifestPath ?? self.manifestPath,
            minHerdrVersion: minHerdrVersion ?? self.minHerdrVersion,
            name: name ?? self.name,
            panes: panes ?? self.panes,
            platforms: platforms ?? self.platforms,
            pluginID: pluginID ?? self.pluginID,
            pluginRoot: pluginRoot ?? self.pluginRoot,
            source: source ?? self.source,
            startup: startup ?? self.startup,
            version: version ?? self.version,
            warnings: warnings ?? self.warnings
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseActionElement
public struct HerdrResponseActionElement: Codable, Sendable {
    public let command: [String]
    public let contexts: [HerdrResponseContextElement]?
    public let description: String?
    public let id: String
    public let platforms: [HerdrResponsePlatformElement]?
    public let title: String

    public enum CodingKeys: String, CodingKey {
        case command = "command"
        case contexts = "contexts"
        case description = "description"
        case id = "id"
        case platforms = "platforms"
        case title = "title"
    }

    public init(command: [String], contexts: [HerdrResponseContextElement]?, description: String?, id: String, platforms: [HerdrResponsePlatformElement]?, title: String) {
        self.command = command
        self.contexts = contexts
        self.description = description
        self.id = id
        self.platforms = platforms
        self.title = title
    }
}

// MARK: HerdrResponseActionElement convenience initializers and mutators

public extension HerdrResponseActionElement {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseActionElement.self, from: data)
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
        command: [String]? = nil,
        contexts: [HerdrResponseContextElement]?? = nil,
        description: String?? = nil,
        id: String? = nil,
        platforms: [HerdrResponsePlatformElement]?? = nil,
        title: String? = nil
    ) -> HerdrResponseActionElement {
        return HerdrResponseActionElement(
            command: command ?? self.command,
            contexts: contexts ?? self.contexts,
            description: description ?? self.description,
            id: id ?? self.id,
            platforms: platforms ?? self.platforms,
            title: title ?? self.title
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseBuildElement
public struct HerdrResponseBuildElement: Codable, Sendable {
    public let command: [String]
    public let platforms: [HerdrResponsePlatformElement]?

    public enum CodingKeys: String, CodingKey {
        case command = "command"
        case platforms = "platforms"
    }

    public init(command: [String], platforms: [HerdrResponsePlatformElement]?) {
        self.command = command
        self.platforms = platforms
    }
}

// MARK: HerdrResponseBuildElement convenience initializers and mutators

public extension HerdrResponseBuildElement {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseBuildElement.self, from: data)
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
        command: [String]? = nil,
        platforms: [HerdrResponsePlatformElement]?? = nil
    ) -> HerdrResponseBuildElement {
        return HerdrResponseBuildElement(
            command: command ?? self.command,
            platforms: platforms ?? self.platforms
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseEventElement
public struct HerdrResponseEventElement: Codable, Sendable {
    public let command: [String]
    public let on: String
    public let platforms: [HerdrResponsePlatformElement]?

    public enum CodingKeys: String, CodingKey {
        case command = "command"
        case on = "on"
        case platforms = "platforms"
    }

    public init(command: [String], on: String, platforms: [HerdrResponsePlatformElement]?) {
        self.command = command
        self.on = on
        self.platforms = platforms
    }
}

// MARK: HerdrResponseEventElement convenience initializers and mutators

public extension HerdrResponseEventElement {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseEventElement.self, from: data)
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
        command: [String]? = nil,
        on: String? = nil,
        platforms: [HerdrResponsePlatformElement]?? = nil
    ) -> HerdrResponseEventElement {
        return HerdrResponseEventElement(
            command: command ?? self.command,
            on: on ?? self.on,
            platforms: platforms ?? self.platforms
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseLinkHandlerElement
public struct HerdrResponseLinkHandlerElement: Codable, Sendable {
    public let action: String
    public let id: String
    public let pattern: String
    public let platforms: [HerdrResponsePlatformElement]?
    public let title: String

    public enum CodingKeys: String, CodingKey {
        case action = "action"
        case id = "id"
        case pattern = "pattern"
        case platforms = "platforms"
        case title = "title"
    }

    public init(action: String, id: String, pattern: String, platforms: [HerdrResponsePlatformElement]?, title: String) {
        self.action = action
        self.id = id
        self.pattern = pattern
        self.platforms = platforms
        self.title = title
    }
}

// MARK: HerdrResponseLinkHandlerElement convenience initializers and mutators

public extension HerdrResponseLinkHandlerElement {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseLinkHandlerElement.self, from: data)
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
        action: String? = nil,
        id: String? = nil,
        pattern: String? = nil,
        platforms: [HerdrResponsePlatformElement]?? = nil,
        title: String? = nil
    ) -> HerdrResponseLinkHandlerElement {
        return HerdrResponseLinkHandlerElement(
            action: action ?? self.action,
            id: id ?? self.id,
            pattern: pattern ?? self.pattern,
            platforms: platforms ?? self.platforms,
            title: title ?? self.title
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponsePluginPane
public struct HerdrResponsePluginPane: Codable, Sendable {
    public let command: [String]
    public let description: String?
    public let height: HerdrResponseHeight?
    public let id: String
    public let placement: HerdrResponsePlacement?
    public let platforms: [HerdrResponsePlatformElement]?
    public let title: String
    public let width: HerdrResponseHeight?

    public enum CodingKeys: String, CodingKey {
        case command = "command"
        case description = "description"
        case height = "height"
        case id = "id"
        case placement = "placement"
        case platforms = "platforms"
        case title = "title"
        case width = "width"
    }

    public init(command: [String], description: String?, height: HerdrResponseHeight?, id: String, placement: HerdrResponsePlacement?, platforms: [HerdrResponsePlatformElement]?, title: String, width: HerdrResponseHeight?) {
        self.command = command
        self.description = description
        self.height = height
        self.id = id
        self.placement = placement
        self.platforms = platforms
        self.title = title
        self.width = width
    }
}

// MARK: HerdrResponsePluginPane convenience initializers and mutators

public extension HerdrResponsePluginPane {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponsePluginPane.self, from: data)
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
        command: [String]? = nil,
        description: String?? = nil,
        height: HerdrResponseHeight?? = nil,
        id: String? = nil,
        placement: HerdrResponsePlacement?? = nil,
        platforms: [HerdrResponsePlatformElement]?? = nil,
        title: String? = nil,
        width: HerdrResponseHeight?? = nil
    ) -> HerdrResponsePluginPane {
        return HerdrResponsePluginPane(
            command: command ?? self.command,
            description: description ?? self.description,
            height: height ?? self.height,
            id: id ?? self.id,
            placement: placement ?? self.placement,
            platforms: platforms ?? self.platforms,
            title: title ?? self.title,
            width: width ?? self.width
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseHeight: Codable, Sendable {
    case integer(Int)
    case string(String)
    case null

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        throw DecodingError.typeMismatch(HerdrResponseHeight.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for HerdrResponseHeight"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .null:
            try container.encodeNil()
        }
    }
}

public enum HerdrResponsePlacement: String, Codable, Sendable {
    case overlay = "overlay"
    case popup = "popup"
    case split = "split"
    case tab = "tab"
    case zoomed = "zoomed"
}

// MARK: - HerdrResponsePluginSource
public struct HerdrResponsePluginSource: Codable, Sendable {
    public let installedUnixMS: Int?
    public let kind: HerdrResponseSourceKind?
    public let managedPath: String?
    public let owner: String?
    public let repo: String?
    public let requestedRef: String?
    public let resolvedCommit: String?
    public let subdir: String?

    public enum CodingKeys: String, CodingKey {
        case installedUnixMS = "installed_unix_ms"
        case kind = "kind"
        case managedPath = "managed_path"
        case owner = "owner"
        case repo = "repo"
        case requestedRef = "requested_ref"
        case resolvedCommit = "resolved_commit"
        case subdir = "subdir"
    }

    public init(installedUnixMS: Int?, kind: HerdrResponseSourceKind?, managedPath: String?, owner: String?, repo: String?, requestedRef: String?, resolvedCommit: String?, subdir: String?) {
        self.installedUnixMS = installedUnixMS
        self.kind = kind
        self.managedPath = managedPath
        self.owner = owner
        self.repo = repo
        self.requestedRef = requestedRef
        self.resolvedCommit = resolvedCommit
        self.subdir = subdir
    }
}

// MARK: HerdrResponsePluginSource convenience initializers and mutators

public extension HerdrResponsePluginSource {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponsePluginSource.self, from: data)
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
        installedUnixMS: Int?? = nil,
        kind: HerdrResponseSourceKind?? = nil,
        managedPath: String?? = nil,
        owner: String?? = nil,
        repo: String?? = nil,
        requestedRef: String?? = nil,
        resolvedCommit: String?? = nil,
        subdir: String?? = nil
    ) -> HerdrResponsePluginSource {
        return HerdrResponsePluginSource(
            installedUnixMS: installedUnixMS ?? self.installedUnixMS,
            kind: kind ?? self.kind,
            managedPath: managedPath ?? self.managedPath,
            owner: owner ?? self.owner,
            repo: repo ?? self.repo,
            requestedRef: requestedRef ?? self.requestedRef,
            resolvedCommit: resolvedCommit ?? self.resolvedCommit,
            subdir: subdir ?? self.subdir
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseSourceKind: String, Codable, Sendable {
    case github = "github"
    case local = "local"
}

// MARK: - HerdrResponseStartupElement
public struct HerdrResponseStartupElement: Codable, Sendable {
    public let command: [String]
    public let platforms: [HerdrResponsePlatformElement]?

    public enum CodingKeys: String, CodingKey {
        case command = "command"
        case platforms = "platforms"
    }

    public init(command: [String], platforms: [HerdrResponsePlatformElement]?) {
        self.command = command
        self.platforms = platforms
    }
}

// MARK: HerdrResponseStartupElement convenience initializers and mutators

public extension HerdrResponseStartupElement {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseStartupElement.self, from: data)
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
        command: [String]? = nil,
        platforms: [HerdrResponsePlatformElement]?? = nil
    ) -> HerdrResponseStartupElement {
        return HerdrResponseStartupElement(
            command: command ?? self.command,
            platforms: platforms ?? self.platforms
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponsePluginPaneClass
public struct HerdrResponsePluginPaneClass: Codable, Sendable {
    public let entrypoint: String
    public let pane: HerdrResponseRootPaneElement
    public let pluginID: String

    public enum CodingKeys: String, CodingKey {
        case entrypoint = "entrypoint"
        case pane = "pane"
        case pluginID = "plugin_id"
    }

    public init(entrypoint: String, pane: HerdrResponseRootPaneElement, pluginID: String) {
        self.entrypoint = entrypoint
        self.pane = pane
        self.pluginID = pluginID
    }
}

// MARK: HerdrResponsePluginPaneClass convenience initializers and mutators

public extension HerdrResponsePluginPaneClass {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponsePluginPaneClass.self, from: data)
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
        entrypoint: String? = nil,
        pane: HerdrResponseRootPaneElement? = nil,
        pluginID: String? = nil
    ) -> HerdrResponsePluginPaneClass {
        return HerdrResponsePluginPaneClass(
            entrypoint: entrypoint ?? self.entrypoint,
            pane: pane ?? self.pane,
            pluginID: pluginID ?? self.pluginID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseProcessInfo
public struct HerdrResponseProcessInfo: Codable, Sendable {
    public let foregroundProcessGroupID: Int?
    public let foregroundProcesses: [HerdrResponseForegroundProcessElement]?
    public let paneID: PaneID
    public let shellPID: Int?
    public let tty: String?

    public enum CodingKeys: String, CodingKey {
        case foregroundProcessGroupID = "foreground_process_group_id"
        case foregroundProcesses = "foreground_processes"
        case paneID = "pane_id"
        case shellPID = "shell_pid"
        case tty = "tty"
    }

    public init(foregroundProcessGroupID: Int?, foregroundProcesses: [HerdrResponseForegroundProcessElement]?, paneID: PaneID, shellPID: Int?, tty: String?) {
        self.foregroundProcessGroupID = foregroundProcessGroupID
        self.foregroundProcesses = foregroundProcesses
        self.paneID = paneID
        self.shellPID = shellPID
        self.tty = tty
    }
}

// MARK: HerdrResponseProcessInfo convenience initializers and mutators

public extension HerdrResponseProcessInfo {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseProcessInfo.self, from: data)
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
        foregroundProcessGroupID: Int?? = nil,
        foregroundProcesses: [HerdrResponseForegroundProcessElement]?? = nil,
        paneID: PaneID? = nil,
        shellPID: Int?? = nil,
        tty: String?? = nil
    ) -> HerdrResponseProcessInfo {
        return HerdrResponseProcessInfo(
            foregroundProcessGroupID: foregroundProcessGroupID ?? self.foregroundProcessGroupID,
            foregroundProcesses: foregroundProcesses ?? self.foregroundProcesses,
            paneID: paneID ?? self.paneID,
            shellPID: shellPID ?? self.shellPID,
            tty: tty ?? self.tty
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseForegroundProcessElement
public struct HerdrResponseForegroundProcessElement: Codable, Sendable {
    public let argv: [String]?
    public let argv0: String?
    public let cmdline: String?
    public let cwd: String?
    public let name: String
    public let pid: Int

    public enum CodingKeys: String, CodingKey {
        case argv = "argv"
        case argv0 = "argv0"
        case cmdline = "cmdline"
        case cwd = "cwd"
        case name = "name"
        case pid = "pid"
    }

    public init(argv: [String]?, argv0: String?, cmdline: String?, cwd: String?, name: String, pid: Int) {
        self.argv = argv
        self.argv0 = argv0
        self.cmdline = cmdline
        self.cwd = cwd
        self.name = name
        self.pid = pid
    }
}

// MARK: HerdrResponseForegroundProcessElement convenience initializers and mutators

public extension HerdrResponseForegroundProcessElement {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseForegroundProcessElement.self, from: data)
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
        argv: [String]?? = nil,
        argv0: String?? = nil,
        cmdline: String?? = nil,
        cwd: String?? = nil,
        name: String? = nil,
        pid: Int? = nil
    ) -> HerdrResponseForegroundProcessElement {
        return HerdrResponseForegroundProcessElement(
            argv: argv ?? self.argv,
            argv0: argv0 ?? self.argv0,
            cmdline: cmdline ?? self.cmdline,
            cwd: cwd ?? self.cwd,
            name: name ?? self.name,
            pid: pid ?? self.pid
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrResponseRead
public struct HerdrResponseRead: Codable, Sendable {
    public let format: HerdrResponseFormat
    public let paneID: PaneID
    public let revision: Int
    public let source: HerdrResponseSourceEnum
    public let tabID: TabID
    public let text: String
    public let truncated: Bool
    public let workspaceID: WorkspaceID

    public enum CodingKeys: String, CodingKey {
        case format = "format"
        case paneID = "pane_id"
        case revision = "revision"
        case source = "source"
        case tabID = "tab_id"
        case text = "text"
        case truncated = "truncated"
        case workspaceID = "workspace_id"
    }

    public init(format: HerdrResponseFormat, paneID: PaneID, revision: Int, source: HerdrResponseSourceEnum, tabID: TabID, text: String, truncated: Bool, workspaceID: WorkspaceID) {
        self.format = format
        self.paneID = paneID
        self.revision = revision
        self.source = source
        self.tabID = tabID
        self.text = text
        self.truncated = truncated
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrResponseRead convenience initializers and mutators

public extension HerdrResponseRead {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseRead.self, from: data)
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
        format: HerdrResponseFormat? = nil,
        paneID: PaneID? = nil,
        revision: Int? = nil,
        source: HerdrResponseSourceEnum? = nil,
        tabID: TabID? = nil,
        text: String? = nil,
        truncated: Bool? = nil,
        workspaceID: WorkspaceID? = nil
    ) -> HerdrResponseRead {
        return HerdrResponseRead(
            format: format ?? self.format,
            paneID: paneID ?? self.paneID,
            revision: revision ?? self.revision,
            source: source ?? self.source,
            tabID: tabID ?? self.tabID,
            text: text ?? self.text,
            truncated: truncated ?? self.truncated,
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseFormat: String, Codable, Sendable {
    case ansi = "ansi"
    case text = "text"
}

public enum HerdrResponseSourceEnum: String, Codable, Sendable {
    case detection = "detection"
    case recent = "recent"
    case recentUnwrapped = "recent_unwrapped"
    case visible = "visible"
}

public enum HerdrResponseReason: String, Codable, Sendable {
    case busy = "busy"
    case cleared = "cleared"
    case disabled = "disabled"
    case noForegroundClient = "no_foreground_client"
    case rateLimited = "rate_limited"
    case reasonSet = "set"
    case shown = "shown"
}

// MARK: - HerdrResponseRes
public struct HerdrResponseRes: Codable, Sendable {
    public let changed: Bool
    public let focusedPaneID: PaneID
    public let layout: HerdrResponseLayoutElement
    public let paneID: PaneID
    public let reason: HerdrResponseResizeReason?

    public enum CodingKeys: String, CodingKey {
        case changed = "changed"
        case focusedPaneID = "focused_pane_id"
        case layout = "layout"
        case paneID = "pane_id"
        case reason = "reason"
    }

    public init(changed: Bool, focusedPaneID: PaneID, layout: HerdrResponseLayoutElement, paneID: PaneID, reason: HerdrResponseResizeReason?) {
        self.changed = changed
        self.focusedPaneID = focusedPaneID
        self.layout = layout
        self.paneID = paneID
        self.reason = reason
    }
}

// MARK: HerdrResponseRes convenience initializers and mutators

public extension HerdrResponseRes {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseRes.self, from: data)
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
        changed: Bool? = nil,
        focusedPaneID: PaneID? = nil,
        layout: HerdrResponseLayoutElement? = nil,
        paneID: PaneID? = nil,
        reason: HerdrResponseResizeReason?? = nil
    ) -> HerdrResponseRes {
        return HerdrResponseRes(
            changed: changed ?? self.changed,
            focusedPaneID: focusedPaneID ?? self.focusedPaneID,
            layout: layout ?? self.layout,
            paneID: paneID ?? self.paneID,
            reason: reason ?? self.reason
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseResizeReason: String, Codable, Sendable {
    case unchanged = "unchanged"
}

// MARK: - HerdrResponseSnapshot
public struct HerdrResponseSnapshot: Codable, Sendable {
    public let agents: [HerdrResponseAgentElement]
    public let focusedPaneID: PaneID?
    public let focusedTabID: TabID?
    public let focusedWorkspaceID: WorkspaceID?
    public let layouts: [HerdrResponseLayoutElement]
    public let panes: [HerdrResponseRootPaneElement]
    public let snapshotProtocol: Int
    public let tabs: [HerdrResponseTabElement]
    public let version: String
    public let workspaces: [HerdrResponseWorkspaceElement]

    public enum CodingKeys: String, CodingKey {
        case agents = "agents"
        case focusedPaneID = "focused_pane_id"
        case focusedTabID = "focused_tab_id"
        case focusedWorkspaceID = "focused_workspace_id"
        case layouts = "layouts"
        case panes = "panes"
        case snapshotProtocol = "protocol"
        case tabs = "tabs"
        case version = "version"
        case workspaces = "workspaces"
    }

    public init(agents: [HerdrResponseAgentElement], focusedPaneID: PaneID?, focusedTabID: TabID?, focusedWorkspaceID: WorkspaceID?, layouts: [HerdrResponseLayoutElement], panes: [HerdrResponseRootPaneElement], snapshotProtocol: Int, tabs: [HerdrResponseTabElement], version: String, workspaces: [HerdrResponseWorkspaceElement]) {
        self.agents = agents
        self.focusedPaneID = focusedPaneID
        self.focusedTabID = focusedTabID
        self.focusedWorkspaceID = focusedWorkspaceID
        self.layouts = layouts
        self.panes = panes
        self.snapshotProtocol = snapshotProtocol
        self.tabs = tabs
        self.version = version
        self.workspaces = workspaces
    }
}

// MARK: HerdrResponseSnapshot convenience initializers and mutators

public extension HerdrResponseSnapshot {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseSnapshot.self, from: data)
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
        agents: [HerdrResponseAgentElement]? = nil,
        focusedPaneID: PaneID?? = nil,
        focusedTabID: TabID?? = nil,
        focusedWorkspaceID: WorkspaceID?? = nil,
        layouts: [HerdrResponseLayoutElement]? = nil,
        panes: [HerdrResponseRootPaneElement]? = nil,
        snapshotProtocol: Int? = nil,
        tabs: [HerdrResponseTabElement]? = nil,
        version: String? = nil,
        workspaces: [HerdrResponseWorkspaceElement]? = nil
    ) -> HerdrResponseSnapshot {
        return HerdrResponseSnapshot(
            agents: agents ?? self.agents,
            focusedPaneID: focusedPaneID ?? self.focusedPaneID,
            focusedTabID: focusedTabID ?? self.focusedTabID,
            focusedWorkspaceID: focusedWorkspaceID ?? self.focusedWorkspaceID,
            layouts: layouts ?? self.layouts,
            panes: panes ?? self.panes,
            snapshotProtocol: snapshotProtocol ?? self.snapshotProtocol,
            tabs: tabs ?? self.tabs,
            version: version ?? self.version,
            workspaces: workspaces ?? self.workspaces
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseAgent: Codable, Sendable {
    case herdrResponseSourceSource(HerdrResponseSourceSource)
    case string(String)
    case null

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(HerdrResponseSourceSource.self) {
            self = .herdrResponseSourceSource(x)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        throw DecodingError.typeMismatch(HerdrResponseAgent.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for HerdrResponseAgent"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .herdrResponseSourceSource(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .null:
            try container.encodeNil()
        }
    }
}

// MARK: - HerdrResponseSourceSource
public struct HerdrResponseSourceSource: Codable, Sendable {
    public let repoKey: String
    public let repoName: String
    public let repoRoot: String
    public let sourceCheckoutPath: String
    public let sourceWorkspaceID: WorkspaceID?

    public enum CodingKeys: String, CodingKey {
        case repoKey = "repo_key"
        case repoName = "repo_name"
        case repoRoot = "repo_root"
        case sourceCheckoutPath = "source_checkout_path"
        case sourceWorkspaceID = "source_workspace_id"
    }

    public init(repoKey: String, repoName: String, repoRoot: String, sourceCheckoutPath: String, sourceWorkspaceID: WorkspaceID?) {
        self.repoKey = repoKey
        self.repoName = repoName
        self.repoRoot = repoRoot
        self.sourceCheckoutPath = sourceCheckoutPath
        self.sourceWorkspaceID = sourceWorkspaceID
    }
}

// MARK: HerdrResponseSourceSource convenience initializers and mutators

public extension HerdrResponseSourceSource {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseSourceSource.self, from: data)
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
        repoKey: String? = nil,
        repoName: String? = nil,
        repoRoot: String? = nil,
        sourceCheckoutPath: String? = nil,
        sourceWorkspaceID: WorkspaceID?? = nil
    ) -> HerdrResponseSourceSource {
        return HerdrResponseSourceSource(
            repoKey: repoKey ?? self.repoKey,
            repoName: repoName ?? self.repoName,
            repoRoot: repoRoot ?? self.repoRoot,
            sourceCheckoutPath: sourceCheckoutPath ?? self.sourceCheckoutPath,
            sourceWorkspaceID: sourceWorkspaceID ?? self.sourceWorkspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseResponseResultStatus: String, Codable, Sendable {
    case applied = "applied"
    case failed = "failed"
    case partial = "partial"
}

// MARK: - HerdrResponseSwap
public struct HerdrResponseSwap: Codable, Sendable {
    public let changed: Bool
    public let focusedPaneID: PaneID
    public let layout: HerdrResponseLayoutElement
    public let reason: HerdrResponseSwapReason?
    public let sourcePaneID: PaneID
    public let targetPaneID: PaneID?

    public enum CodingKeys: String, CodingKey {
        case changed = "changed"
        case focusedPaneID = "focused_pane_id"
        case layout = "layout"
        case reason = "reason"
        case sourcePaneID = "source_pane_id"
        case targetPaneID = "target_pane_id"
    }

    public init(changed: Bool, focusedPaneID: PaneID, layout: HerdrResponseLayoutElement, reason: HerdrResponseSwapReason?, sourcePaneID: PaneID, targetPaneID: PaneID?) {
        self.changed = changed
        self.focusedPaneID = focusedPaneID
        self.layout = layout
        self.reason = reason
        self.sourcePaneID = sourcePaneID
        self.targetPaneID = targetPaneID
    }
}

// MARK: HerdrResponseSwap convenience initializers and mutators

public extension HerdrResponseSwap {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseSwap.self, from: data)
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
        changed: Bool? = nil,
        focusedPaneID: PaneID? = nil,
        layout: HerdrResponseLayoutElement? = nil,
        reason: HerdrResponseSwapReason?? = nil,
        sourcePaneID: PaneID? = nil,
        targetPaneID: PaneID?? = nil
    ) -> HerdrResponseSwap {
        return HerdrResponseSwap(
            changed: changed ?? self.changed,
            focusedPaneID: focusedPaneID ?? self.focusedPaneID,
            layout: layout ?? self.layout,
            reason: reason ?? self.reason,
            sourcePaneID: sourcePaneID ?? self.sourcePaneID,
            targetPaneID: targetPaneID ?? self.targetPaneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseSwapReason: String, Codable, Sendable {
    case crossTab = "cross_tab"
    case noNeighbor = "no_neighbor"
    case notFound = "not_found"
    case samePane = "same_pane"
}

public enum HerdrResponseTarget: String, Codable, Sendable {
    case claude = "claude"
    case codex = "codex"
    case copilot = "copilot"
    case cursor = "cursor"
    case devin = "devin"
    case droid = "droid"
    case hermes = "hermes"
    case kilo = "kilo"
    case kimi = "kimi"
    case mastracode = "mastracode"
    case omp = "omp"
    case opencode = "opencode"
    case pi = "pi"
    case qodercli = "qodercli"
}

public enum HerdrResponseResponseResultType: String, Codable, Sendable {
    case agentExplain = "agent_explain"
    case agentInfo = "agent_info"
    case agentList = "agent_list"
    case agentManifestReload = "agent_manifest_reload"
    case agentManifestStatus = "agent_manifest_status"
    case agentPrompted = "agent_prompted"
    case agentStarted = "agent_started"
    case agentView = "agent_view"
    case clientWindowTitle = "client_window_title"
    case configReload = "config_reload"
    case integrationInstall = "integration_install"
    case integrationUninstall = "integration_uninstall"
    case layoutApply = "layout_apply"
    case layoutExport = "layout_export"
    case layoutSplitRatioSet = "layout_split_ratio_set"
    case notificationShow = "notification_show"
    case ok = "ok"
    case outputMatched = "output_matched"
    case paneCurrent = "pane_current"
    case paneEdges = "pane_edges"
    case paneFocusDirection = "pane_focus_direction"
    case paneGraphicsInfo = "pane_graphics_info"
    case paneInfo = "pane_info"
    case paneLayout = "pane_layout"
    case paneList = "pane_list"
    case paneMove = "pane_move"
    case paneNeighbor = "pane_neighbor"
    case paneProcessInfo = "pane_process_info"
    case paneRead = "pane_read"
    case paneResize = "pane_resize"
    case paneSwap = "pane_swap"
    case paneZoom = "pane_zoom"
    case pluginActionInvoked = "plugin_action_invoked"
    case pluginActionList = "plugin_action_list"
    case pluginDisabled = "plugin_disabled"
    case pluginEnabled = "plugin_enabled"
    case pluginLinked = "plugin_linked"
    case pluginList = "plugin_list"
    case pluginLogList = "plugin_log_list"
    case pluginPaneClosed = "plugin_pane_closed"
    case pluginPaneFocused = "plugin_pane_focused"
    case pluginPaneOpened = "plugin_pane_opened"
    case pluginUnlinked = "plugin_unlinked"
    case pong = "pong"
    case sessionSnapshot = "session_snapshot"
    case subscriptionStarted = "subscription_started"
    case tabCreated = "tab_created"
    case tabInfo = "tab_info"
    case tabList = "tab_list"
    case waitMatched = "wait_matched"
    case workspaceCreated = "workspace_created"
    case workspaceInfo = "workspace_info"
    case workspaceList = "workspace_list"
    case worktreeCreated = "worktree_created"
    case worktreeList = "worktree_list"
    case worktreeOpened = "worktree_opened"
    case worktreeRemoved = "worktree_removed"
}

// MARK: - HerdrResponseZoom
public struct HerdrResponseZoom: Codable, Sendable {
    public let changed: Bool
    public let focusChanged: Bool
    public let focusedPaneID: PaneID
    public let layout: HerdrResponseLayoutElement
    public let paneID: PaneID
    public let reason: HerdrResponseZoomReason?
    public let zoomChanged: Bool
    public let zoomed: Bool

    public enum CodingKeys: String, CodingKey {
        case changed = "changed"
        case focusChanged = "focus_changed"
        case focusedPaneID = "focused_pane_id"
        case layout = "layout"
        case paneID = "pane_id"
        case reason = "reason"
        case zoomChanged = "zoom_changed"
        case zoomed = "zoomed"
    }

    public init(changed: Bool, focusChanged: Bool, focusedPaneID: PaneID, layout: HerdrResponseLayoutElement, paneID: PaneID, reason: HerdrResponseZoomReason?, zoomChanged: Bool, zoomed: Bool) {
        self.changed = changed
        self.focusChanged = focusChanged
        self.focusedPaneID = focusedPaneID
        self.layout = layout
        self.paneID = paneID
        self.reason = reason
        self.zoomChanged = zoomChanged
        self.zoomed = zoomed
    }
}

// MARK: HerdrResponseZoom convenience initializers and mutators

public extension HerdrResponseZoom {
    init(data: Data) throws {
        self = try newHerdrResponseJSONDecoder().decode(HerdrResponseZoom.self, from: data)
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
        changed: Bool? = nil,
        focusChanged: Bool? = nil,
        focusedPaneID: PaneID? = nil,
        layout: HerdrResponseLayoutElement? = nil,
        paneID: PaneID? = nil,
        reason: HerdrResponseZoomReason?? = nil,
        zoomChanged: Bool? = nil,
        zoomed: Bool? = nil
    ) -> HerdrResponseZoom {
        return HerdrResponseZoom(
            changed: changed ?? self.changed,
            focusChanged: focusChanged ?? self.focusChanged,
            focusedPaneID: focusedPaneID ?? self.focusedPaneID,
            layout: layout ?? self.layout,
            paneID: paneID ?? self.paneID,
            reason: reason ?? self.reason,
            zoomChanged: zoomChanged ?? self.zoomChanged,
            zoomed: zoomed ?? self.zoomed
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrResponseJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrResponseZoomReason: String, Codable, Sendable {
    case alreadyUnzoomed = "already_unzoomed"
    case alreadyZoomed = "already_zoomed"
    case singlePane = "single_pane"
}

// MARK: - Helper functions for creating encoders and decoders

func newHerdrResponseJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newHerdrResponseJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Encode/decode helpers

public final class HerdrResponseJSONNull: Codable, Hashable, Sendable {

    public static func == (lhs: HerdrResponseJSONNull, rhs: HerdrResponseJSONNull) -> Bool {
            return true
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(HerdrResponseJSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for HerdrResponseJSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

final class HerdrResponseJSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
            return nil
    }

    required init?(stringValue: String) {
            key = stringValue
    }

    var intValue: Int? {
            return nil
    }

    var stringValue: String {
            return key
    }
}

public final class HerdrResponseJSONValue: Codable, @unchecked Sendable {

    public let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode HerdrResponseJSONValue")
            return DecodingError.typeMismatch(HerdrResponseJSONValue.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode HerdrResponseJSONValue")
            return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if container.decodeNil() {
                    return HerdrResponseJSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if let value = try? container.decodeNil() {
                    if value {
                            return HerdrResponseJSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: HerdrResponseJSONCodingKey.self) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<HerdrResponseJSONCodingKey>, forKey key: HerdrResponseJSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                    return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                    if value {
                            return HerdrResponseJSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: HerdrResponseJSONCodingKey.self, forKey: key) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                    let value = try decode(from: &container)
                    arr.append(value)
            }
            return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<HerdrResponseJSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                    let value = try decode(from: &container, forKey: key)
                    dict[key.stringValue] = value
            }
            return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                    if let value = value as? Bool {
                            try container.encode(value)
                    } else if let value = value as? Int64 {
                            try container.encode(value)
                    } else if let value = value as? Double {
                            try container.encode(value)
                    } else if let value = value as? String {
                            try container.encode(value)
                    } else if value is HerdrResponseJSONNull {
                            try container.encodeNil()
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer()
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: HerdrResponseJSONCodingKey.self)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout KeyedEncodingContainer<HerdrResponseJSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                    let key = HerdrResponseJSONCodingKey(stringValue: key)!
                    if let value = value as? Bool {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Int64 {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Double {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? String {
                            try container.encode(value, forKey: key)
                    } else if value is HerdrResponseJSONNull {
                            try container.encodeNil(forKey: key)
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer(forKey: key)
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: HerdrResponseJSONCodingKey.self, forKey: key)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                    try container.encode(value)
            } else if let value = value as? Int64 {
                    try container.encode(value)
            } else if let value = value as? Double {
                    try container.encode(value)
            } else if let value = value as? String {
                    try container.encode(value)
            } else if value is HerdrResponseJSONNull {
                    try container.encodeNil()
            } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
            }
    }

    public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                    self.value = try HerdrResponseJSONValue.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: HerdrResponseJSONCodingKey.self) {
                    self.value = try HerdrResponseJSONValue.decodeDictionary(from: &container)
            } else {
                    let container = try decoder.singleValueContainer()
                    self.value = try HerdrResponseJSONValue.decode(from: container)
            }
    }

    public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                    var container = encoder.unkeyedContainer()
                    try HerdrResponseJSONValue.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                    var container = encoder.container(keyedBy: HerdrResponseJSONCodingKey.self)
                    try HerdrResponseJSONValue.encode(to: &container, dictionary: dict)
            } else {
                    var container = encoder.singleValueContainer()
                    try HerdrResponseJSONValue.encode(to: &container, value: self.value)
            }
    }
}
