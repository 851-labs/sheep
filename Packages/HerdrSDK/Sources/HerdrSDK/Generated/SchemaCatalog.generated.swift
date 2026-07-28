// Generated from Herdr protocol 17, schema 1.
// Do not edit by hand; run Scripts/generate-herdr-sdk.mjs.

import Foundation

public enum HerdrProtocolMetadata {
    public static let protocolVersion = 17
    public static let schemaVersion = 1
    public static let schemaSHA256 = "1ef4eb9ec655cb0c89726895f437d8654bdde13a22e591fda06a9015d03d88c7"
}

public enum HerdrMethod: String, Codable, CaseIterable, Sendable {
    case ping = "ping"
    case serverStop = "server.stop"
    case serverLiveHandoff = "server.live_handoff"
    case serverReloadConfig = "server.reload_config"
    case serverAgentManifests = "server.agent_manifests"
    case serverReloadAgentManifests = "server.reload_agent_manifests"
    case notificationShow = "notification.show"
    case clientWindowTitleSet = "client.window_title.set"
    case clientWindowTitleClear = "client.window_title.clear"
    case sessionSnapshot = "session.snapshot"
    case workspaceCreate = "workspace.create"
    case workspaceList = "workspace.list"
    case workspaceGet = "workspace.get"
    case workspaceFocus = "workspace.focus"
    case workspaceRename = "workspace.rename"
    case workspaceMove = "workspace.move"
    case workspaceReportMetadata = "workspace.report_metadata"
    case workspaceClose = "workspace.close"
    case worktreeList = "worktree.list"
    case worktreeCreate = "worktree.create"
    case worktreeOpen = "worktree.open"
    case worktreeRemove = "worktree.remove"
    case tabCreate = "tab.create"
    case tabList = "tab.list"
    case tabGet = "tab.get"
    case tabFocus = "tab.focus"
    case tabRename = "tab.rename"
    case tabMove = "tab.move"
    case tabClose = "tab.close"
    case agentList = "agent.list"
    case agentGet = "agent.get"
    case agentRead = "agent.read"
    case agentExplain = "agent.explain"
    case agentSendKeys = "agent.send_keys"
    case agentRename = "agent.rename"
    case agentViewSet = "agent.view.set"
    case agentViewClear = "agent.view.clear"
    case agentFocus = "agent.focus"
    case agentStart = "agent.start"
    case agentPrompt = "agent.prompt"
    case agentWait = "agent.wait"
    case paneSplit = "pane.split"
    case paneSwap = "pane.swap"
    case paneMove = "pane.move"
    case paneZoom = "pane.zoom"
    case paneLayout = "pane.layout"
    case paneProcessInfo = "pane.process_info"
    case layoutExport = "layout.export"
    case layoutApply = "layout.apply"
    case layoutSetSplitRatio = "layout.set_split_ratio"
    case paneNeighbor = "pane.neighbor"
    case paneEdges = "pane.edges"
    case paneFocusDirection = "pane.focus_direction"
    case paneResize = "pane.resize"
    case paneList = "pane.list"
    case paneCurrent = "pane.current"
    case paneGet = "pane.get"
    case paneFocus = "pane.focus"
    case paneRename = "pane.rename"
    case paneSendText = "pane.send_text"
    case paneSendKeys = "pane.send_keys"
    case paneSendInput = "pane.send_input"
    case paneRead = "pane.read"
    case paneGraphicsSet = "pane.graphics.set"
    case paneGraphicsClear = "pane.graphics.clear"
    case paneGraphicsInfo = "pane.graphics.info"
    case paneReportAgent = "pane.report_agent"
    case paneReportAgentSession = "pane.report_agent_session"
    case paneReportMetadata = "pane.report_metadata"
    case paneClearAgentAuthority = "pane.clear_agent_authority"
    case paneReleaseAgent = "pane.release_agent"
    case paneClose = "pane.close"
    case popupClose = "popup.close"
    case eventsSubscribe = "events.subscribe"
    case eventsWait = "events.wait"
    case paneWaitForOutput = "pane.wait_for_output"
    case integrationInstall = "integration.install"
    case integrationUninstall = "integration.uninstall"
    case pluginLink = "plugin.link"
    case pluginList = "plugin.list"
    case pluginUnlink = "plugin.unlink"
    case pluginEnable = "plugin.enable"
    case pluginDisable = "plugin.disable"
    case pluginActionList = "plugin.action.list"
    case pluginActionInvoke = "plugin.action.invoke"
    case pluginLogList = "plugin.log.list"
    case pluginPaneOpen = "plugin.pane.open"
    case pluginPaneFocus = "plugin.pane.focus"
    case pluginPaneClose = "plugin.pane.close"

    // The binary stream is documented separately and intentionally omitted
    // from the JSON request schema.
    case paneGraphicsStream = "pane.graphics.stream"
}

public enum HerdrSchemaCatalog {
    public static let methods: Set<String> = [
        "ping",
        "server.stop",
        "server.live_handoff",
        "server.reload_config",
        "server.agent_manifests",
        "server.reload_agent_manifests",
        "notification.show",
        "client.window_title.set",
        "client.window_title.clear",
        "session.snapshot",
        "workspace.create",
        "workspace.list",
        "workspace.get",
        "workspace.focus",
        "workspace.rename",
        "workspace.move",
        "workspace.report_metadata",
        "workspace.close",
        "worktree.list",
        "worktree.create",
        "worktree.open",
        "worktree.remove",
        "tab.create",
        "tab.list",
        "tab.get",
        "tab.focus",
        "tab.rename",
        "tab.move",
        "tab.close",
        "agent.list",
        "agent.get",
        "agent.read",
        "agent.explain",
        "agent.send_keys",
        "agent.rename",
        "agent.view.set",
        "agent.view.clear",
        "agent.focus",
        "agent.start",
        "agent.prompt",
        "agent.wait",
        "pane.split",
        "pane.swap",
        "pane.move",
        "pane.zoom",
        "pane.layout",
        "pane.process_info",
        "layout.export",
        "layout.apply",
        "layout.set_split_ratio",
        "pane.neighbor",
        "pane.edges",
        "pane.focus_direction",
        "pane.resize",
        "pane.list",
        "pane.current",
        "pane.get",
        "pane.focus",
        "pane.rename",
        "pane.send_text",
        "pane.send_keys",
        "pane.send_input",
        "pane.read",
        "pane.graphics.set",
        "pane.graphics.clear",
        "pane.graphics.info",
        "pane.report_agent",
        "pane.report_agent_session",
        "pane.report_metadata",
        "pane.clear_agent_authority",
        "pane.release_agent",
        "pane.close",
        "popup.close",
        "events.subscribe",
        "events.wait",
        "pane.wait_for_output",
        "integration.install",
        "integration.uninstall",
        "plugin.link",
        "plugin.list",
        "plugin.unlink",
        "plugin.enable",
        "plugin.disable",
        "plugin.action.list",
        "plugin.action.invoke",
        "plugin.log.list",
        "plugin.pane.open",
        "plugin.pane.focus",
        "plugin.pane.close",
        "pane.graphics.stream",
    ]

    public static let resultTypes: Set<String> = [
        "pong",
        "session_snapshot",
        "workspace_info",
        "workspace_created",
        "workspace_list",
        "worktree_list",
        "worktree_created",
        "worktree_opened",
        "worktree_removed",
        "tab_info",
        "tab_created",
        "tab_list",
        "agent_info",
        "agent_started",
        "agent_prompted",
        "agent_list",
        "agent_view",
        "pane_info",
        "pane_list",
        "pane_current",
        "pane_swap",
        "pane_move",
        "pane_zoom",
        "pane_layout",
        "pane_process_info",
        "layout_export",
        "layout_apply",
        "layout_split_ratio_set",
        "pane_neighbor",
        "pane_edges",
        "pane_focus_direction",
        "pane_resize",
        "pane_read",
        "pane_graphics_info",
        "agent_explain",
        "subscription_started",
        "wait_matched",
        "output_matched",
        "notification_show",
        "client_window_title",
        "integration_install",
        "integration_uninstall",
        "agent_manifest_reload",
        "agent_manifest_status",
        "plugin_linked",
        "plugin_list",
        "plugin_unlinked",
        "plugin_enabled",
        "plugin_disabled",
        "plugin_action_list",
        "plugin_action_invoked",
        "plugin_log_list",
        "plugin_pane_opened",
        "plugin_pane_focused",
        "plugin_pane_closed",
        "config_reload",
        "ok",
    ]

    public static let eventTypes: Set<String> = [
        "workspace_created",
        "workspace_updated",
        "workspace_metadata_updated",
        "workspace_closed",
        "workspace_renamed",
        "workspace_moved",
        "workspace_focused",
        "worktree_created",
        "worktree_opened",
        "worktree_removed",
        "tab_created",
        "tab_closed",
        "tab_renamed",
        "tab_moved",
        "tab_focused",
        "pane_created",
        "pane_closed",
        "pane_updated",
        "pane_focused",
        "pane_moved",
        "pane_output_changed",
        "pane_exited",
        "pane_agent_detected",
        "pane_agent_status_changed",
        "layout_updated",
    ]

    public static let subscriptionTypes: Set<String> = [
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
        "pane.output_matched",
        "pane.agent_status_changed",
        "pane.scroll_changed",
        "layout.updated",
    ]

    public static let subscriptionEventTypes: Set<String> = [
        "pane.output_matched",
        "pane.agent_status_changed",
        "pane.scroll_changed",
    ]
}

public enum HerdrSuccessResult: Codable, Sendable {
    case pong(HerdrResponseResponse)
    case sessionSnapshot(HerdrResponseResponse)
    case workspaceInfo(HerdrResponseResponse)
    case workspaceCreated(HerdrResponseResponse)
    case workspaceList(HerdrResponseResponse)
    case worktreeList(HerdrResponseResponse)
    case worktreeCreated(HerdrResponseResponse)
    case worktreeOpened(HerdrResponseResponse)
    case worktreeRemoved(HerdrResponseResponse)
    case tabInfo(HerdrResponseResponse)
    case tabCreated(HerdrResponseResponse)
    case tabList(HerdrResponseResponse)
    case agentInfo(HerdrResponseResponse)
    case agentStarted(HerdrResponseResponse)
    case agentPrompted(HerdrResponseResponse)
    case agentList(HerdrResponseResponse)
    case agentView(HerdrResponseResponse)
    case paneInfo(HerdrResponseResponse)
    case paneList(HerdrResponseResponse)
    case paneCurrent(HerdrResponseResponse)
    case paneSwap(HerdrResponseResponse)
    case paneMove(HerdrResponseResponse)
    case paneZoom(HerdrResponseResponse)
    case paneLayout(HerdrResponseResponse)
    case paneProcessInfo(HerdrResponseResponse)
    case layoutExport(HerdrResponseResponse)
    case layoutApply(HerdrResponseResponse)
    case layoutSplitRatioSet(HerdrResponseResponse)
    case paneNeighbor(HerdrResponseResponse)
    case paneEdges(HerdrResponseResponse)
    case paneFocusDirection(HerdrResponseResponse)
    case paneResize(HerdrResponseResponse)
    case paneRead(HerdrResponseResponse)
    case paneGraphicsInfo(HerdrResponseResponse)
    case agentExplain(HerdrResponseResponse)
    case subscriptionStarted(HerdrResponseResponse)
    case waitMatched(HerdrResponseResponse)
    case outputMatched(HerdrResponseResponse)
    case notificationShow(HerdrResponseResponse)
    case clientWindowTitle(HerdrResponseResponse)
    case integrationInstall(HerdrResponseResponse)
    case integrationUninstall(HerdrResponseResponse)
    case agentManifestReload(HerdrResponseResponse)
    case agentManifestStatus(HerdrResponseResponse)
    case pluginLinked(HerdrResponseResponse)
    case pluginList(HerdrResponseResponse)
    case pluginUnlinked(HerdrResponseResponse)
    case pluginEnabled(HerdrResponseResponse)
    case pluginDisabled(HerdrResponseResponse)
    case pluginActionList(HerdrResponseResponse)
    case pluginActionInvoked(HerdrResponseResponse)
    case pluginLogList(HerdrResponseResponse)
    case pluginPaneOpened(HerdrResponseResponse)
    case pluginPaneFocused(HerdrResponseResponse)
    case pluginPaneClosed(HerdrResponseResponse)
    case configReload(HerdrResponseResponse)
    case ok(HerdrResponseResponse)

    public init(from decoder: Decoder) throws {
        let discriminator = try decoder.container(
            keyedBy: HerdrResultDiscriminatorKey.self
        ).decode(String.self, forKey: .type)
        guard HerdrSchemaCatalog.resultTypes.contains(discriminator) else {
            throw HerdrCompatibilityError.unknownResultDiscriminator(discriminator)
        }
        let value = try HerdrResponseResponse(from: decoder)
        switch value.type {
        case .pong: self = .pong(value)
        case .sessionSnapshot: self = .sessionSnapshot(value)
        case .workspaceInfo: self = .workspaceInfo(value)
        case .workspaceCreated: self = .workspaceCreated(value)
        case .workspaceList: self = .workspaceList(value)
        case .worktreeList: self = .worktreeList(value)
        case .worktreeCreated: self = .worktreeCreated(value)
        case .worktreeOpened: self = .worktreeOpened(value)
        case .worktreeRemoved: self = .worktreeRemoved(value)
        case .tabInfo: self = .tabInfo(value)
        case .tabCreated: self = .tabCreated(value)
        case .tabList: self = .tabList(value)
        case .agentInfo: self = .agentInfo(value)
        case .agentStarted: self = .agentStarted(value)
        case .agentPrompted: self = .agentPrompted(value)
        case .agentList: self = .agentList(value)
        case .agentView: self = .agentView(value)
        case .paneInfo: self = .paneInfo(value)
        case .paneList: self = .paneList(value)
        case .paneCurrent: self = .paneCurrent(value)
        case .paneSwap: self = .paneSwap(value)
        case .paneMove: self = .paneMove(value)
        case .paneZoom: self = .paneZoom(value)
        case .paneLayout: self = .paneLayout(value)
        case .paneProcessInfo: self = .paneProcessInfo(value)
        case .layoutExport: self = .layoutExport(value)
        case .layoutApply: self = .layoutApply(value)
        case .layoutSplitRatioSet: self = .layoutSplitRatioSet(value)
        case .paneNeighbor: self = .paneNeighbor(value)
        case .paneEdges: self = .paneEdges(value)
        case .paneFocusDirection: self = .paneFocusDirection(value)
        case .paneResize: self = .paneResize(value)
        case .paneRead: self = .paneRead(value)
        case .paneGraphicsInfo: self = .paneGraphicsInfo(value)
        case .agentExplain: self = .agentExplain(value)
        case .subscriptionStarted: self = .subscriptionStarted(value)
        case .waitMatched: self = .waitMatched(value)
        case .outputMatched: self = .outputMatched(value)
        case .notificationShow: self = .notificationShow(value)
        case .clientWindowTitle: self = .clientWindowTitle(value)
        case .integrationInstall: self = .integrationInstall(value)
        case .integrationUninstall: self = .integrationUninstall(value)
        case .agentManifestReload: self = .agentManifestReload(value)
        case .agentManifestStatus: self = .agentManifestStatus(value)
        case .pluginLinked: self = .pluginLinked(value)
        case .pluginList: self = .pluginList(value)
        case .pluginUnlinked: self = .pluginUnlinked(value)
        case .pluginEnabled: self = .pluginEnabled(value)
        case .pluginDisabled: self = .pluginDisabled(value)
        case .pluginActionList: self = .pluginActionList(value)
        case .pluginActionInvoked: self = .pluginActionInvoked(value)
        case .pluginLogList: self = .pluginLogList(value)
        case .pluginPaneOpened: self = .pluginPaneOpened(value)
        case .pluginPaneFocused: self = .pluginPaneFocused(value)
        case .pluginPaneClosed: self = .pluginPaneClosed(value)
        case .configReload: self = .configReload(value)
        case .ok: self = .ok(value)
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case let .pong(value), let .sessionSnapshot(value), let .workspaceInfo(value), let .workspaceCreated(value), let .workspaceList(value), let .worktreeList(value), let .worktreeCreated(value), let .worktreeOpened(value), let .worktreeRemoved(value), let .tabInfo(value), let .tabCreated(value), let .tabList(value), let .agentInfo(value), let .agentStarted(value), let .agentPrompted(value), let .agentList(value), let .agentView(value), let .paneInfo(value), let .paneList(value), let .paneCurrent(value), let .paneSwap(value), let .paneMove(value), let .paneZoom(value), let .paneLayout(value), let .paneProcessInfo(value), let .layoutExport(value), let .layoutApply(value), let .layoutSplitRatioSet(value), let .paneNeighbor(value), let .paneEdges(value), let .paneFocusDirection(value), let .paneResize(value), let .paneRead(value), let .paneGraphicsInfo(value), let .agentExplain(value), let .subscriptionStarted(value), let .waitMatched(value), let .outputMatched(value), let .notificationShow(value), let .clientWindowTitle(value), let .integrationInstall(value), let .integrationUninstall(value), let .agentManifestReload(value), let .agentManifestStatus(value), let .pluginLinked(value), let .pluginList(value), let .pluginUnlinked(value), let .pluginEnabled(value), let .pluginDisabled(value), let .pluginActionList(value), let .pluginActionInvoked(value), let .pluginLogList(value), let .pluginPaneOpened(value), let .pluginPaneFocused(value), let .pluginPaneClosed(value), let .configReload(value), let .ok(value):
            try value.encode(to: encoder)
        }
    }

    public var value: HerdrResponseResponse {
        switch self {
        case let .pong(value), let .sessionSnapshot(value), let .workspaceInfo(value), let .workspaceCreated(value), let .workspaceList(value), let .worktreeList(value), let .worktreeCreated(value), let .worktreeOpened(value), let .worktreeRemoved(value), let .tabInfo(value), let .tabCreated(value), let .tabList(value), let .agentInfo(value), let .agentStarted(value), let .agentPrompted(value), let .agentList(value), let .agentView(value), let .paneInfo(value), let .paneList(value), let .paneCurrent(value), let .paneSwap(value), let .paneMove(value), let .paneZoom(value), let .paneLayout(value), let .paneProcessInfo(value), let .layoutExport(value), let .layoutApply(value), let .layoutSplitRatioSet(value), let .paneNeighbor(value), let .paneEdges(value), let .paneFocusDirection(value), let .paneResize(value), let .paneRead(value), let .paneGraphicsInfo(value), let .agentExplain(value), let .subscriptionStarted(value), let .waitMatched(value), let .outputMatched(value), let .notificationShow(value), let .clientWindowTitle(value), let .integrationInstall(value), let .integrationUninstall(value), let .agentManifestReload(value), let .agentManifestStatus(value), let .pluginLinked(value), let .pluginList(value), let .pluginUnlinked(value), let .pluginEnabled(value), let .pluginDisabled(value), let .pluginActionList(value), let .pluginActionInvoked(value), let .pluginLogList(value), let .pluginPaneOpened(value), let .pluginPaneFocused(value), let .pluginPaneClosed(value), let .configReload(value), let .ok(value):
            value
        }
    }
}

private enum HerdrResultDiscriminatorKey: String, CodingKey {
    case type
}

public enum HerdrEndpoints {
    public static func ping(_ params: HerdrEmptyParameters = .init()) -> HerdrEndpoint<HerdrEmptyParameters> {
        HerdrEndpoint(method: .ping, params: params)
    }

    public static func serverStop(_ params: HerdrEmptyParameters = .init()) -> HerdrEndpoint<HerdrEmptyParameters> {
        HerdrEndpoint(method: .serverStop, params: params)
    }

    public static func serverLiveHandoff(_ params: HerdrRequestServerLiveHandoffParams) -> HerdrEndpoint<HerdrRequestServerLiveHandoffParams> {
        HerdrEndpoint(method: .serverLiveHandoff, params: params)
    }

    public static func serverReloadConfig(_ params: HerdrEmptyParameters = .init()) -> HerdrEndpoint<HerdrEmptyParameters> {
        HerdrEndpoint(method: .serverReloadConfig, params: params)
    }

    public static func serverAgentManifests(_ params: HerdrEmptyParameters = .init()) -> HerdrEndpoint<HerdrEmptyParameters> {
        HerdrEndpoint(method: .serverAgentManifests, params: params)
    }

    public static func serverReloadAgentManifests(_ params: HerdrEmptyParameters = .init()) -> HerdrEndpoint<HerdrEmptyParameters> {
        HerdrEndpoint(method: .serverReloadAgentManifests, params: params)
    }

    public static func notificationShow(_ params: HerdrRequestNotificationShowParams) -> HerdrEndpoint<HerdrRequestNotificationShowParams> {
        HerdrEndpoint(method: .notificationShow, params: params)
    }

    public static func clientWindowTitleSet(_ params: HerdrRequestClientWindowTitleSetParams) -> HerdrEndpoint<HerdrRequestClientWindowTitleSetParams> {
        HerdrEndpoint(method: .clientWindowTitleSet, params: params)
    }

    public static func clientWindowTitleClear(_ params: HerdrEmptyParameters = .init()) -> HerdrEndpoint<HerdrEmptyParameters> {
        HerdrEndpoint(method: .clientWindowTitleClear, params: params)
    }

    public static func sessionSnapshot(_ params: HerdrEmptyParameters = .init()) -> HerdrEndpoint<HerdrEmptyParameters> {
        HerdrEndpoint(method: .sessionSnapshot, params: params)
    }

    public static func workspaceCreate(_ params: HerdrRequestWorkspaceCreateParams) -> HerdrEndpoint<HerdrRequestWorkspaceCreateParams> {
        HerdrEndpoint(method: .workspaceCreate, params: params)
    }

    public static func workspaceList(_ params: HerdrEmptyParameters = .init()) -> HerdrEndpoint<HerdrEmptyParameters> {
        HerdrEndpoint(method: .workspaceList, params: params)
    }

    public static func workspaceGet(_ params: HerdrRequestWorkspaceTarget) -> HerdrEndpoint<HerdrRequestWorkspaceTarget> {
        HerdrEndpoint(method: .workspaceGet, params: params)
    }

    public static func workspaceFocus(_ params: HerdrRequestWorkspaceTarget) -> HerdrEndpoint<HerdrRequestWorkspaceTarget> {
        HerdrEndpoint(method: .workspaceFocus, params: params)
    }

    public static func workspaceRename(_ params: HerdrRequestWorkspaceRenameParams) -> HerdrEndpoint<HerdrRequestWorkspaceRenameParams> {
        HerdrEndpoint(method: .workspaceRename, params: params)
    }

    public static func workspaceMove(_ params: HerdrRequestWorkspaceMoveParams) -> HerdrEndpoint<HerdrRequestWorkspaceMoveParams> {
        HerdrEndpoint(method: .workspaceMove, params: params)
    }

    public static func workspaceReportMetadata(_ params: HerdrRequestWorkspaceReportMetadataParams) -> HerdrEndpoint<HerdrRequestWorkspaceReportMetadataParams> {
        HerdrEndpoint(method: .workspaceReportMetadata, params: params)
    }

    public static func workspaceClose(_ params: HerdrRequestWorkspaceTarget) -> HerdrEndpoint<HerdrRequestWorkspaceTarget> {
        HerdrEndpoint(method: .workspaceClose, params: params)
    }

    public static func worktreeList(_ params: HerdrRequestWorktreeListParams) -> HerdrEndpoint<HerdrRequestWorktreeListParams> {
        HerdrEndpoint(method: .worktreeList, params: params)
    }

    public static func worktreeCreate(_ params: HerdrRequestWorktreeCreateParams) -> HerdrEndpoint<HerdrRequestWorktreeCreateParams> {
        HerdrEndpoint(method: .worktreeCreate, params: params)
    }

    public static func worktreeOpen(_ params: HerdrRequestWorktreeOpenParams) -> HerdrEndpoint<HerdrRequestWorktreeOpenParams> {
        HerdrEndpoint(method: .worktreeOpen, params: params)
    }

    public static func worktreeRemove(_ params: HerdrRequestWorktreeRemoveParams) -> HerdrEndpoint<HerdrRequestWorktreeRemoveParams> {
        HerdrEndpoint(method: .worktreeRemove, params: params)
    }

    public static func tabCreate(_ params: HerdrRequestTabCreateParams) -> HerdrEndpoint<HerdrRequestTabCreateParams> {
        HerdrEndpoint(method: .tabCreate, params: params)
    }

    public static func tabList(_ params: HerdrRequestTabListParams) -> HerdrEndpoint<HerdrRequestTabListParams> {
        HerdrEndpoint(method: .tabList, params: params)
    }

    public static func tabGet(_ params: HerdrRequestTabTarget) -> HerdrEndpoint<HerdrRequestTabTarget> {
        HerdrEndpoint(method: .tabGet, params: params)
    }

    public static func tabFocus(_ params: HerdrRequestTabTarget) -> HerdrEndpoint<HerdrRequestTabTarget> {
        HerdrEndpoint(method: .tabFocus, params: params)
    }

    public static func tabRename(_ params: HerdrRequestTabRenameParams) -> HerdrEndpoint<HerdrRequestTabRenameParams> {
        HerdrEndpoint(method: .tabRename, params: params)
    }

    public static func tabMove(_ params: HerdrRequestTabMoveParams) -> HerdrEndpoint<HerdrRequestTabMoveParams> {
        HerdrEndpoint(method: .tabMove, params: params)
    }

    public static func tabClose(_ params: HerdrRequestTabTarget) -> HerdrEndpoint<HerdrRequestTabTarget> {
        HerdrEndpoint(method: .tabClose, params: params)
    }

    public static func agentList(_ params: HerdrEmptyParameters = .init()) -> HerdrEndpoint<HerdrEmptyParameters> {
        HerdrEndpoint(method: .agentList, params: params)
    }

    public static func agentGet(_ params: HerdrRequestAgentTarget) -> HerdrEndpoint<HerdrRequestAgentTarget> {
        HerdrEndpoint(method: .agentGet, params: params)
    }

    public static func agentRead(_ params: HerdrRequestAgentReadParams) -> HerdrEndpoint<HerdrRequestAgentReadParams> {
        HerdrEndpoint(method: .agentRead, params: params)
    }

    public static func agentExplain(_ params: HerdrRequestAgentTarget) -> HerdrEndpoint<HerdrRequestAgentTarget> {
        HerdrEndpoint(method: .agentExplain, params: params)
    }

    public static func agentSendKeys(_ params: HerdrRequestAgentSendKeysParams) -> HerdrEndpoint<HerdrRequestAgentSendKeysParams> {
        HerdrEndpoint(method: .agentSendKeys, params: params)
    }

    public static func agentRename(_ params: HerdrRequestAgentRenameParams) -> HerdrEndpoint<HerdrRequestAgentRenameParams> {
        HerdrEndpoint(method: .agentRename, params: params)
    }

    public static func agentViewSet(_ params: HerdrRequestAgentViewSetParams) -> HerdrEndpoint<HerdrRequestAgentViewSetParams> {
        HerdrEndpoint(method: .agentViewSet, params: params)
    }

    public static func agentViewClear(_ params: HerdrRequestAgentViewClearParams) -> HerdrEndpoint<HerdrRequestAgentViewClearParams> {
        HerdrEndpoint(method: .agentViewClear, params: params)
    }

    public static func agentFocus(_ params: HerdrRequestAgentTarget) -> HerdrEndpoint<HerdrRequestAgentTarget> {
        HerdrEndpoint(method: .agentFocus, params: params)
    }

    public static func agentStart(_ params: HerdrRequestAgentStartParams) -> HerdrEndpoint<HerdrRequestAgentStartParams> {
        HerdrEndpoint(method: .agentStart, params: params)
    }

    public static func agentPrompt(_ params: HerdrRequestAgentPromptParams) -> HerdrEndpoint<HerdrRequestAgentPromptParams> {
        HerdrEndpoint(method: .agentPrompt, params: params)
    }

    public static func agentWait(_ params: HerdrRequestAgentWaitParams) -> HerdrEndpoint<HerdrRequestAgentWaitParams> {
        HerdrEndpoint(method: .agentWait, params: params)
    }

    public static func paneSplit(_ params: HerdrRequestPaneSplitParams) -> HerdrEndpoint<HerdrRequestPaneSplitParams> {
        HerdrEndpoint(method: .paneSplit, params: params)
    }

    public static func paneSwap(_ params: HerdrRequestPaneSwapParams) -> HerdrEndpoint<HerdrRequestPaneSwapParams> {
        HerdrEndpoint(method: .paneSwap, params: params)
    }

    public static func paneMove(_ params: HerdrRequestPaneMoveParams) -> HerdrEndpoint<HerdrRequestPaneMoveParams> {
        HerdrEndpoint(method: .paneMove, params: params)
    }

    public static func paneZoom(_ params: HerdrRequestPaneZoomParams) -> HerdrEndpoint<HerdrRequestPaneZoomParams> {
        HerdrEndpoint(method: .paneZoom, params: params)
    }

    public static func paneLayout(_ params: HerdrRequestPaneLayoutParams) -> HerdrEndpoint<HerdrRequestPaneLayoutParams> {
        HerdrEndpoint(method: .paneLayout, params: params)
    }

    public static func paneProcessInfo(_ params: HerdrRequestPaneProcessInfoParams) -> HerdrEndpoint<HerdrRequestPaneProcessInfoParams> {
        HerdrEndpoint(method: .paneProcessInfo, params: params)
    }

    public static func layoutExport(_ params: HerdrRequestLayoutExportParams) -> HerdrEndpoint<HerdrRequestLayoutExportParams> {
        HerdrEndpoint(method: .layoutExport, params: params)
    }

    public static func layoutApply(_ params: HerdrRequestLayoutApplyParams) -> HerdrEndpoint<HerdrRequestLayoutApplyParams> {
        HerdrEndpoint(method: .layoutApply, params: params)
    }

    public static func layoutSetSplitRatio(_ params: HerdrRequestLayoutSetSplitRatioParams) -> HerdrEndpoint<HerdrRequestLayoutSetSplitRatioParams> {
        HerdrEndpoint(method: .layoutSetSplitRatio, params: params)
    }

    public static func paneNeighbor(_ params: HerdrRequestPaneNeighborParams) -> HerdrEndpoint<HerdrRequestPaneNeighborParams> {
        HerdrEndpoint(method: .paneNeighbor, params: params)
    }

    public static func paneEdges(_ params: HerdrRequestPaneEdgesParams) -> HerdrEndpoint<HerdrRequestPaneEdgesParams> {
        HerdrEndpoint(method: .paneEdges, params: params)
    }

    public static func paneFocusDirection(_ params: HerdrRequestPaneFocusDirectionParams) -> HerdrEndpoint<HerdrRequestPaneFocusDirectionParams> {
        HerdrEndpoint(method: .paneFocusDirection, params: params)
    }

    public static func paneResize(_ params: HerdrRequestPaneResizeParams) -> HerdrEndpoint<HerdrRequestPaneResizeParams> {
        HerdrEndpoint(method: .paneResize, params: params)
    }

    public static func paneList(_ params: HerdrRequestPaneListParams) -> HerdrEndpoint<HerdrRequestPaneListParams> {
        HerdrEndpoint(method: .paneList, params: params)
    }

    public static func paneCurrent(_ params: HerdrRequestPaneCurrentParams) -> HerdrEndpoint<HerdrRequestPaneCurrentParams> {
        HerdrEndpoint(method: .paneCurrent, params: params)
    }

    public static func paneGet(_ params: HerdrRequestPaneTarget) -> HerdrEndpoint<HerdrRequestPaneTarget> {
        HerdrEndpoint(method: .paneGet, params: params)
    }

    public static func paneFocus(_ params: HerdrRequestPaneTarget) -> HerdrEndpoint<HerdrRequestPaneTarget> {
        HerdrEndpoint(method: .paneFocus, params: params)
    }

    public static func paneRename(_ params: HerdrRequestPaneRenameParams) -> HerdrEndpoint<HerdrRequestPaneRenameParams> {
        HerdrEndpoint(method: .paneRename, params: params)
    }

    public static func paneSendText(_ params: HerdrRequestPaneSendTextParams) -> HerdrEndpoint<HerdrRequestPaneSendTextParams> {
        HerdrEndpoint(method: .paneSendText, params: params)
    }

    public static func paneSendKeys(_ params: HerdrRequestPaneSendKeysParams) -> HerdrEndpoint<HerdrRequestPaneSendKeysParams> {
        HerdrEndpoint(method: .paneSendKeys, params: params)
    }

    public static func paneSendInput(_ params: HerdrRequestPaneSendInputParams) -> HerdrEndpoint<HerdrRequestPaneSendInputParams> {
        HerdrEndpoint(method: .paneSendInput, params: params)
    }

    public static func paneRead(_ params: HerdrRequestPaneReadParams) -> HerdrEndpoint<HerdrRequestPaneReadParams> {
        HerdrEndpoint(method: .paneRead, params: params)
    }

    public static func paneGraphicsSet(_ params: HerdrRequestPaneGraphicsSetParams) -> HerdrEndpoint<HerdrRequestPaneGraphicsSetParams> {
        HerdrEndpoint(method: .paneGraphicsSet, params: params)
    }

    public static func paneGraphicsClear(_ params: HerdrRequestPaneGraphicsClearParams) -> HerdrEndpoint<HerdrRequestPaneGraphicsClearParams> {
        HerdrEndpoint(method: .paneGraphicsClear, params: params)
    }

    public static func paneGraphicsInfo(_ params: HerdrRequestPaneTarget) -> HerdrEndpoint<HerdrRequestPaneTarget> {
        HerdrEndpoint(method: .paneGraphicsInfo, params: params)
    }

    public static func paneReportAgent(_ params: HerdrRequestPaneReportAgentParams) -> HerdrEndpoint<HerdrRequestPaneReportAgentParams> {
        HerdrEndpoint(method: .paneReportAgent, params: params)
    }

    public static func paneReportAgentSession(_ params: HerdrRequestPaneReportAgentSessionParams) -> HerdrEndpoint<HerdrRequestPaneReportAgentSessionParams> {
        HerdrEndpoint(method: .paneReportAgentSession, params: params)
    }

    public static func paneReportMetadata(_ params: HerdrRequestPaneReportMetadataParams) -> HerdrEndpoint<HerdrRequestPaneReportMetadataParams> {
        HerdrEndpoint(method: .paneReportMetadata, params: params)
    }

    public static func paneClearAgentAuthority(_ params: HerdrRequestPaneClearAgentAuthorityParams) -> HerdrEndpoint<HerdrRequestPaneClearAgentAuthorityParams> {
        HerdrEndpoint(method: .paneClearAgentAuthority, params: params)
    }

    public static func paneReleaseAgent(_ params: HerdrRequestPaneReleaseAgentParams) -> HerdrEndpoint<HerdrRequestPaneReleaseAgentParams> {
        HerdrEndpoint(method: .paneReleaseAgent, params: params)
    }

    public static func paneClose(_ params: HerdrRequestPaneTarget) -> HerdrEndpoint<HerdrRequestPaneTarget> {
        HerdrEndpoint(method: .paneClose, params: params)
    }

    public static func popupClose(_ params: HerdrEmptyParameters = .init()) -> HerdrEndpoint<HerdrEmptyParameters> {
        HerdrEndpoint(method: .popupClose, params: params)
    }

    public static func eventsSubscribe(_ params: HerdrRequestEventsSubscribeParams) -> HerdrEndpoint<HerdrRequestEventsSubscribeParams> {
        HerdrEndpoint(method: .eventsSubscribe, params: params)
    }

    public static func eventsWait(_ params: HerdrRequestEventsWaitParams) -> HerdrEndpoint<HerdrRequestEventsWaitParams> {
        HerdrEndpoint(method: .eventsWait, params: params)
    }

    public static func paneWaitForOutput(_ params: HerdrRequestPaneWaitForOutputParams) -> HerdrEndpoint<HerdrRequestPaneWaitForOutputParams> {
        HerdrEndpoint(method: .paneWaitForOutput, params: params)
    }

    public static func integrationInstall(_ params: HerdrRequestIntegrationInstallParams) -> HerdrEndpoint<HerdrRequestIntegrationInstallParams> {
        HerdrEndpoint(method: .integrationInstall, params: params)
    }

    public static func integrationUninstall(_ params: HerdrRequestIntegrationUninstallParams) -> HerdrEndpoint<HerdrRequestIntegrationUninstallParams> {
        HerdrEndpoint(method: .integrationUninstall, params: params)
    }

    public static func pluginLink(_ params: HerdrRequestPluginLinkParams) -> HerdrEndpoint<HerdrRequestPluginLinkParams> {
        HerdrEndpoint(method: .pluginLink, params: params)
    }

    public static func pluginList(_ params: HerdrRequestPluginListParams) -> HerdrEndpoint<HerdrRequestPluginListParams> {
        HerdrEndpoint(method: .pluginList, params: params)
    }

    public static func pluginUnlink(_ params: HerdrRequestPluginUnlinkParams) -> HerdrEndpoint<HerdrRequestPluginUnlinkParams> {
        HerdrEndpoint(method: .pluginUnlink, params: params)
    }

    public static func pluginEnable(_ params: HerdrRequestPluginSetEnabledParams) -> HerdrEndpoint<HerdrRequestPluginSetEnabledParams> {
        HerdrEndpoint(method: .pluginEnable, params: params)
    }

    public static func pluginDisable(_ params: HerdrRequestPluginSetEnabledParams) -> HerdrEndpoint<HerdrRequestPluginSetEnabledParams> {
        HerdrEndpoint(method: .pluginDisable, params: params)
    }

    public static func pluginActionList(_ params: HerdrRequestPluginActionListParams) -> HerdrEndpoint<HerdrRequestPluginActionListParams> {
        HerdrEndpoint(method: .pluginActionList, params: params)
    }

    public static func pluginActionInvoke(_ params: HerdrRequestPluginActionInvokeParams) -> HerdrEndpoint<HerdrRequestPluginActionInvokeParams> {
        HerdrEndpoint(method: .pluginActionInvoke, params: params)
    }

    public static func pluginLogList(_ params: HerdrRequestPluginLogListParams) -> HerdrEndpoint<HerdrRequestPluginLogListParams> {
        HerdrEndpoint(method: .pluginLogList, params: params)
    }

    public static func pluginPaneOpen(_ params: HerdrRequestPluginPaneOpenParams) -> HerdrEndpoint<HerdrRequestPluginPaneOpenParams> {
        HerdrEndpoint(method: .pluginPaneOpen, params: params)
    }

    public static func pluginPaneFocus(_ params: HerdrRequestPluginPaneFocusParams) -> HerdrEndpoint<HerdrRequestPluginPaneFocusParams> {
        HerdrEndpoint(method: .pluginPaneFocus, params: params)
    }

    public static func pluginPaneClose(_ params: HerdrRequestPluginPaneCloseParams) -> HerdrEndpoint<HerdrRequestPluginPaneCloseParams> {
        HerdrEndpoint(method: .pluginPaneClose, params: params)
    }
}
