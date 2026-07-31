// Generated from Herdr protocol 18, schema 1.
// Do not edit by hand; run Tools/HerdrSDKGenerator/generate.mjs.
// To parse the JSON, add this file to your project and do:
//
//   let herdrRequestTypes = try HerdrRequestTypes(json)

import Foundation

// MARK: - HerdrRequestTypes
public struct HerdrRequestTypes: Codable, Sendable {
    public let agentPromptParams: HerdrRequestAgentPromptParams
    public let agentPromptWaitOptions: HerdrRequestAgentPromptWaitOptionsClass
    public let agentReadParams: HerdrRequestAgentReadParams
    public let agentRenameParams: HerdrRequestAgentRenameParams
    public let agentSendKeysParams: HerdrRequestAgentSendKeysParams
    public let agentStartParams: HerdrRequestAgentStartParams
    public let agentStatus: HerdrRequestAgentStatusElement
    public let agentTarget: HerdrRequestAgentTarget
    public let agentViewBuiltinField: HerdrRequestAgentViewBuiltinField
    public let agentViewBuiltinSortField: HerdrRequestAgentViewBuiltinSortField
    public let agentViewClearParams: HerdrRequestAgentViewClearParams
    public let agentViewContext: HerdrRequestAgentViewContext
    public let agentViewField: HerdrRequestAgentViewField
    public let agentViewFilter: HerdrRequestAgentViewFilter
    public let agentViewSetParams: HerdrRequestAgentViewSetParams
    public let agentViewSort: HerdrRequestAgentViewSortElement
    public let agentViewSortField: HerdrRequestField
    public let agentViewSortOrder: HerdrRequestOrder
    public let agentViewValue: HerdrRequestValue
    public let agentWaitParams: HerdrRequestAgentWaitParams
    public let clientWindowTitleSetParams: HerdrRequestClientWindowTitleSetParams
    public let eventMatch: HerdrRequestEventMatch
    public let eventsSubscribeParams: HerdrRequestEventsSubscribeParams
    public let eventsWaitParams: HerdrRequestEventsWaitParams
    public let integrationInstallParams: HerdrRequestIntegrationInstallParams
    public let integrationTarget: HerdrRequestTarget
    public let integrationUninstallParams: HerdrRequestIntegrationUninstallParams
    public let layoutApplyParams: HerdrRequestLayoutApplyParams
    public let layoutExportParams: HerdrRequestLayoutExportParams
    public let layoutNode: HerdrRequestRoot
    public let layoutSetSplitRatioParams: HerdrRequestLayoutSetSplitRatioParams
    public let notificationShowParams: HerdrRequestNotificationShowParams
    public let notificationShowSound: HerdrRequestSound
    public let outputMatch: HerdrRequestMatch
    public let paneAgentState: HerdrRequestPaneAgentState
    public let paneClearAgentAuthorityParams: HerdrRequestPaneClearAgentAuthorityParams
    public let paneCurrentParams: HerdrRequestPaneCurrentParams
    public let paneDirection: HerdrRequestPaneDirection
    public let paneEdgesParams: HerdrRequestPaneEdgesParams
    public let paneFocusDirectionParams: HerdrRequestPaneFocusDirectionParams
    public let paneGraphicsClearParams: HerdrRequestPaneGraphicsClearParams
    public let paneGraphicsFormat: HerdrRequestPaneGraphicsFormat
    public let paneGraphicsPlacementParams: HerdrRequestPaneGraphicsPlacementParams
    public let paneGraphicsSetParams: HerdrRequestPaneGraphicsSetParams
    public let paneLayoutParams: HerdrRequestPaneLayoutParams
    public let paneListParams: HerdrRequestPaneListParams
    public let paneMoveDestination: HerdrRequestPaneMoveDestination
    public let paneMoveParams: HerdrRequestPaneMoveParams
    public let paneNeighborParams: HerdrRequestPaneNeighborParams
    public let paneProcessInfoParams: HerdrRequestPaneProcessInfoParams
    public let paneReadParams: HerdrRequestPaneReadParams
    public let paneReleaseAgentParams: HerdrRequestPaneReleaseAgentParams
    public let paneRenameParams: HerdrRequestPaneRenameParams
    public let paneReportAgentParams: HerdrRequestPaneReportAgentParams
    public let paneReportAgentSessionParams: HerdrRequestPaneReportAgentSessionParams
    public let paneReportMetadataParams: HerdrRequestPaneReportMetadataParams
    public let paneResizeParams: HerdrRequestPaneResizeParams
    public let paneSendInputParams: HerdrRequestPaneSendInputParams
    public let paneSendKeysParams: HerdrRequestPaneSendKeysParams
    public let paneSendTextParams: HerdrRequestPaneSendTextParams
    public let paneSplitParams: HerdrRequestPaneSplitParams
    public let paneSwapParams: HerdrRequestPaneSwapParams
    public let paneTarget: HerdrRequestPaneTarget
    public let paneWaitForOutputParams: HerdrRequestPaneWaitForOutputParams
    public let paneZoomMode: HerdrRequestPaneZoomMode
    public let paneZoomParams: HerdrRequestPaneZoomParams
    public let pluginActionInvokeParams: HerdrRequestPluginActionInvokeParams
    public let pluginActionListParams: HerdrRequestPluginActionListParams
    public let pluginInvocationContext: HerdrRequestPluginInvocationContextClass
    public let pluginLinkParams: HerdrRequestPluginLinkParams
    public let pluginListParams: HerdrRequestPluginListParams
    public let pluginLogListParams: HerdrRequestPluginLogListParams
    public let pluginPaneCloseParams: HerdrRequestPluginPaneCloseParams
    public let pluginPaneFocusParams: HerdrRequestPluginPaneFocusParams
    public let pluginPaneOpenParams: HerdrRequestPluginPaneOpenParams
    public let pluginPanePlacement: HerdrRequestPluginPanePlacementEnum
    public let pluginSetEnabledParams: HerdrRequestPluginSetEnabledParams
    public let pluginSourceInfo: HerdrRequestPluginSourceInfoClass
    public let pluginSourceKind: HerdrRequestKind
    public let pluginUnlinkParams: HerdrRequestPluginUnlinkParams
    public let popupSize: HerdrRequestPopupSizeUnion
    public let readFormat: HerdrRequestFormat
    public let readSource: HerdrRequestSource
    public let serverLiveHandoffParams: HerdrRequestServerLiveHandoffParams
    public let splitDirection: HerdrRequestDirection
    public let subscription: HerdrRequestSubscriptionElement
    public let tabCreateParams: HerdrRequestTabCreateParams
    public let tabListParams: HerdrRequestTabListParams
    public let tabMoveParams: HerdrRequestTabMoveParams
    public let tabRenameParams: HerdrRequestTabRenameParams
    public let tabTarget: HerdrRequestTabTarget
    public let toastHerdrPosition: HerdrRequestToastHerdrPositionEnum
    public let workspaceCreateParams: HerdrRequestWorkspaceCreateParams
    public let workspaceMoveBlockParams: HerdrRequestWorkspaceMoveBlockParams
    public let workspaceMoveParams: HerdrRequestWorkspaceMoveParams
    public let workspaceRenameParams: HerdrRequestWorkspaceRenameParams
    public let workspaceReportMetadataParams: HerdrRequestWorkspaceReportMetadataParams
    public let workspaceTarget: HerdrRequestWorkspaceTarget
    public let workspaceWorktreeInfo: HerdrRequestWorkspaceWorktreeInfoClass
    public let worktreeCreateParams: HerdrRequestWorktreeCreateParams
    public let worktreeListParams: HerdrRequestWorktreeListParams
    public let worktreeOpenParams: HerdrRequestWorktreeOpenParams
    public let worktreeRemoveParams: HerdrRequestWorktreeRemoveParams

    public enum CodingKeys: String, CodingKey {
        case agentPromptParams = "AgentPromptParams"
        case agentPromptWaitOptions = "AgentPromptWaitOptions"
        case agentReadParams = "AgentReadParams"
        case agentRenameParams = "AgentRenameParams"
        case agentSendKeysParams = "AgentSendKeysParams"
        case agentStartParams = "AgentStartParams"
        case agentStatus = "AgentStatus"
        case agentTarget = "AgentTarget"
        case agentViewBuiltinField = "AgentViewBuiltinField"
        case agentViewBuiltinSortField = "AgentViewBuiltinSortField"
        case agentViewClearParams = "AgentViewClearParams"
        case agentViewContext = "AgentViewContext"
        case agentViewField = "AgentViewField"
        case agentViewFilter = "AgentViewFilter"
        case agentViewSetParams = "AgentViewSetParams"
        case agentViewSort = "AgentViewSort"
        case agentViewSortField = "AgentViewSortField"
        case agentViewSortOrder = "AgentViewSortOrder"
        case agentViewValue = "AgentViewValue"
        case agentWaitParams = "AgentWaitParams"
        case clientWindowTitleSetParams = "ClientWindowTitleSetParams"
        case eventMatch = "EventMatch"
        case eventsSubscribeParams = "EventsSubscribeParams"
        case eventsWaitParams = "EventsWaitParams"
        case integrationInstallParams = "IntegrationInstallParams"
        case integrationTarget = "IntegrationTarget"
        case integrationUninstallParams = "IntegrationUninstallParams"
        case layoutApplyParams = "LayoutApplyParams"
        case layoutExportParams = "LayoutExportParams"
        case layoutNode = "LayoutNode"
        case layoutSetSplitRatioParams = "LayoutSetSplitRatioParams"
        case notificationShowParams = "NotificationShowParams"
        case notificationShowSound = "NotificationShowSound"
        case outputMatch = "OutputMatch"
        case paneAgentState = "PaneAgentState"
        case paneClearAgentAuthorityParams = "PaneClearAgentAuthorityParams"
        case paneCurrentParams = "PaneCurrentParams"
        case paneDirection = "PaneDirection"
        case paneEdgesParams = "PaneEdgesParams"
        case paneFocusDirectionParams = "PaneFocusDirectionParams"
        case paneGraphicsClearParams = "PaneGraphicsClearParams"
        case paneGraphicsFormat = "PaneGraphicsFormat"
        case paneGraphicsPlacementParams = "PaneGraphicsPlacementParams"
        case paneGraphicsSetParams = "PaneGraphicsSetParams"
        case paneLayoutParams = "PaneLayoutParams"
        case paneListParams = "PaneListParams"
        case paneMoveDestination = "PaneMoveDestination"
        case paneMoveParams = "PaneMoveParams"
        case paneNeighborParams = "PaneNeighborParams"
        case paneProcessInfoParams = "PaneProcessInfoParams"
        case paneReadParams = "PaneReadParams"
        case paneReleaseAgentParams = "PaneReleaseAgentParams"
        case paneRenameParams = "PaneRenameParams"
        case paneReportAgentParams = "PaneReportAgentParams"
        case paneReportAgentSessionParams = "PaneReportAgentSessionParams"
        case paneReportMetadataParams = "PaneReportMetadataParams"
        case paneResizeParams = "PaneResizeParams"
        case paneSendInputParams = "PaneSendInputParams"
        case paneSendKeysParams = "PaneSendKeysParams"
        case paneSendTextParams = "PaneSendTextParams"
        case paneSplitParams = "PaneSplitParams"
        case paneSwapParams = "PaneSwapParams"
        case paneTarget = "PaneTarget"
        case paneWaitForOutputParams = "PaneWaitForOutputParams"
        case paneZoomMode = "PaneZoomMode"
        case paneZoomParams = "PaneZoomParams"
        case pluginActionInvokeParams = "PluginActionInvokeParams"
        case pluginActionListParams = "PluginActionListParams"
        case pluginInvocationContext = "PluginInvocationContext"
        case pluginLinkParams = "PluginLinkParams"
        case pluginListParams = "PluginListParams"
        case pluginLogListParams = "PluginLogListParams"
        case pluginPaneCloseParams = "PluginPaneCloseParams"
        case pluginPaneFocusParams = "PluginPaneFocusParams"
        case pluginPaneOpenParams = "PluginPaneOpenParams"
        case pluginPanePlacement = "PluginPanePlacement"
        case pluginSetEnabledParams = "PluginSetEnabledParams"
        case pluginSourceInfo = "PluginSourceInfo"
        case pluginSourceKind = "PluginSourceKind"
        case pluginUnlinkParams = "PluginUnlinkParams"
        case popupSize = "PopupSize"
        case readFormat = "ReadFormat"
        case readSource = "ReadSource"
        case serverLiveHandoffParams = "ServerLiveHandoffParams"
        case splitDirection = "SplitDirection"
        case subscription = "Subscription"
        case tabCreateParams = "TabCreateParams"
        case tabListParams = "TabListParams"
        case tabMoveParams = "TabMoveParams"
        case tabRenameParams = "TabRenameParams"
        case tabTarget = "TabTarget"
        case toastHerdrPosition = "ToastHerdrPosition"
        case workspaceCreateParams = "WorkspaceCreateParams"
        case workspaceMoveBlockParams = "WorkspaceMoveBlockParams"
        case workspaceMoveParams = "WorkspaceMoveParams"
        case workspaceRenameParams = "WorkspaceRenameParams"
        case workspaceReportMetadataParams = "WorkspaceReportMetadataParams"
        case workspaceTarget = "WorkspaceTarget"
        case workspaceWorktreeInfo = "WorkspaceWorktreeInfo"
        case worktreeCreateParams = "WorktreeCreateParams"
        case worktreeListParams = "WorktreeListParams"
        case worktreeOpenParams = "WorktreeOpenParams"
        case worktreeRemoveParams = "WorktreeRemoveParams"
    }

    public init(agentPromptParams: HerdrRequestAgentPromptParams, agentPromptWaitOptions: HerdrRequestAgentPromptWaitOptionsClass, agentReadParams: HerdrRequestAgentReadParams, agentRenameParams: HerdrRequestAgentRenameParams, agentSendKeysParams: HerdrRequestAgentSendKeysParams, agentStartParams: HerdrRequestAgentStartParams, agentStatus: HerdrRequestAgentStatusElement, agentTarget: HerdrRequestAgentTarget, agentViewBuiltinField: HerdrRequestAgentViewBuiltinField, agentViewBuiltinSortField: HerdrRequestAgentViewBuiltinSortField, agentViewClearParams: HerdrRequestAgentViewClearParams, agentViewContext: HerdrRequestAgentViewContext, agentViewField: HerdrRequestAgentViewField, agentViewFilter: HerdrRequestAgentViewFilter, agentViewSetParams: HerdrRequestAgentViewSetParams, agentViewSort: HerdrRequestAgentViewSortElement, agentViewSortField: HerdrRequestField, agentViewSortOrder: HerdrRequestOrder, agentViewValue: HerdrRequestValue, agentWaitParams: HerdrRequestAgentWaitParams, clientWindowTitleSetParams: HerdrRequestClientWindowTitleSetParams, eventMatch: HerdrRequestEventMatch, eventsSubscribeParams: HerdrRequestEventsSubscribeParams, eventsWaitParams: HerdrRequestEventsWaitParams, integrationInstallParams: HerdrRequestIntegrationInstallParams, integrationTarget: HerdrRequestTarget, integrationUninstallParams: HerdrRequestIntegrationUninstallParams, layoutApplyParams: HerdrRequestLayoutApplyParams, layoutExportParams: HerdrRequestLayoutExportParams, layoutNode: HerdrRequestRoot, layoutSetSplitRatioParams: HerdrRequestLayoutSetSplitRatioParams, notificationShowParams: HerdrRequestNotificationShowParams, notificationShowSound: HerdrRequestSound, outputMatch: HerdrRequestMatch, paneAgentState: HerdrRequestPaneAgentState, paneClearAgentAuthorityParams: HerdrRequestPaneClearAgentAuthorityParams, paneCurrentParams: HerdrRequestPaneCurrentParams, paneDirection: HerdrRequestPaneDirection, paneEdgesParams: HerdrRequestPaneEdgesParams, paneFocusDirectionParams: HerdrRequestPaneFocusDirectionParams, paneGraphicsClearParams: HerdrRequestPaneGraphicsClearParams, paneGraphicsFormat: HerdrRequestPaneGraphicsFormat, paneGraphicsPlacementParams: HerdrRequestPaneGraphicsPlacementParams, paneGraphicsSetParams: HerdrRequestPaneGraphicsSetParams, paneLayoutParams: HerdrRequestPaneLayoutParams, paneListParams: HerdrRequestPaneListParams, paneMoveDestination: HerdrRequestPaneMoveDestination, paneMoveParams: HerdrRequestPaneMoveParams, paneNeighborParams: HerdrRequestPaneNeighborParams, paneProcessInfoParams: HerdrRequestPaneProcessInfoParams, paneReadParams: HerdrRequestPaneReadParams, paneReleaseAgentParams: HerdrRequestPaneReleaseAgentParams, paneRenameParams: HerdrRequestPaneRenameParams, paneReportAgentParams: HerdrRequestPaneReportAgentParams, paneReportAgentSessionParams: HerdrRequestPaneReportAgentSessionParams, paneReportMetadataParams: HerdrRequestPaneReportMetadataParams, paneResizeParams: HerdrRequestPaneResizeParams, paneSendInputParams: HerdrRequestPaneSendInputParams, paneSendKeysParams: HerdrRequestPaneSendKeysParams, paneSendTextParams: HerdrRequestPaneSendTextParams, paneSplitParams: HerdrRequestPaneSplitParams, paneSwapParams: HerdrRequestPaneSwapParams, paneTarget: HerdrRequestPaneTarget, paneWaitForOutputParams: HerdrRequestPaneWaitForOutputParams, paneZoomMode: HerdrRequestPaneZoomMode, paneZoomParams: HerdrRequestPaneZoomParams, pluginActionInvokeParams: HerdrRequestPluginActionInvokeParams, pluginActionListParams: HerdrRequestPluginActionListParams, pluginInvocationContext: HerdrRequestPluginInvocationContextClass, pluginLinkParams: HerdrRequestPluginLinkParams, pluginListParams: HerdrRequestPluginListParams, pluginLogListParams: HerdrRequestPluginLogListParams, pluginPaneCloseParams: HerdrRequestPluginPaneCloseParams, pluginPaneFocusParams: HerdrRequestPluginPaneFocusParams, pluginPaneOpenParams: HerdrRequestPluginPaneOpenParams, pluginPanePlacement: HerdrRequestPluginPanePlacementEnum, pluginSetEnabledParams: HerdrRequestPluginSetEnabledParams, pluginSourceInfo: HerdrRequestPluginSourceInfoClass, pluginSourceKind: HerdrRequestKind, pluginUnlinkParams: HerdrRequestPluginUnlinkParams, popupSize: HerdrRequestPopupSizeUnion, readFormat: HerdrRequestFormat, readSource: HerdrRequestSource, serverLiveHandoffParams: HerdrRequestServerLiveHandoffParams, splitDirection: HerdrRequestDirection, subscription: HerdrRequestSubscriptionElement, tabCreateParams: HerdrRequestTabCreateParams, tabListParams: HerdrRequestTabListParams, tabMoveParams: HerdrRequestTabMoveParams, tabRenameParams: HerdrRequestTabRenameParams, tabTarget: HerdrRequestTabTarget, toastHerdrPosition: HerdrRequestToastHerdrPositionEnum, workspaceCreateParams: HerdrRequestWorkspaceCreateParams, workspaceMoveBlockParams: HerdrRequestWorkspaceMoveBlockParams, workspaceMoveParams: HerdrRequestWorkspaceMoveParams, workspaceRenameParams: HerdrRequestWorkspaceRenameParams, workspaceReportMetadataParams: HerdrRequestWorkspaceReportMetadataParams, workspaceTarget: HerdrRequestWorkspaceTarget, workspaceWorktreeInfo: HerdrRequestWorkspaceWorktreeInfoClass, worktreeCreateParams: HerdrRequestWorktreeCreateParams, worktreeListParams: HerdrRequestWorktreeListParams, worktreeOpenParams: HerdrRequestWorktreeOpenParams, worktreeRemoveParams: HerdrRequestWorktreeRemoveParams) {
        self.agentPromptParams = agentPromptParams
        self.agentPromptWaitOptions = agentPromptWaitOptions
        self.agentReadParams = agentReadParams
        self.agentRenameParams = agentRenameParams
        self.agentSendKeysParams = agentSendKeysParams
        self.agentStartParams = agentStartParams
        self.agentStatus = agentStatus
        self.agentTarget = agentTarget
        self.agentViewBuiltinField = agentViewBuiltinField
        self.agentViewBuiltinSortField = agentViewBuiltinSortField
        self.agentViewClearParams = agentViewClearParams
        self.agentViewContext = agentViewContext
        self.agentViewField = agentViewField
        self.agentViewFilter = agentViewFilter
        self.agentViewSetParams = agentViewSetParams
        self.agentViewSort = agentViewSort
        self.agentViewSortField = agentViewSortField
        self.agentViewSortOrder = agentViewSortOrder
        self.agentViewValue = agentViewValue
        self.agentWaitParams = agentWaitParams
        self.clientWindowTitleSetParams = clientWindowTitleSetParams
        self.eventMatch = eventMatch
        self.eventsSubscribeParams = eventsSubscribeParams
        self.eventsWaitParams = eventsWaitParams
        self.integrationInstallParams = integrationInstallParams
        self.integrationTarget = integrationTarget
        self.integrationUninstallParams = integrationUninstallParams
        self.layoutApplyParams = layoutApplyParams
        self.layoutExportParams = layoutExportParams
        self.layoutNode = layoutNode
        self.layoutSetSplitRatioParams = layoutSetSplitRatioParams
        self.notificationShowParams = notificationShowParams
        self.notificationShowSound = notificationShowSound
        self.outputMatch = outputMatch
        self.paneAgentState = paneAgentState
        self.paneClearAgentAuthorityParams = paneClearAgentAuthorityParams
        self.paneCurrentParams = paneCurrentParams
        self.paneDirection = paneDirection
        self.paneEdgesParams = paneEdgesParams
        self.paneFocusDirectionParams = paneFocusDirectionParams
        self.paneGraphicsClearParams = paneGraphicsClearParams
        self.paneGraphicsFormat = paneGraphicsFormat
        self.paneGraphicsPlacementParams = paneGraphicsPlacementParams
        self.paneGraphicsSetParams = paneGraphicsSetParams
        self.paneLayoutParams = paneLayoutParams
        self.paneListParams = paneListParams
        self.paneMoveDestination = paneMoveDestination
        self.paneMoveParams = paneMoveParams
        self.paneNeighborParams = paneNeighborParams
        self.paneProcessInfoParams = paneProcessInfoParams
        self.paneReadParams = paneReadParams
        self.paneReleaseAgentParams = paneReleaseAgentParams
        self.paneRenameParams = paneRenameParams
        self.paneReportAgentParams = paneReportAgentParams
        self.paneReportAgentSessionParams = paneReportAgentSessionParams
        self.paneReportMetadataParams = paneReportMetadataParams
        self.paneResizeParams = paneResizeParams
        self.paneSendInputParams = paneSendInputParams
        self.paneSendKeysParams = paneSendKeysParams
        self.paneSendTextParams = paneSendTextParams
        self.paneSplitParams = paneSplitParams
        self.paneSwapParams = paneSwapParams
        self.paneTarget = paneTarget
        self.paneWaitForOutputParams = paneWaitForOutputParams
        self.paneZoomMode = paneZoomMode
        self.paneZoomParams = paneZoomParams
        self.pluginActionInvokeParams = pluginActionInvokeParams
        self.pluginActionListParams = pluginActionListParams
        self.pluginInvocationContext = pluginInvocationContext
        self.pluginLinkParams = pluginLinkParams
        self.pluginListParams = pluginListParams
        self.pluginLogListParams = pluginLogListParams
        self.pluginPaneCloseParams = pluginPaneCloseParams
        self.pluginPaneFocusParams = pluginPaneFocusParams
        self.pluginPaneOpenParams = pluginPaneOpenParams
        self.pluginPanePlacement = pluginPanePlacement
        self.pluginSetEnabledParams = pluginSetEnabledParams
        self.pluginSourceInfo = pluginSourceInfo
        self.pluginSourceKind = pluginSourceKind
        self.pluginUnlinkParams = pluginUnlinkParams
        self.popupSize = popupSize
        self.readFormat = readFormat
        self.readSource = readSource
        self.serverLiveHandoffParams = serverLiveHandoffParams
        self.splitDirection = splitDirection
        self.subscription = subscription
        self.tabCreateParams = tabCreateParams
        self.tabListParams = tabListParams
        self.tabMoveParams = tabMoveParams
        self.tabRenameParams = tabRenameParams
        self.tabTarget = tabTarget
        self.toastHerdrPosition = toastHerdrPosition
        self.workspaceCreateParams = workspaceCreateParams
        self.workspaceMoveBlockParams = workspaceMoveBlockParams
        self.workspaceMoveParams = workspaceMoveParams
        self.workspaceRenameParams = workspaceRenameParams
        self.workspaceReportMetadataParams = workspaceReportMetadataParams
        self.workspaceTarget = workspaceTarget
        self.workspaceWorktreeInfo = workspaceWorktreeInfo
        self.worktreeCreateParams = worktreeCreateParams
        self.worktreeListParams = worktreeListParams
        self.worktreeOpenParams = worktreeOpenParams
        self.worktreeRemoveParams = worktreeRemoveParams
    }
}

// MARK: HerdrRequestTypes convenience initializers and mutators

public extension HerdrRequestTypes {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestTypes.self, from: data)
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
        agentPromptParams: HerdrRequestAgentPromptParams? = nil,
        agentPromptWaitOptions: HerdrRequestAgentPromptWaitOptionsClass? = nil,
        agentReadParams: HerdrRequestAgentReadParams? = nil,
        agentRenameParams: HerdrRequestAgentRenameParams? = nil,
        agentSendKeysParams: HerdrRequestAgentSendKeysParams? = nil,
        agentStartParams: HerdrRequestAgentStartParams? = nil,
        agentStatus: HerdrRequestAgentStatusElement? = nil,
        agentTarget: HerdrRequestAgentTarget? = nil,
        agentViewBuiltinField: HerdrRequestAgentViewBuiltinField? = nil,
        agentViewBuiltinSortField: HerdrRequestAgentViewBuiltinSortField? = nil,
        agentViewClearParams: HerdrRequestAgentViewClearParams? = nil,
        agentViewContext: HerdrRequestAgentViewContext? = nil,
        agentViewField: HerdrRequestAgentViewField? = nil,
        agentViewFilter: HerdrRequestAgentViewFilter? = nil,
        agentViewSetParams: HerdrRequestAgentViewSetParams? = nil,
        agentViewSort: HerdrRequestAgentViewSortElement? = nil,
        agentViewSortField: HerdrRequestField? = nil,
        agentViewSortOrder: HerdrRequestOrder? = nil,
        agentViewValue: HerdrRequestValue? = nil,
        agentWaitParams: HerdrRequestAgentWaitParams? = nil,
        clientWindowTitleSetParams: HerdrRequestClientWindowTitleSetParams? = nil,
        eventMatch: HerdrRequestEventMatch? = nil,
        eventsSubscribeParams: HerdrRequestEventsSubscribeParams? = nil,
        eventsWaitParams: HerdrRequestEventsWaitParams? = nil,
        integrationInstallParams: HerdrRequestIntegrationInstallParams? = nil,
        integrationTarget: HerdrRequestTarget? = nil,
        integrationUninstallParams: HerdrRequestIntegrationUninstallParams? = nil,
        layoutApplyParams: HerdrRequestLayoutApplyParams? = nil,
        layoutExportParams: HerdrRequestLayoutExportParams? = nil,
        layoutNode: HerdrRequestRoot? = nil,
        layoutSetSplitRatioParams: HerdrRequestLayoutSetSplitRatioParams? = nil,
        notificationShowParams: HerdrRequestNotificationShowParams? = nil,
        notificationShowSound: HerdrRequestSound? = nil,
        outputMatch: HerdrRequestMatch? = nil,
        paneAgentState: HerdrRequestPaneAgentState? = nil,
        paneClearAgentAuthorityParams: HerdrRequestPaneClearAgentAuthorityParams? = nil,
        paneCurrentParams: HerdrRequestPaneCurrentParams? = nil,
        paneDirection: HerdrRequestPaneDirection? = nil,
        paneEdgesParams: HerdrRequestPaneEdgesParams? = nil,
        paneFocusDirectionParams: HerdrRequestPaneFocusDirectionParams? = nil,
        paneGraphicsClearParams: HerdrRequestPaneGraphicsClearParams? = nil,
        paneGraphicsFormat: HerdrRequestPaneGraphicsFormat? = nil,
        paneGraphicsPlacementParams: HerdrRequestPaneGraphicsPlacementParams? = nil,
        paneGraphicsSetParams: HerdrRequestPaneGraphicsSetParams? = nil,
        paneLayoutParams: HerdrRequestPaneLayoutParams? = nil,
        paneListParams: HerdrRequestPaneListParams? = nil,
        paneMoveDestination: HerdrRequestPaneMoveDestination? = nil,
        paneMoveParams: HerdrRequestPaneMoveParams? = nil,
        paneNeighborParams: HerdrRequestPaneNeighborParams? = nil,
        paneProcessInfoParams: HerdrRequestPaneProcessInfoParams? = nil,
        paneReadParams: HerdrRequestPaneReadParams? = nil,
        paneReleaseAgentParams: HerdrRequestPaneReleaseAgentParams? = nil,
        paneRenameParams: HerdrRequestPaneRenameParams? = nil,
        paneReportAgentParams: HerdrRequestPaneReportAgentParams? = nil,
        paneReportAgentSessionParams: HerdrRequestPaneReportAgentSessionParams? = nil,
        paneReportMetadataParams: HerdrRequestPaneReportMetadataParams? = nil,
        paneResizeParams: HerdrRequestPaneResizeParams? = nil,
        paneSendInputParams: HerdrRequestPaneSendInputParams? = nil,
        paneSendKeysParams: HerdrRequestPaneSendKeysParams? = nil,
        paneSendTextParams: HerdrRequestPaneSendTextParams? = nil,
        paneSplitParams: HerdrRequestPaneSplitParams? = nil,
        paneSwapParams: HerdrRequestPaneSwapParams? = nil,
        paneTarget: HerdrRequestPaneTarget? = nil,
        paneWaitForOutputParams: HerdrRequestPaneWaitForOutputParams? = nil,
        paneZoomMode: HerdrRequestPaneZoomMode? = nil,
        paneZoomParams: HerdrRequestPaneZoomParams? = nil,
        pluginActionInvokeParams: HerdrRequestPluginActionInvokeParams? = nil,
        pluginActionListParams: HerdrRequestPluginActionListParams? = nil,
        pluginInvocationContext: HerdrRequestPluginInvocationContextClass? = nil,
        pluginLinkParams: HerdrRequestPluginLinkParams? = nil,
        pluginListParams: HerdrRequestPluginListParams? = nil,
        pluginLogListParams: HerdrRequestPluginLogListParams? = nil,
        pluginPaneCloseParams: HerdrRequestPluginPaneCloseParams? = nil,
        pluginPaneFocusParams: HerdrRequestPluginPaneFocusParams? = nil,
        pluginPaneOpenParams: HerdrRequestPluginPaneOpenParams? = nil,
        pluginPanePlacement: HerdrRequestPluginPanePlacementEnum? = nil,
        pluginSetEnabledParams: HerdrRequestPluginSetEnabledParams? = nil,
        pluginSourceInfo: HerdrRequestPluginSourceInfoClass? = nil,
        pluginSourceKind: HerdrRequestKind? = nil,
        pluginUnlinkParams: HerdrRequestPluginUnlinkParams? = nil,
        popupSize: HerdrRequestPopupSizeUnion? = nil,
        readFormat: HerdrRequestFormat? = nil,
        readSource: HerdrRequestSource? = nil,
        serverLiveHandoffParams: HerdrRequestServerLiveHandoffParams? = nil,
        splitDirection: HerdrRequestDirection? = nil,
        subscription: HerdrRequestSubscriptionElement? = nil,
        tabCreateParams: HerdrRequestTabCreateParams? = nil,
        tabListParams: HerdrRequestTabListParams? = nil,
        tabMoveParams: HerdrRequestTabMoveParams? = nil,
        tabRenameParams: HerdrRequestTabRenameParams? = nil,
        tabTarget: HerdrRequestTabTarget? = nil,
        toastHerdrPosition: HerdrRequestToastHerdrPositionEnum? = nil,
        workspaceCreateParams: HerdrRequestWorkspaceCreateParams? = nil,
        workspaceMoveBlockParams: HerdrRequestWorkspaceMoveBlockParams? = nil,
        workspaceMoveParams: HerdrRequestWorkspaceMoveParams? = nil,
        workspaceRenameParams: HerdrRequestWorkspaceRenameParams? = nil,
        workspaceReportMetadataParams: HerdrRequestWorkspaceReportMetadataParams? = nil,
        workspaceTarget: HerdrRequestWorkspaceTarget? = nil,
        workspaceWorktreeInfo: HerdrRequestWorkspaceWorktreeInfoClass? = nil,
        worktreeCreateParams: HerdrRequestWorktreeCreateParams? = nil,
        worktreeListParams: HerdrRequestWorktreeListParams? = nil,
        worktreeOpenParams: HerdrRequestWorktreeOpenParams? = nil,
        worktreeRemoveParams: HerdrRequestWorktreeRemoveParams? = nil
    ) -> HerdrRequestTypes {
        return HerdrRequestTypes(
            agentPromptParams: agentPromptParams ?? self.agentPromptParams,
            agentPromptWaitOptions: agentPromptWaitOptions ?? self.agentPromptWaitOptions,
            agentReadParams: agentReadParams ?? self.agentReadParams,
            agentRenameParams: agentRenameParams ?? self.agentRenameParams,
            agentSendKeysParams: agentSendKeysParams ?? self.agentSendKeysParams,
            agentStartParams: agentStartParams ?? self.agentStartParams,
            agentStatus: agentStatus ?? self.agentStatus,
            agentTarget: agentTarget ?? self.agentTarget,
            agentViewBuiltinField: agentViewBuiltinField ?? self.agentViewBuiltinField,
            agentViewBuiltinSortField: agentViewBuiltinSortField ?? self.agentViewBuiltinSortField,
            agentViewClearParams: agentViewClearParams ?? self.agentViewClearParams,
            agentViewContext: agentViewContext ?? self.agentViewContext,
            agentViewField: agentViewField ?? self.agentViewField,
            agentViewFilter: agentViewFilter ?? self.agentViewFilter,
            agentViewSetParams: agentViewSetParams ?? self.agentViewSetParams,
            agentViewSort: agentViewSort ?? self.agentViewSort,
            agentViewSortField: agentViewSortField ?? self.agentViewSortField,
            agentViewSortOrder: agentViewSortOrder ?? self.agentViewSortOrder,
            agentViewValue: agentViewValue ?? self.agentViewValue,
            agentWaitParams: agentWaitParams ?? self.agentWaitParams,
            clientWindowTitleSetParams: clientWindowTitleSetParams ?? self.clientWindowTitleSetParams,
            eventMatch: eventMatch ?? self.eventMatch,
            eventsSubscribeParams: eventsSubscribeParams ?? self.eventsSubscribeParams,
            eventsWaitParams: eventsWaitParams ?? self.eventsWaitParams,
            integrationInstallParams: integrationInstallParams ?? self.integrationInstallParams,
            integrationTarget: integrationTarget ?? self.integrationTarget,
            integrationUninstallParams: integrationUninstallParams ?? self.integrationUninstallParams,
            layoutApplyParams: layoutApplyParams ?? self.layoutApplyParams,
            layoutExportParams: layoutExportParams ?? self.layoutExportParams,
            layoutNode: layoutNode ?? self.layoutNode,
            layoutSetSplitRatioParams: layoutSetSplitRatioParams ?? self.layoutSetSplitRatioParams,
            notificationShowParams: notificationShowParams ?? self.notificationShowParams,
            notificationShowSound: notificationShowSound ?? self.notificationShowSound,
            outputMatch: outputMatch ?? self.outputMatch,
            paneAgentState: paneAgentState ?? self.paneAgentState,
            paneClearAgentAuthorityParams: paneClearAgentAuthorityParams ?? self.paneClearAgentAuthorityParams,
            paneCurrentParams: paneCurrentParams ?? self.paneCurrentParams,
            paneDirection: paneDirection ?? self.paneDirection,
            paneEdgesParams: paneEdgesParams ?? self.paneEdgesParams,
            paneFocusDirectionParams: paneFocusDirectionParams ?? self.paneFocusDirectionParams,
            paneGraphicsClearParams: paneGraphicsClearParams ?? self.paneGraphicsClearParams,
            paneGraphicsFormat: paneGraphicsFormat ?? self.paneGraphicsFormat,
            paneGraphicsPlacementParams: paneGraphicsPlacementParams ?? self.paneGraphicsPlacementParams,
            paneGraphicsSetParams: paneGraphicsSetParams ?? self.paneGraphicsSetParams,
            paneLayoutParams: paneLayoutParams ?? self.paneLayoutParams,
            paneListParams: paneListParams ?? self.paneListParams,
            paneMoveDestination: paneMoveDestination ?? self.paneMoveDestination,
            paneMoveParams: paneMoveParams ?? self.paneMoveParams,
            paneNeighborParams: paneNeighborParams ?? self.paneNeighborParams,
            paneProcessInfoParams: paneProcessInfoParams ?? self.paneProcessInfoParams,
            paneReadParams: paneReadParams ?? self.paneReadParams,
            paneReleaseAgentParams: paneReleaseAgentParams ?? self.paneReleaseAgentParams,
            paneRenameParams: paneRenameParams ?? self.paneRenameParams,
            paneReportAgentParams: paneReportAgentParams ?? self.paneReportAgentParams,
            paneReportAgentSessionParams: paneReportAgentSessionParams ?? self.paneReportAgentSessionParams,
            paneReportMetadataParams: paneReportMetadataParams ?? self.paneReportMetadataParams,
            paneResizeParams: paneResizeParams ?? self.paneResizeParams,
            paneSendInputParams: paneSendInputParams ?? self.paneSendInputParams,
            paneSendKeysParams: paneSendKeysParams ?? self.paneSendKeysParams,
            paneSendTextParams: paneSendTextParams ?? self.paneSendTextParams,
            paneSplitParams: paneSplitParams ?? self.paneSplitParams,
            paneSwapParams: paneSwapParams ?? self.paneSwapParams,
            paneTarget: paneTarget ?? self.paneTarget,
            paneWaitForOutputParams: paneWaitForOutputParams ?? self.paneWaitForOutputParams,
            paneZoomMode: paneZoomMode ?? self.paneZoomMode,
            paneZoomParams: paneZoomParams ?? self.paneZoomParams,
            pluginActionInvokeParams: pluginActionInvokeParams ?? self.pluginActionInvokeParams,
            pluginActionListParams: pluginActionListParams ?? self.pluginActionListParams,
            pluginInvocationContext: pluginInvocationContext ?? self.pluginInvocationContext,
            pluginLinkParams: pluginLinkParams ?? self.pluginLinkParams,
            pluginListParams: pluginListParams ?? self.pluginListParams,
            pluginLogListParams: pluginLogListParams ?? self.pluginLogListParams,
            pluginPaneCloseParams: pluginPaneCloseParams ?? self.pluginPaneCloseParams,
            pluginPaneFocusParams: pluginPaneFocusParams ?? self.pluginPaneFocusParams,
            pluginPaneOpenParams: pluginPaneOpenParams ?? self.pluginPaneOpenParams,
            pluginPanePlacement: pluginPanePlacement ?? self.pluginPanePlacement,
            pluginSetEnabledParams: pluginSetEnabledParams ?? self.pluginSetEnabledParams,
            pluginSourceInfo: pluginSourceInfo ?? self.pluginSourceInfo,
            pluginSourceKind: pluginSourceKind ?? self.pluginSourceKind,
            pluginUnlinkParams: pluginUnlinkParams ?? self.pluginUnlinkParams,
            popupSize: popupSize ?? self.popupSize,
            readFormat: readFormat ?? self.readFormat,
            readSource: readSource ?? self.readSource,
            serverLiveHandoffParams: serverLiveHandoffParams ?? self.serverLiveHandoffParams,
            splitDirection: splitDirection ?? self.splitDirection,
            subscription: subscription ?? self.subscription,
            tabCreateParams: tabCreateParams ?? self.tabCreateParams,
            tabListParams: tabListParams ?? self.tabListParams,
            tabMoveParams: tabMoveParams ?? self.tabMoveParams,
            tabRenameParams: tabRenameParams ?? self.tabRenameParams,
            tabTarget: tabTarget ?? self.tabTarget,
            toastHerdrPosition: toastHerdrPosition ?? self.toastHerdrPosition,
            workspaceCreateParams: workspaceCreateParams ?? self.workspaceCreateParams,
            workspaceMoveBlockParams: workspaceMoveBlockParams ?? self.workspaceMoveBlockParams,
            workspaceMoveParams: workspaceMoveParams ?? self.workspaceMoveParams,
            workspaceRenameParams: workspaceRenameParams ?? self.workspaceRenameParams,
            workspaceReportMetadataParams: workspaceReportMetadataParams ?? self.workspaceReportMetadataParams,
            workspaceTarget: workspaceTarget ?? self.workspaceTarget,
            workspaceWorktreeInfo: workspaceWorktreeInfo ?? self.workspaceWorktreeInfo,
            worktreeCreateParams: worktreeCreateParams ?? self.worktreeCreateParams,
            worktreeListParams: worktreeListParams ?? self.worktreeListParams,
            worktreeOpenParams: worktreeOpenParams ?? self.worktreeOpenParams,
            worktreeRemoveParams: worktreeRemoveParams ?? self.worktreeRemoveParams
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestAgentPromptParams
public struct HerdrRequestAgentPromptParams: Codable, Sendable {
    public let target: String
    public let text: String
    public let wait: HerdrRequestAgentPromptWaitOptionsClass?

    public enum CodingKeys: String, CodingKey {
        case target = "target"
        case text = "text"
        case wait = "wait"
    }

    public init(target: String, text: String, wait: HerdrRequestAgentPromptWaitOptionsClass?) {
        self.target = target
        self.text = text
        self.wait = wait
    }
}

// MARK: HerdrRequestAgentPromptParams convenience initializers and mutators

public extension HerdrRequestAgentPromptParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestAgentPromptParams.self, from: data)
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
        target: String? = nil,
        text: String? = nil,
        wait: HerdrRequestAgentPromptWaitOptionsClass?? = nil
    ) -> HerdrRequestAgentPromptParams {
        return HerdrRequestAgentPromptParams(
            target: target ?? self.target,
            text: text ?? self.text,
            wait: wait ?? self.wait
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestAgentPromptWaitOptionsClass
public struct HerdrRequestAgentPromptWaitOptionsClass: Codable, Sendable {
    public let timeoutMS: Int?
    public let until: [HerdrRequestAgentStatusElement]?

    public enum CodingKeys: String, CodingKey {
        case timeoutMS = "timeout_ms"
        case until = "until"
    }

    public init(timeoutMS: Int?, until: [HerdrRequestAgentStatusElement]?) {
        self.timeoutMS = timeoutMS
        self.until = until
    }
}

// MARK: HerdrRequestAgentPromptWaitOptionsClass convenience initializers and mutators

public extension HerdrRequestAgentPromptWaitOptionsClass {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestAgentPromptWaitOptionsClass.self, from: data)
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
        timeoutMS: Int?? = nil,
        until: [HerdrRequestAgentStatusElement]?? = nil
    ) -> HerdrRequestAgentPromptWaitOptionsClass {
        return HerdrRequestAgentPromptWaitOptionsClass(
            timeoutMS: timeoutMS ?? self.timeoutMS,
            until: until ?? self.until
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestAgentStatusElement: String, Codable, Sendable {
    case blocked = "blocked"
    case done = "done"
    case idle = "idle"
    case unknown = "unknown"
    case working = "working"
}

// MARK: - HerdrRequestAgentReadParams
public struct HerdrRequestAgentReadParams: Codable, Sendable {
    public let format: HerdrRequestFormat?
    public let lines: Int?
    public let source: HerdrRequestSource
    public let stripANSI: Bool?
    public let target: String

    public enum CodingKeys: String, CodingKey {
        case format = "format"
        case lines = "lines"
        case source = "source"
        case stripANSI = "strip_ansi"
        case target = "target"
    }

    public init(format: HerdrRequestFormat?, lines: Int?, source: HerdrRequestSource, stripANSI: Bool?, target: String) {
        self.format = format
        self.lines = lines
        self.source = source
        self.stripANSI = stripANSI
        self.target = target
    }
}

// MARK: HerdrRequestAgentReadParams convenience initializers and mutators

public extension HerdrRequestAgentReadParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestAgentReadParams.self, from: data)
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
        format: HerdrRequestFormat?? = nil,
        lines: Int?? = nil,
        source: HerdrRequestSource? = nil,
        stripANSI: Bool?? = nil,
        target: String? = nil
    ) -> HerdrRequestAgentReadParams {
        return HerdrRequestAgentReadParams(
            format: format ?? self.format,
            lines: lines ?? self.lines,
            source: source ?? self.source,
            stripANSI: stripANSI ?? self.stripANSI,
            target: target ?? self.target
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestFormat: String, Codable, Sendable {
    case ansi = "ansi"
    case text = "text"
}

public enum HerdrRequestSource: String, Codable, Sendable {
    case detection = "detection"
    case recent = "recent"
    case recentUnwrapped = "recent_unwrapped"
    case visible = "visible"
}

// MARK: - HerdrRequestAgentRenameParams
public struct HerdrRequestAgentRenameParams: Codable, Sendable {
    public let name: String?
    public let target: String

    public enum CodingKeys: String, CodingKey {
        case name = "name"
        case target = "target"
    }

    public init(name: String?, target: String) {
        self.name = name
        self.target = target
    }
}

// MARK: HerdrRequestAgentRenameParams convenience initializers and mutators

public extension HerdrRequestAgentRenameParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestAgentRenameParams.self, from: data)
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
        name: String?? = nil,
        target: String? = nil
    ) -> HerdrRequestAgentRenameParams {
        return HerdrRequestAgentRenameParams(
            name: name ?? self.name,
            target: target ?? self.target
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestAgentSendKeysParams
public struct HerdrRequestAgentSendKeysParams: Codable, Sendable {
    public let keys: [String]
    public let target: String

    public enum CodingKeys: String, CodingKey {
        case keys = "keys"
        case target = "target"
    }

    public init(keys: [String], target: String) {
        self.keys = keys
        self.target = target
    }
}

// MARK: HerdrRequestAgentSendKeysParams convenience initializers and mutators

public extension HerdrRequestAgentSendKeysParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestAgentSendKeysParams.self, from: data)
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
        keys: [String]? = nil,
        target: String? = nil
    ) -> HerdrRequestAgentSendKeysParams {
        return HerdrRequestAgentSendKeysParams(
            keys: keys ?? self.keys,
            target: target ?? self.target
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestAgentStartParams
public struct HerdrRequestAgentStartParams: Codable, Sendable {
    public let args: [String]?
    public let kind: String
    public let name: String
    public let paneID: PaneID
    /// Startup timeout in milliseconds. Values must be greater than 3000 and at most 300000.
    public let timeoutMS: Int?

    public enum CodingKeys: String, CodingKey {
        case args = "args"
        case kind = "kind"
        case name = "name"
        case paneID = "pane_id"
        case timeoutMS = "timeout_ms"
    }

    public init(args: [String]?, kind: String, name: String, paneID: PaneID, timeoutMS: Int?) {
        self.args = args
        self.kind = kind
        self.name = name
        self.paneID = paneID
        self.timeoutMS = timeoutMS
    }
}

// MARK: HerdrRequestAgentStartParams convenience initializers and mutators

public extension HerdrRequestAgentStartParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestAgentStartParams.self, from: data)
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
        args: [String]?? = nil,
        kind: String? = nil,
        name: String? = nil,
        paneID: PaneID? = nil,
        timeoutMS: Int?? = nil
    ) -> HerdrRequestAgentStartParams {
        return HerdrRequestAgentStartParams(
            args: args ?? self.args,
            kind: kind ?? self.kind,
            name: name ?? self.name,
            paneID: paneID ?? self.paneID,
            timeoutMS: timeoutMS ?? self.timeoutMS
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestAgentTarget
public struct HerdrRequestAgentTarget: Codable, Sendable {
    public let target: String

    public enum CodingKeys: String, CodingKey {
        case target = "target"
    }

    public init(target: String) {
        self.target = target
    }
}

// MARK: HerdrRequestAgentTarget convenience initializers and mutators

public extension HerdrRequestAgentTarget {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestAgentTarget.self, from: data)
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
        target: String? = nil
    ) -> HerdrRequestAgentTarget {
        return HerdrRequestAgentTarget(
            target: target ?? self.target
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestAgentViewBuiltinField: String, Codable, Sendable {
    case agent = "agent"
    case paneID = "pane_id"
    case seen = "seen"
    case stateChangeSeq = "state_change_seq"
    case status = "status"
    case tabID = "tab_id"
    case workspaceID = "workspace_id"
}

public enum HerdrRequestAgentViewBuiltinSortField: String, Codable, Sendable {
    case agent = "agent"
    case attention = "attention"
    case paneOrder = "pane_order"
    case seen = "seen"
    case stateChangeSeq = "state_change_seq"
    case status = "status"
    case tabOrder = "tab_order"
    case workspaceOrder = "workspace_order"
}

// MARK: - HerdrRequestAgentViewClearParams
public struct HerdrRequestAgentViewClearParams: Codable, Sendable {
    public let source: String?

    public enum CodingKeys: String, CodingKey {
        case source = "source"
    }

    public init(source: String?) {
        self.source = source
    }
}

// MARK: HerdrRequestAgentViewClearParams convenience initializers and mutators

public extension HerdrRequestAgentViewClearParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestAgentViewClearParams.self, from: data)
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
        source: String?? = nil
    ) -> HerdrRequestAgentViewClearParams {
        return HerdrRequestAgentViewClearParams(
            source: source ?? self.source
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestAgentViewContext: String, Codable, Sendable {
    case currentTabID = "current_tab_id"
    case currentWorkspaceID = "current_workspace_id"
}

public enum HerdrRequestAgentViewField: Codable, Sendable {
    case enumeration(HerdrRequestAgentViewBuiltinField)
    case herdrRequestAgentViewFieldClass(HerdrRequestAgentViewFieldClass)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(HerdrRequestAgentViewBuiltinField.self) {
            self = .enumeration(x)
            return
        }
        if let x = try? container.decode(HerdrRequestAgentViewFieldClass.self) {
            self = .herdrRequestAgentViewFieldClass(x)
            return
        }
        throw DecodingError.typeMismatch(HerdrRequestAgentViewField.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for HerdrRequestAgentViewField"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .enumeration(let x):
            try container.encode(x)
        case .herdrRequestAgentViewFieldClass(let x):
            try container.encode(x)
        }
    }
}

// MARK: - HerdrRequestAgentViewFieldClass
public struct HerdrRequestAgentViewFieldClass: Codable, Sendable {
    public let token: String

    public enum CodingKeys: String, CodingKey {
        case token = "token"
    }

    public init(token: String) {
        self.token = token
    }
}

// MARK: HerdrRequestAgentViewFieldClass convenience initializers and mutators

public extension HerdrRequestAgentViewFieldClass {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestAgentViewFieldClass.self, from: data)
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
        token: String? = nil
    ) -> HerdrRequestAgentViewFieldClass {
        return HerdrRequestAgentViewFieldClass(
            token: token ?? self.token
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestAgentViewFilter
public final class HerdrRequestAgentViewFilter: Codable, Sendable {
    public let filters: [HerdrRequestAgentViewFilter]?
    public let op: HerdrRequestOp
    public let filter: HerdrRequestAgentViewFilter?
    public let field: HerdrRequestAgentViewField?
    public let value: HerdrRequestValue?
    public let values: [HerdrRequestValue]?

    public enum CodingKeys: String, CodingKey {
        case filters = "filters"
        case op = "op"
        case filter = "filter"
        case field = "field"
        case value = "value"
        case values = "values"
    }

    public init(filters: [HerdrRequestAgentViewFilter]?, op: HerdrRequestOp, filter: HerdrRequestAgentViewFilter?, field: HerdrRequestAgentViewField?, value: HerdrRequestValue?, values: [HerdrRequestValue]?) {
        self.filters = filters
        self.op = op
        self.filter = filter
        self.field = field
        self.value = value
        self.values = values
    }
}

// MARK: HerdrRequestAgentViewFilter convenience initializers and mutators

public extension HerdrRequestAgentViewFilter {
    convenience init(data: Data) throws {
        let me = try newHerdrRequestJSONDecoder().decode(HerdrRequestAgentViewFilter.self, from: data)
        self.init(filters: me.filters, op: me.op, filter: me.filter, field: me.field, value: me.value, values: me.values)
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
        filters: [HerdrRequestAgentViewFilter]?? = nil,
        op: HerdrRequestOp? = nil,
        filter: HerdrRequestAgentViewFilter?? = nil,
        field: HerdrRequestAgentViewField?? = nil,
        value: HerdrRequestValue?? = nil,
        values: [HerdrRequestValue]?? = nil
    ) -> HerdrRequestAgentViewFilter {
        return HerdrRequestAgentViewFilter(
            filters: filters ?? self.filters,
            op: op ?? self.op,
            filter: filter ?? self.filter,
            field: field ?? self.field,
            value: value ?? self.value,
            values: values ?? self.values
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestOp: String, Codable, Sendable {
    case all = "all"
    case any = "any"
    case eq = "eq"
    case exists = "exists"
    case not = "not"
    case opIn = "in"
}

public enum HerdrRequestValue: Codable, Sendable {
    case bool(Bool)
    case herdrRequestAgentViewValueClass(HerdrRequestAgentViewValueClass)
    case integer(Int)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(HerdrRequestAgentViewValueClass.self) {
            self = .herdrRequestAgentViewValueClass(x)
            return
        }
        throw DecodingError.typeMismatch(HerdrRequestValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for HerdrRequestValue"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .herdrRequestAgentViewValueClass(let x):
            try container.encode(x)
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - HerdrRequestAgentViewValueClass
public struct HerdrRequestAgentViewValueClass: Codable, Sendable {
    public let context: HerdrRequestAgentViewContext

    public enum CodingKeys: String, CodingKey {
        case context = "context"
    }

    public init(context: HerdrRequestAgentViewContext) {
        self.context = context
    }
}

// MARK: HerdrRequestAgentViewValueClass convenience initializers and mutators

public extension HerdrRequestAgentViewValueClass {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestAgentViewValueClass.self, from: data)
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
        context: HerdrRequestAgentViewContext? = nil
    ) -> HerdrRequestAgentViewValueClass {
        return HerdrRequestAgentViewValueClass(
            context: context ?? self.context
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestAgentViewSetParams
public struct HerdrRequestAgentViewSetParams: Codable, Sendable {
    public let filter: HerdrRequestFilterClass?
    public let label: String?
    public let sort: [HerdrRequestAgentViewSortElement]?
    public let source: String

    public enum CodingKeys: String, CodingKey {
        case filter = "filter"
        case label = "label"
        case sort = "sort"
        case source = "source"
    }

    public init(filter: HerdrRequestFilterClass?, label: String?, sort: [HerdrRequestAgentViewSortElement]?, source: String) {
        self.filter = filter
        self.label = label
        self.sort = sort
        self.source = source
    }
}

// MARK: HerdrRequestAgentViewSetParams convenience initializers and mutators

public extension HerdrRequestAgentViewSetParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestAgentViewSetParams.self, from: data)
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
        filter: HerdrRequestFilterClass?? = nil,
        label: String?? = nil,
        sort: [HerdrRequestAgentViewSortElement]?? = nil,
        source: String? = nil
    ) -> HerdrRequestAgentViewSetParams {
        return HerdrRequestAgentViewSetParams(
            filter: filter ?? self.filter,
            label: label ?? self.label,
            sort: sort ?? self.sort,
            source: source ?? self.source
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestFilterClass
public struct HerdrRequestFilterClass: Codable, Sendable {
    public let filters: [HerdrRequestAgentViewFilter]?
    public let op: HerdrRequestOp
    public let filter: HerdrRequestAgentViewFilter?
    public let field: HerdrRequestAgentViewField?
    public let value: HerdrRequestValue?
    public let values: [HerdrRequestValue]?

    public enum CodingKeys: String, CodingKey {
        case filters = "filters"
        case op = "op"
        case filter = "filter"
        case field = "field"
        case value = "value"
        case values = "values"
    }

    public init(filters: [HerdrRequestAgentViewFilter]?, op: HerdrRequestOp, filter: HerdrRequestAgentViewFilter?, field: HerdrRequestAgentViewField?, value: HerdrRequestValue?, values: [HerdrRequestValue]?) {
        self.filters = filters
        self.op = op
        self.filter = filter
        self.field = field
        self.value = value
        self.values = values
    }
}

// MARK: HerdrRequestFilterClass convenience initializers and mutators

public extension HerdrRequestFilterClass {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestFilterClass.self, from: data)
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
        filters: [HerdrRequestAgentViewFilter]?? = nil,
        op: HerdrRequestOp? = nil,
        filter: HerdrRequestAgentViewFilter?? = nil,
        field: HerdrRequestAgentViewField?? = nil,
        value: HerdrRequestValue?? = nil,
        values: [HerdrRequestValue]?? = nil
    ) -> HerdrRequestFilterClass {
        return HerdrRequestFilterClass(
            filters: filters ?? self.filters,
            op: op ?? self.op,
            filter: filter ?? self.filter,
            field: field ?? self.field,
            value: value ?? self.value,
            values: values ?? self.values
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestAgentViewSortElement
public struct HerdrRequestAgentViewSortElement: Codable, Sendable {
    public let field: HerdrRequestField
    public let order: HerdrRequestOrder?

    public enum CodingKeys: String, CodingKey {
        case field = "field"
        case order = "order"
    }

    public init(field: HerdrRequestField, order: HerdrRequestOrder?) {
        self.field = field
        self.order = order
    }
}

// MARK: HerdrRequestAgentViewSortElement convenience initializers and mutators

public extension HerdrRequestAgentViewSortElement {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestAgentViewSortElement.self, from: data)
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
        field: HerdrRequestField? = nil,
        order: HerdrRequestOrder?? = nil
    ) -> HerdrRequestAgentViewSortElement {
        return HerdrRequestAgentViewSortElement(
            field: field ?? self.field,
            order: order ?? self.order
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestField: Codable, Sendable {
    case enumeration(HerdrRequestAgentViewBuiltinSortField)
    case herdrRequestAgentViewSortFieldClass(HerdrRequestAgentViewSortFieldClass)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(HerdrRequestAgentViewBuiltinSortField.self) {
            self = .enumeration(x)
            return
        }
        if let x = try? container.decode(HerdrRequestAgentViewSortFieldClass.self) {
            self = .herdrRequestAgentViewSortFieldClass(x)
            return
        }
        throw DecodingError.typeMismatch(HerdrRequestField.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for HerdrRequestField"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .enumeration(let x):
            try container.encode(x)
        case .herdrRequestAgentViewSortFieldClass(let x):
            try container.encode(x)
        }
    }
}

// MARK: - HerdrRequestAgentViewSortFieldClass
public struct HerdrRequestAgentViewSortFieldClass: Codable, Sendable {
    public let token: String

    public enum CodingKeys: String, CodingKey {
        case token = "token"
    }

    public init(token: String) {
        self.token = token
    }
}

// MARK: HerdrRequestAgentViewSortFieldClass convenience initializers and mutators

public extension HerdrRequestAgentViewSortFieldClass {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestAgentViewSortFieldClass.self, from: data)
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
        token: String? = nil
    ) -> HerdrRequestAgentViewSortFieldClass {
        return HerdrRequestAgentViewSortFieldClass(
            token: token ?? self.token
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestOrder: String, Codable, Sendable {
    case asc = "asc"
    case desc = "desc"
}

// MARK: - HerdrRequestAgentWaitParams
public struct HerdrRequestAgentWaitParams: Codable, Sendable {
    public let target: String
    public let timeoutMS: Int?
    public let until: [HerdrRequestAgentStatusElement]?

    public enum CodingKeys: String, CodingKey {
        case target = "target"
        case timeoutMS = "timeout_ms"
        case until = "until"
    }

    public init(target: String, timeoutMS: Int?, until: [HerdrRequestAgentStatusElement]?) {
        self.target = target
        self.timeoutMS = timeoutMS
        self.until = until
    }
}

// MARK: HerdrRequestAgentWaitParams convenience initializers and mutators

public extension HerdrRequestAgentWaitParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestAgentWaitParams.self, from: data)
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
        target: String? = nil,
        timeoutMS: Int?? = nil,
        until: [HerdrRequestAgentStatusElement]?? = nil
    ) -> HerdrRequestAgentWaitParams {
        return HerdrRequestAgentWaitParams(
            target: target ?? self.target,
            timeoutMS: timeoutMS ?? self.timeoutMS,
            until: until ?? self.until
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestClientWindowTitleSetParams
public struct HerdrRequestClientWindowTitleSetParams: Codable, Sendable {
    public let title: String

    public enum CodingKeys: String, CodingKey {
        case title = "title"
    }

    public init(title: String) {
        self.title = title
    }
}

// MARK: HerdrRequestClientWindowTitleSetParams convenience initializers and mutators

public extension HerdrRequestClientWindowTitleSetParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestClientWindowTitleSetParams.self, from: data)
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
        title: String? = nil
    ) -> HerdrRequestClientWindowTitleSetParams {
        return HerdrRequestClientWindowTitleSetParams(
            title: title ?? self.title
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestEventMatch
public struct HerdrRequestEventMatch: Codable, Sendable {
    public let event: HerdrRequestEvent
    public let workspaceID: WorkspaceID?
    public let label: String?
    public let tabID: TabID?
    public let paneID: PaneID?
    public let minRevision: Int?
    public let agent: String?
    public let agentStatus: HerdrRequestAgentStatusElement?

    public enum CodingKeys: String, CodingKey {
        case event = "event"
        case workspaceID = "workspace_id"
        case label = "label"
        case tabID = "tab_id"
        case paneID = "pane_id"
        case minRevision = "min_revision"
        case agent = "agent"
        case agentStatus = "agent_status"
    }

    public init(event: HerdrRequestEvent, workspaceID: WorkspaceID?, label: String?, tabID: TabID?, paneID: PaneID?, minRevision: Int?, agent: String?, agentStatus: HerdrRequestAgentStatusElement?) {
        self.event = event
        self.workspaceID = workspaceID
        self.label = label
        self.tabID = tabID
        self.paneID = paneID
        self.minRevision = minRevision
        self.agent = agent
        self.agentStatus = agentStatus
    }
}

// MARK: HerdrRequestEventMatch convenience initializers and mutators

public extension HerdrRequestEventMatch {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestEventMatch.self, from: data)
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
        event: HerdrRequestEvent? = nil,
        workspaceID: WorkspaceID?? = nil,
        label: String?? = nil,
        tabID: TabID?? = nil,
        paneID: PaneID?? = nil,
        minRevision: Int?? = nil,
        agent: String?? = nil,
        agentStatus: HerdrRequestAgentStatusElement?? = nil
    ) -> HerdrRequestEventMatch {
        return HerdrRequestEventMatch(
            event: event ?? self.event,
            workspaceID: workspaceID ?? self.workspaceID,
            label: label ?? self.label,
            tabID: tabID ?? self.tabID,
            paneID: paneID ?? self.paneID,
            minRevision: minRevision ?? self.minRevision,
            agent: agent ?? self.agent,
            agentStatus: agentStatus ?? self.agentStatus
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestEvent: String, Codable, Sendable {
    case paneAgentDetected = "pane_agent_detected"
    case paneAgentStatusChanged = "pane_agent_status_changed"
    case paneClosed = "pane_closed"
    case paneCreated = "pane_created"
    case paneExited = "pane_exited"
    case paneFocused = "pane_focused"
    case paneMoved = "pane_moved"
    case paneOutputChanged = "pane_output_changed"
    case tabClosed = "tab_closed"
    case tabCreated = "tab_created"
    case tabFocused = "tab_focused"
    case tabMoved = "tab_moved"
    case tabRenamed = "tab_renamed"
    case workspaceClosed = "workspace_closed"
    case workspaceCreated = "workspace_created"
    case workspaceFocused = "workspace_focused"
    case workspaceMoved = "workspace_moved"
    case workspaceRenamed = "workspace_renamed"
    case workspaceUpdated = "workspace_updated"
}

// MARK: - HerdrRequestEventsSubscribeParams
public struct HerdrRequestEventsSubscribeParams: Codable, Sendable {
    public let subscriptions: [HerdrRequestSubscriptionElement]

    public enum CodingKeys: String, CodingKey {
        case subscriptions = "subscriptions"
    }

    public init(subscriptions: [HerdrRequestSubscriptionElement]) {
        self.subscriptions = subscriptions
    }
}

// MARK: HerdrRequestEventsSubscribeParams convenience initializers and mutators

public extension HerdrRequestEventsSubscribeParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestEventsSubscribeParams.self, from: data)
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
        subscriptions: [HerdrRequestSubscriptionElement]? = nil
    ) -> HerdrRequestEventsSubscribeParams {
        return HerdrRequestEventsSubscribeParams(
            subscriptions: subscriptions ?? self.subscriptions
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestSubscriptionElement
public struct HerdrRequestSubscriptionElement: Codable, Sendable {
    public let type: HerdrRequestSubscriptionType
    public let lines: Int?
    public let match: HerdrRequestMatch?
    public let paneID: PaneID?
    public let source: HerdrRequestSource?
    public let stripANSI: Bool?
    public let agentStatus: HerdrRequestAgentStatusElement?

    public enum CodingKeys: String, CodingKey {
        case type = "type"
        case lines = "lines"
        case match = "match"
        case paneID = "pane_id"
        case source = "source"
        case stripANSI = "strip_ansi"
        case agentStatus = "agent_status"
    }

    public init(type: HerdrRequestSubscriptionType, lines: Int?, match: HerdrRequestMatch?, paneID: PaneID?, source: HerdrRequestSource?, stripANSI: Bool?, agentStatus: HerdrRequestAgentStatusElement?) {
        self.type = type
        self.lines = lines
        self.match = match
        self.paneID = paneID
        self.source = source
        self.stripANSI = stripANSI
        self.agentStatus = agentStatus
    }
}

// MARK: HerdrRequestSubscriptionElement convenience initializers and mutators

public extension HerdrRequestSubscriptionElement {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestSubscriptionElement.self, from: data)
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
        type: HerdrRequestSubscriptionType? = nil,
        lines: Int?? = nil,
        match: HerdrRequestMatch?? = nil,
        paneID: PaneID?? = nil,
        source: HerdrRequestSource?? = nil,
        stripANSI: Bool?? = nil,
        agentStatus: HerdrRequestAgentStatusElement?? = nil
    ) -> HerdrRequestSubscriptionElement {
        return HerdrRequestSubscriptionElement(
            type: type ?? self.type,
            lines: lines ?? self.lines,
            match: match ?? self.match,
            paneID: paneID ?? self.paneID,
            source: source ?? self.source,
            stripANSI: stripANSI ?? self.stripANSI,
            agentStatus: agentStatus ?? self.agentStatus
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestMatch
public struct HerdrRequestMatch: Codable, Sendable {
    public let type: HerdrRequestOutputMatchType
    public let value: String

    public enum CodingKeys: String, CodingKey {
        case type = "type"
        case value = "value"
    }

    public init(type: HerdrRequestOutputMatchType, value: String) {
        self.type = type
        self.value = value
    }
}

// MARK: HerdrRequestMatch convenience initializers and mutators

public extension HerdrRequestMatch {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestMatch.self, from: data)
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
        type: HerdrRequestOutputMatchType? = nil,
        value: String? = nil
    ) -> HerdrRequestMatch {
        return HerdrRequestMatch(
            type: type ?? self.type,
            value: value ?? self.value
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestOutputMatchType: String, Codable, Sendable {
    case regex = "regex"
    case substring = "substring"
}

public enum HerdrRequestSubscriptionType: String, Codable, Sendable {
    case layoutUpdated = "layout.updated"
    case paneAgentDetected = "pane.agent_detected"
    case paneAgentStatusChanged = "pane.agent_status_changed"
    case paneClosed = "pane.closed"
    case paneCreated = "pane.created"
    case paneExited = "pane.exited"
    case paneFocused = "pane.focused"
    case paneMoved = "pane.moved"
    case paneOutputMatched = "pane.output_matched"
    case paneScrollChanged = "pane.scroll_changed"
    case paneUpdated = "pane.updated"
    case tabClosed = "tab.closed"
    case tabCreated = "tab.created"
    case tabFocused = "tab.focused"
    case tabMoved = "tab.moved"
    case tabRenamed = "tab.renamed"
    case workspaceClosed = "workspace.closed"
    case workspaceCreated = "workspace.created"
    case workspaceFocused = "workspace.focused"
    case workspaceMetadataUpdated = "workspace.metadata_updated"
    case workspaceMoved = "workspace.moved"
    case workspaceRenamed = "workspace.renamed"
    case workspaceReordered = "workspace.reordered"
    case workspaceUpdated = "workspace.updated"
    case worktreeCreated = "worktree.created"
    case worktreeOpened = "worktree.opened"
    case worktreeRemoved = "worktree.removed"
}

// MARK: - HerdrRequestEventsWaitParams
public struct HerdrRequestEventsWaitParams: Codable, Sendable {
    public let matchEvent: HerdrRequestEventMatch
    public let timeoutMS: Int?

    public enum CodingKeys: String, CodingKey {
        case matchEvent = "match_event"
        case timeoutMS = "timeout_ms"
    }

    public init(matchEvent: HerdrRequestEventMatch, timeoutMS: Int?) {
        self.matchEvent = matchEvent
        self.timeoutMS = timeoutMS
    }
}

// MARK: HerdrRequestEventsWaitParams convenience initializers and mutators

public extension HerdrRequestEventsWaitParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestEventsWaitParams.self, from: data)
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
        matchEvent: HerdrRequestEventMatch? = nil,
        timeoutMS: Int?? = nil
    ) -> HerdrRequestEventsWaitParams {
        return HerdrRequestEventsWaitParams(
            matchEvent: matchEvent ?? self.matchEvent,
            timeoutMS: timeoutMS ?? self.timeoutMS
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestIntegrationInstallParams
public struct HerdrRequestIntegrationInstallParams: Codable, Sendable {
    public let target: HerdrRequestTarget

    public enum CodingKeys: String, CodingKey {
        case target = "target"
    }

    public init(target: HerdrRequestTarget) {
        self.target = target
    }
}

// MARK: HerdrRequestIntegrationInstallParams convenience initializers and mutators

public extension HerdrRequestIntegrationInstallParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestIntegrationInstallParams.self, from: data)
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
        target: HerdrRequestTarget? = nil
    ) -> HerdrRequestIntegrationInstallParams {
        return HerdrRequestIntegrationInstallParams(
            target: target ?? self.target
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestTarget: String, Codable, Sendable {
    case claude = "claude"
    case codex = "codex"
    case copilot = "copilot"
    case cursor = "cursor"
    case devin = "devin"
    case droid = "droid"
    case grok = "grok"
    case hermes = "hermes"
    case kilo = "kilo"
    case kimi = "kimi"
    case mastracode = "mastracode"
    case omp = "omp"
    case opencode = "opencode"
    case pi = "pi"
    case qodercli = "qodercli"
}

// MARK: - HerdrRequestIntegrationUninstallParams
public struct HerdrRequestIntegrationUninstallParams: Codable, Sendable {
    public let target: HerdrRequestTarget

    public enum CodingKeys: String, CodingKey {
        case target = "target"
    }

    public init(target: HerdrRequestTarget) {
        self.target = target
    }
}

// MARK: HerdrRequestIntegrationUninstallParams convenience initializers and mutators

public extension HerdrRequestIntegrationUninstallParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestIntegrationUninstallParams.self, from: data)
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
        target: HerdrRequestTarget? = nil
    ) -> HerdrRequestIntegrationUninstallParams {
        return HerdrRequestIntegrationUninstallParams(
            target: target ?? self.target
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestLayoutApplyParams
public struct HerdrRequestLayoutApplyParams: Codable, Sendable {
    public let focus: Bool?
    public let root: HerdrRequestRoot
    public let tabID: TabID?
    public let tabLabel: String?
    public let workspaceID: WorkspaceID?

    public enum CodingKeys: String, CodingKey {
        case focus = "focus"
        case root = "root"
        case tabID = "tab_id"
        case tabLabel = "tab_label"
        case workspaceID = "workspace_id"
    }

    public init(focus: Bool?, root: HerdrRequestRoot, tabID: TabID?, tabLabel: String?, workspaceID: WorkspaceID?) {
        self.focus = focus
        self.root = root
        self.tabID = tabID
        self.tabLabel = tabLabel
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrRequestLayoutApplyParams convenience initializers and mutators

public extension HerdrRequestLayoutApplyParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestLayoutApplyParams.self, from: data)
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
        focus: Bool?? = nil,
        root: HerdrRequestRoot? = nil,
        tabID: TabID?? = nil,
        tabLabel: String?? = nil,
        workspaceID: WorkspaceID?? = nil
    ) -> HerdrRequestLayoutApplyParams {
        return HerdrRequestLayoutApplyParams(
            focus: focus ?? self.focus,
            root: root ?? self.root,
            tabID: tabID ?? self.tabID,
            tabLabel: tabLabel ?? self.tabLabel,
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestRoot
public final class HerdrRequestRoot: Codable, Sendable {
    public let command: [String]?
    public let cwd: String?
    public let env: [String: String]?
    public let label: String?
    public let paneID: PaneID?
    public let type: HerdrRequestLayoutNodeType
    public let direction: HerdrRequestDirection?
    public let first: HerdrRequestRoot?
    public let ratio: Double?
    public let second: HerdrRequestRoot?

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

    public init(command: [String]?, cwd: String?, env: [String: String]?, label: String?, paneID: PaneID?, type: HerdrRequestLayoutNodeType, direction: HerdrRequestDirection?, first: HerdrRequestRoot?, ratio: Double?, second: HerdrRequestRoot?) {
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

// MARK: HerdrRequestRoot convenience initializers and mutators

public extension HerdrRequestRoot {
    convenience init(data: Data) throws {
        let me = try newHerdrRequestJSONDecoder().decode(HerdrRequestRoot.self, from: data)
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
        type: HerdrRequestLayoutNodeType? = nil,
        direction: HerdrRequestDirection?? = nil,
        first: HerdrRequestRoot?? = nil,
        ratio: Double?? = nil,
        second: HerdrRequestRoot?? = nil
    ) -> HerdrRequestRoot {
        return HerdrRequestRoot(
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
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestDirection: String, Codable, Sendable {
    case directionRight = "right"
    case down = "down"
}

public enum HerdrRequestLayoutNodeType: String, Codable, Sendable {
    case pane = "pane"
    case split = "split"
}

// MARK: - HerdrRequestLayoutExportParams
public struct HerdrRequestLayoutExportParams: Codable, Sendable {
    public let paneID: PaneID?
    public let tabID: TabID?

    public enum CodingKeys: String, CodingKey {
        case paneID = "pane_id"
        case tabID = "tab_id"
    }

    public init(paneID: PaneID?, tabID: TabID?) {
        self.paneID = paneID
        self.tabID = tabID
    }
}

// MARK: HerdrRequestLayoutExportParams convenience initializers and mutators

public extension HerdrRequestLayoutExportParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestLayoutExportParams.self, from: data)
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
        paneID: PaneID?? = nil,
        tabID: TabID?? = nil
    ) -> HerdrRequestLayoutExportParams {
        return HerdrRequestLayoutExportParams(
            paneID: paneID ?? self.paneID,
            tabID: tabID ?? self.tabID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestLayoutSetSplitRatioParams
public struct HerdrRequestLayoutSetSplitRatioParams: Codable, Sendable {
    public let paneID: PaneID?
    public let path: [Bool]
    public let ratio: Double
    public let tabID: TabID?

    public enum CodingKeys: String, CodingKey {
        case paneID = "pane_id"
        case path = "path"
        case ratio = "ratio"
        case tabID = "tab_id"
    }

    public init(paneID: PaneID?, path: [Bool], ratio: Double, tabID: TabID?) {
        self.paneID = paneID
        self.path = path
        self.ratio = ratio
        self.tabID = tabID
    }
}

// MARK: HerdrRequestLayoutSetSplitRatioParams convenience initializers and mutators

public extension HerdrRequestLayoutSetSplitRatioParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestLayoutSetSplitRatioParams.self, from: data)
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
        paneID: PaneID?? = nil,
        path: [Bool]? = nil,
        ratio: Double? = nil,
        tabID: TabID?? = nil
    ) -> HerdrRequestLayoutSetSplitRatioParams {
        return HerdrRequestLayoutSetSplitRatioParams(
            paneID: paneID ?? self.paneID,
            path: path ?? self.path,
            ratio: ratio ?? self.ratio,
            tabID: tabID ?? self.tabID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestNotificationShowParams
public struct HerdrRequestNotificationShowParams: Codable, Sendable {
    public let body: String?
    public let position: HerdrRequestToastHerdrPositionEnum?
    public let sound: HerdrRequestSound?
    public let title: String

    public enum CodingKeys: String, CodingKey {
        case body = "body"
        case position = "position"
        case sound = "sound"
        case title = "title"
    }

    public init(body: String?, position: HerdrRequestToastHerdrPositionEnum?, sound: HerdrRequestSound?, title: String) {
        self.body = body
        self.position = position
        self.sound = sound
        self.title = title
    }
}

// MARK: HerdrRequestNotificationShowParams convenience initializers and mutators

public extension HerdrRequestNotificationShowParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestNotificationShowParams.self, from: data)
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
        body: String?? = nil,
        position: HerdrRequestToastHerdrPositionEnum?? = nil,
        sound: HerdrRequestSound?? = nil,
        title: String? = nil
    ) -> HerdrRequestNotificationShowParams {
        return HerdrRequestNotificationShowParams(
            body: body ?? self.body,
            position: position ?? self.position,
            sound: sound ?? self.sound,
            title: title ?? self.title
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestToastHerdrPositionEnum: String, Codable, Sendable {
    case bottomLeft = "bottom-left"
    case bottomRight = "bottom-right"
    case topLeft = "top-left"
    case topRight = "top-right"
}

public enum HerdrRequestSound: String, Codable, Sendable {
    case done = "done"
    case none = "none"
    case request = "request"
}

public enum HerdrRequestPaneAgentState: String, Codable, Sendable {
    case blocked = "blocked"
    case idle = "idle"
    case unknown = "unknown"
    case working = "working"
}

// MARK: - HerdrRequestPaneClearAgentAuthorityParams
public struct HerdrRequestPaneClearAgentAuthorityParams: Codable, Sendable {
    public let paneID: PaneID
    public let seq: Int?
    public let source: String?

    public enum CodingKeys: String, CodingKey {
        case paneID = "pane_id"
        case seq = "seq"
        case source = "source"
    }

    public init(paneID: PaneID, seq: Int?, source: String?) {
        self.paneID = paneID
        self.seq = seq
        self.source = source
    }
}

// MARK: HerdrRequestPaneClearAgentAuthorityParams convenience initializers and mutators

public extension HerdrRequestPaneClearAgentAuthorityParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneClearAgentAuthorityParams.self, from: data)
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
        paneID: PaneID? = nil,
        seq: Int?? = nil,
        source: String?? = nil
    ) -> HerdrRequestPaneClearAgentAuthorityParams {
        return HerdrRequestPaneClearAgentAuthorityParams(
            paneID: paneID ?? self.paneID,
            seq: seq ?? self.seq,
            source: source ?? self.source
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneCurrentParams
public struct HerdrRequestPaneCurrentParams: Codable, Sendable {
    public let callerPaneID: PaneID?

    public enum CodingKeys: String, CodingKey {
        case callerPaneID = "caller_pane_id"
    }

    public init(callerPaneID: PaneID?) {
        self.callerPaneID = callerPaneID
    }
}

// MARK: HerdrRequestPaneCurrentParams convenience initializers and mutators

public extension HerdrRequestPaneCurrentParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneCurrentParams.self, from: data)
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
        callerPaneID: PaneID?? = nil
    ) -> HerdrRequestPaneCurrentParams {
        return HerdrRequestPaneCurrentParams(
            callerPaneID: callerPaneID ?? self.callerPaneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestPaneDirection: String, Codable, Sendable {
    case down = "down"
    case paneDirectionLeft = "left"
    case paneDirectionRight = "right"
    case up = "up"
}

// MARK: - HerdrRequestPaneEdgesParams
public struct HerdrRequestPaneEdgesParams: Codable, Sendable {
    public let paneID: PaneID?

    public enum CodingKeys: String, CodingKey {
        case paneID = "pane_id"
    }

    public init(paneID: PaneID?) {
        self.paneID = paneID
    }
}

// MARK: HerdrRequestPaneEdgesParams convenience initializers and mutators

public extension HerdrRequestPaneEdgesParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneEdgesParams.self, from: data)
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
        paneID: PaneID?? = nil
    ) -> HerdrRequestPaneEdgesParams {
        return HerdrRequestPaneEdgesParams(
            paneID: paneID ?? self.paneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneFocusDirectionParams
public struct HerdrRequestPaneFocusDirectionParams: Codable, Sendable {
    public let direction: HerdrRequestPaneDirection
    public let paneID: PaneID?

    public enum CodingKeys: String, CodingKey {
        case direction = "direction"
        case paneID = "pane_id"
    }

    public init(direction: HerdrRequestPaneDirection, paneID: PaneID?) {
        self.direction = direction
        self.paneID = paneID
    }
}

// MARK: HerdrRequestPaneFocusDirectionParams convenience initializers and mutators

public extension HerdrRequestPaneFocusDirectionParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneFocusDirectionParams.self, from: data)
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
        direction: HerdrRequestPaneDirection? = nil,
        paneID: PaneID?? = nil
    ) -> HerdrRequestPaneFocusDirectionParams {
        return HerdrRequestPaneFocusDirectionParams(
            direction: direction ?? self.direction,
            paneID: paneID ?? self.paneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneGraphicsClearParams
public struct HerdrRequestPaneGraphicsClearParams: Codable, Sendable {
    public let paneID: PaneID

    public enum CodingKeys: String, CodingKey {
        case paneID = "pane_id"
    }

    public init(paneID: PaneID) {
        self.paneID = paneID
    }
}

// MARK: HerdrRequestPaneGraphicsClearParams convenience initializers and mutators

public extension HerdrRequestPaneGraphicsClearParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneGraphicsClearParams.self, from: data)
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
        paneID: PaneID? = nil
    ) -> HerdrRequestPaneGraphicsClearParams {
        return HerdrRequestPaneGraphicsClearParams(
            paneID: paneID ?? self.paneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestPaneGraphicsFormat: String, Codable, Sendable {
    case png = "png"
    case rgb = "rgb"
    case rgba = "rgba"
}

// MARK: - HerdrRequestPaneGraphicsPlacementParams
public struct HerdrRequestPaneGraphicsPlacementParams: Codable, Sendable {
    public let gridCols: Int?
    public let gridRows: Int?
    public let viewportCol: Int?
    public let viewportRow: Int?

    public enum CodingKeys: String, CodingKey {
        case gridCols = "grid_cols"
        case gridRows = "grid_rows"
        case viewportCol = "viewport_col"
        case viewportRow = "viewport_row"
    }

    public init(gridCols: Int?, gridRows: Int?, viewportCol: Int?, viewportRow: Int?) {
        self.gridCols = gridCols
        self.gridRows = gridRows
        self.viewportCol = viewportCol
        self.viewportRow = viewportRow
    }
}

// MARK: HerdrRequestPaneGraphicsPlacementParams convenience initializers and mutators

public extension HerdrRequestPaneGraphicsPlacementParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneGraphicsPlacementParams.self, from: data)
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
        gridCols: Int?? = nil,
        gridRows: Int?? = nil,
        viewportCol: Int?? = nil,
        viewportRow: Int?? = nil
    ) -> HerdrRequestPaneGraphicsPlacementParams {
        return HerdrRequestPaneGraphicsPlacementParams(
            gridCols: gridCols ?? self.gridCols,
            gridRows: gridRows ?? self.gridRows,
            viewportCol: viewportCol ?? self.viewportCol,
            viewportRow: viewportRow ?? self.viewportRow
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneGraphicsSetParams
public struct HerdrRequestPaneGraphicsSetParams: Codable, Sendable {
    public let dataBase64: String?
    public let format: HerdrRequestPaneGraphicsFormat
    public let imageHeight: Int
    public let imageWidth: Int
    public let paneID: PaneID
    public let placement: HerdrRequestPaneGraphicsPlacementParams?

    public enum CodingKeys: String, CodingKey {
        case dataBase64 = "data_base64"
        case format = "format"
        case imageHeight = "image_height"
        case imageWidth = "image_width"
        case paneID = "pane_id"
        case placement = "placement"
    }

    public init(dataBase64: String?, format: HerdrRequestPaneGraphicsFormat, imageHeight: Int, imageWidth: Int, paneID: PaneID, placement: HerdrRequestPaneGraphicsPlacementParams?) {
        self.dataBase64 = dataBase64
        self.format = format
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
        self.paneID = paneID
        self.placement = placement
    }
}

// MARK: HerdrRequestPaneGraphicsSetParams convenience initializers and mutators

public extension HerdrRequestPaneGraphicsSetParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneGraphicsSetParams.self, from: data)
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
        dataBase64: String?? = nil,
        format: HerdrRequestPaneGraphicsFormat? = nil,
        imageHeight: Int? = nil,
        imageWidth: Int? = nil,
        paneID: PaneID? = nil,
        placement: HerdrRequestPaneGraphicsPlacementParams?? = nil
    ) -> HerdrRequestPaneGraphicsSetParams {
        return HerdrRequestPaneGraphicsSetParams(
            dataBase64: dataBase64 ?? self.dataBase64,
            format: format ?? self.format,
            imageHeight: imageHeight ?? self.imageHeight,
            imageWidth: imageWidth ?? self.imageWidth,
            paneID: paneID ?? self.paneID,
            placement: placement ?? self.placement
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneLayoutParams
public struct HerdrRequestPaneLayoutParams: Codable, Sendable {
    public let paneID: PaneID?

    public enum CodingKeys: String, CodingKey {
        case paneID = "pane_id"
    }

    public init(paneID: PaneID?) {
        self.paneID = paneID
    }
}

// MARK: HerdrRequestPaneLayoutParams convenience initializers and mutators

public extension HerdrRequestPaneLayoutParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneLayoutParams.self, from: data)
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
        paneID: PaneID?? = nil
    ) -> HerdrRequestPaneLayoutParams {
        return HerdrRequestPaneLayoutParams(
            paneID: paneID ?? self.paneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneListParams
public struct HerdrRequestPaneListParams: Codable, Sendable {
    public let workspaceID: WorkspaceID?

    public enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
    }

    public init(workspaceID: WorkspaceID?) {
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrRequestPaneListParams convenience initializers and mutators

public extension HerdrRequestPaneListParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneListParams.self, from: data)
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
        workspaceID: WorkspaceID?? = nil
    ) -> HerdrRequestPaneListParams {
        return HerdrRequestPaneListParams(
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneMoveDestination
public struct HerdrRequestPaneMoveDestination: Codable, Sendable {
    public let ratio: Double?
    public let split: HerdrRequestDirection?
    public let tabID: TabID?
    public let targetPaneID: PaneID?
    public let type: HerdrRequestPaneMoveDestinationType
    public let label: String?
    public let workspaceID: WorkspaceID?
    public let tabLabel: String?

    public enum CodingKeys: String, CodingKey {
        case ratio = "ratio"
        case split = "split"
        case tabID = "tab_id"
        case targetPaneID = "target_pane_id"
        case type = "type"
        case label = "label"
        case workspaceID = "workspace_id"
        case tabLabel = "tab_label"
    }

    public init(ratio: Double?, split: HerdrRequestDirection?, tabID: TabID?, targetPaneID: PaneID?, type: HerdrRequestPaneMoveDestinationType, label: String?, workspaceID: WorkspaceID?, tabLabel: String?) {
        self.ratio = ratio
        self.split = split
        self.tabID = tabID
        self.targetPaneID = targetPaneID
        self.type = type
        self.label = label
        self.workspaceID = workspaceID
        self.tabLabel = tabLabel
    }
}

// MARK: HerdrRequestPaneMoveDestination convenience initializers and mutators

public extension HerdrRequestPaneMoveDestination {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneMoveDestination.self, from: data)
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
        ratio: Double?? = nil,
        split: HerdrRequestDirection?? = nil,
        tabID: TabID?? = nil,
        targetPaneID: PaneID?? = nil,
        type: HerdrRequestPaneMoveDestinationType? = nil,
        label: String?? = nil,
        workspaceID: WorkspaceID?? = nil,
        tabLabel: String?? = nil
    ) -> HerdrRequestPaneMoveDestination {
        return HerdrRequestPaneMoveDestination(
            ratio: ratio ?? self.ratio,
            split: split ?? self.split,
            tabID: tabID ?? self.tabID,
            targetPaneID: targetPaneID ?? self.targetPaneID,
            type: type ?? self.type,
            label: label ?? self.label,
            workspaceID: workspaceID ?? self.workspaceID,
            tabLabel: tabLabel ?? self.tabLabel
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestPaneMoveDestinationType: String, Codable, Sendable {
    case newTab = "new_tab"
    case newWorkspace = "new_workspace"
    case tab = "tab"
}

// MARK: - HerdrRequestPaneMoveParams
public struct HerdrRequestPaneMoveParams: Codable, Sendable {
    public let destination: HerdrRequestPaneMoveDestination
    public let focus: Bool?
    public let paneID: PaneID

    public enum CodingKeys: String, CodingKey {
        case destination = "destination"
        case focus = "focus"
        case paneID = "pane_id"
    }

    public init(destination: HerdrRequestPaneMoveDestination, focus: Bool?, paneID: PaneID) {
        self.destination = destination
        self.focus = focus
        self.paneID = paneID
    }
}

// MARK: HerdrRequestPaneMoveParams convenience initializers and mutators

public extension HerdrRequestPaneMoveParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneMoveParams.self, from: data)
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
        destination: HerdrRequestPaneMoveDestination? = nil,
        focus: Bool?? = nil,
        paneID: PaneID? = nil
    ) -> HerdrRequestPaneMoveParams {
        return HerdrRequestPaneMoveParams(
            destination: destination ?? self.destination,
            focus: focus ?? self.focus,
            paneID: paneID ?? self.paneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneNeighborParams
public struct HerdrRequestPaneNeighborParams: Codable, Sendable {
    public let direction: HerdrRequestPaneDirection
    public let paneID: PaneID?

    public enum CodingKeys: String, CodingKey {
        case direction = "direction"
        case paneID = "pane_id"
    }

    public init(direction: HerdrRequestPaneDirection, paneID: PaneID?) {
        self.direction = direction
        self.paneID = paneID
    }
}

// MARK: HerdrRequestPaneNeighborParams convenience initializers and mutators

public extension HerdrRequestPaneNeighborParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneNeighborParams.self, from: data)
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
        direction: HerdrRequestPaneDirection? = nil,
        paneID: PaneID?? = nil
    ) -> HerdrRequestPaneNeighborParams {
        return HerdrRequestPaneNeighborParams(
            direction: direction ?? self.direction,
            paneID: paneID ?? self.paneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneProcessInfoParams
public struct HerdrRequestPaneProcessInfoParams: Codable, Sendable {
    public let paneID: PaneID?

    public enum CodingKeys: String, CodingKey {
        case paneID = "pane_id"
    }

    public init(paneID: PaneID?) {
        self.paneID = paneID
    }
}

// MARK: HerdrRequestPaneProcessInfoParams convenience initializers and mutators

public extension HerdrRequestPaneProcessInfoParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneProcessInfoParams.self, from: data)
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
        paneID: PaneID?? = nil
    ) -> HerdrRequestPaneProcessInfoParams {
        return HerdrRequestPaneProcessInfoParams(
            paneID: paneID ?? self.paneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneReadParams
public struct HerdrRequestPaneReadParams: Codable, Sendable {
    public let format: HerdrRequestFormat?
    public let lines: Int?
    public let paneID: PaneID
    public let source: HerdrRequestSource
    public let stripANSI: Bool?

    public enum CodingKeys: String, CodingKey {
        case format = "format"
        case lines = "lines"
        case paneID = "pane_id"
        case source = "source"
        case stripANSI = "strip_ansi"
    }

    public init(format: HerdrRequestFormat?, lines: Int?, paneID: PaneID, source: HerdrRequestSource, stripANSI: Bool?) {
        self.format = format
        self.lines = lines
        self.paneID = paneID
        self.source = source
        self.stripANSI = stripANSI
    }
}

// MARK: HerdrRequestPaneReadParams convenience initializers and mutators

public extension HerdrRequestPaneReadParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneReadParams.self, from: data)
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
        format: HerdrRequestFormat?? = nil,
        lines: Int?? = nil,
        paneID: PaneID? = nil,
        source: HerdrRequestSource? = nil,
        stripANSI: Bool?? = nil
    ) -> HerdrRequestPaneReadParams {
        return HerdrRequestPaneReadParams(
            format: format ?? self.format,
            lines: lines ?? self.lines,
            paneID: paneID ?? self.paneID,
            source: source ?? self.source,
            stripANSI: stripANSI ?? self.stripANSI
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneReleaseAgentParams
public struct HerdrRequestPaneReleaseAgentParams: Codable, Sendable {
    public let agent: String
    public let paneID: PaneID
    public let seq: Int?
    public let source: String

    public enum CodingKeys: String, CodingKey {
        case agent = "agent"
        case paneID = "pane_id"
        case seq = "seq"
        case source = "source"
    }

    public init(agent: String, paneID: PaneID, seq: Int?, source: String) {
        self.agent = agent
        self.paneID = paneID
        self.seq = seq
        self.source = source
    }
}

// MARK: HerdrRequestPaneReleaseAgentParams convenience initializers and mutators

public extension HerdrRequestPaneReleaseAgentParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneReleaseAgentParams.self, from: data)
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
        paneID: PaneID? = nil,
        seq: Int?? = nil,
        source: String? = nil
    ) -> HerdrRequestPaneReleaseAgentParams {
        return HerdrRequestPaneReleaseAgentParams(
            agent: agent ?? self.agent,
            paneID: paneID ?? self.paneID,
            seq: seq ?? self.seq,
            source: source ?? self.source
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneRenameParams
public struct HerdrRequestPaneRenameParams: Codable, Sendable {
    public let label: String?
    public let paneID: PaneID

    public enum CodingKeys: String, CodingKey {
        case label = "label"
        case paneID = "pane_id"
    }

    public init(label: String?, paneID: PaneID) {
        self.label = label
        self.paneID = paneID
    }
}

// MARK: HerdrRequestPaneRenameParams convenience initializers and mutators

public extension HerdrRequestPaneRenameParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneRenameParams.self, from: data)
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
        label: String?? = nil,
        paneID: PaneID? = nil
    ) -> HerdrRequestPaneRenameParams {
        return HerdrRequestPaneRenameParams(
            label: label ?? self.label,
            paneID: paneID ?? self.paneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneReportAgentParams
public struct HerdrRequestPaneReportAgentParams: Codable, Sendable {
    public let agent: String
    public let agentSessionID: String?
    public let agentSessionPath: String?
    public let message: String?
    public let paneID: PaneID
    public let seq: Int?
    public let source: String
    public let state: HerdrRequestPaneAgentState

    public enum CodingKeys: String, CodingKey {
        case agent = "agent"
        case agentSessionID = "agent_session_id"
        case agentSessionPath = "agent_session_path"
        case message = "message"
        case paneID = "pane_id"
        case seq = "seq"
        case source = "source"
        case state = "state"
    }

    public init(agent: String, agentSessionID: String?, agentSessionPath: String?, message: String?, paneID: PaneID, seq: Int?, source: String, state: HerdrRequestPaneAgentState) {
        self.agent = agent
        self.agentSessionID = agentSessionID
        self.agentSessionPath = agentSessionPath
        self.message = message
        self.paneID = paneID
        self.seq = seq
        self.source = source
        self.state = state
    }
}

// MARK: HerdrRequestPaneReportAgentParams convenience initializers and mutators

public extension HerdrRequestPaneReportAgentParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneReportAgentParams.self, from: data)
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
        agentSessionID: String?? = nil,
        agentSessionPath: String?? = nil,
        message: String?? = nil,
        paneID: PaneID? = nil,
        seq: Int?? = nil,
        source: String? = nil,
        state: HerdrRequestPaneAgentState? = nil
    ) -> HerdrRequestPaneReportAgentParams {
        return HerdrRequestPaneReportAgentParams(
            agent: agent ?? self.agent,
            agentSessionID: agentSessionID ?? self.agentSessionID,
            agentSessionPath: agentSessionPath ?? self.agentSessionPath,
            message: message ?? self.message,
            paneID: paneID ?? self.paneID,
            seq: seq ?? self.seq,
            source: source ?? self.source,
            state: state ?? self.state
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneReportAgentSessionParams
public struct HerdrRequestPaneReportAgentSessionParams: Codable, Sendable {
    public let agent: String
    public let agentSessionID: String?
    public let agentSessionPath: String?
    public let paneID: PaneID
    public let seq: Int?
    public let sessionStartSource: String?
    public let source: String

    public enum CodingKeys: String, CodingKey {
        case agent = "agent"
        case agentSessionID = "agent_session_id"
        case agentSessionPath = "agent_session_path"
        case paneID = "pane_id"
        case seq = "seq"
        case sessionStartSource = "session_start_source"
        case source = "source"
    }

    public init(agent: String, agentSessionID: String?, agentSessionPath: String?, paneID: PaneID, seq: Int?, sessionStartSource: String?, source: String) {
        self.agent = agent
        self.agentSessionID = agentSessionID
        self.agentSessionPath = agentSessionPath
        self.paneID = paneID
        self.seq = seq
        self.sessionStartSource = sessionStartSource
        self.source = source
    }
}

// MARK: HerdrRequestPaneReportAgentSessionParams convenience initializers and mutators

public extension HerdrRequestPaneReportAgentSessionParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneReportAgentSessionParams.self, from: data)
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
        agentSessionID: String?? = nil,
        agentSessionPath: String?? = nil,
        paneID: PaneID? = nil,
        seq: Int?? = nil,
        sessionStartSource: String?? = nil,
        source: String? = nil
    ) -> HerdrRequestPaneReportAgentSessionParams {
        return HerdrRequestPaneReportAgentSessionParams(
            agent: agent ?? self.agent,
            agentSessionID: agentSessionID ?? self.agentSessionID,
            agentSessionPath: agentSessionPath ?? self.agentSessionPath,
            paneID: paneID ?? self.paneID,
            seq: seq ?? self.seq,
            sessionStartSource: sessionStartSource ?? self.sessionStartSource,
            source: source ?? self.source
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneReportMetadataParams
public struct HerdrRequestPaneReportMetadataParams: Codable, Sendable {
    public let agent: String?
    public let appliesToSource: String?
    public let clearDisplayAgent: Bool?
    public let clearStateLabels: Bool?
    public let clearTitle: Bool?
    public let displayAgent: String?
    public let paneID: PaneID
    public let seq: Int?
    public let source: String
    public let stateLabels: [String: String]?
    public let title: String?
    public let tokens: [String: String?]?
    public let ttlMS: Int?

    public enum CodingKeys: String, CodingKey {
        case agent = "agent"
        case appliesToSource = "applies_to_source"
        case clearDisplayAgent = "clear_display_agent"
        case clearStateLabels = "clear_state_labels"
        case clearTitle = "clear_title"
        case displayAgent = "display_agent"
        case paneID = "pane_id"
        case seq = "seq"
        case source = "source"
        case stateLabels = "state_labels"
        case title = "title"
        case tokens = "tokens"
        case ttlMS = "ttl_ms"
    }

    public init(agent: String?, appliesToSource: String?, clearDisplayAgent: Bool?, clearStateLabels: Bool?, clearTitle: Bool?, displayAgent: String?, paneID: PaneID, seq: Int?, source: String, stateLabels: [String: String]?, title: String?, tokens: [String: String?]?, ttlMS: Int?) {
        self.agent = agent
        self.appliesToSource = appliesToSource
        self.clearDisplayAgent = clearDisplayAgent
        self.clearStateLabels = clearStateLabels
        self.clearTitle = clearTitle
        self.displayAgent = displayAgent
        self.paneID = paneID
        self.seq = seq
        self.source = source
        self.stateLabels = stateLabels
        self.title = title
        self.tokens = tokens
        self.ttlMS = ttlMS
    }
}

// MARK: HerdrRequestPaneReportMetadataParams convenience initializers and mutators

public extension HerdrRequestPaneReportMetadataParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneReportMetadataParams.self, from: data)
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
        appliesToSource: String?? = nil,
        clearDisplayAgent: Bool?? = nil,
        clearStateLabels: Bool?? = nil,
        clearTitle: Bool?? = nil,
        displayAgent: String?? = nil,
        paneID: PaneID? = nil,
        seq: Int?? = nil,
        source: String? = nil,
        stateLabels: [String: String]?? = nil,
        title: String?? = nil,
        tokens: [String: String?]?? = nil,
        ttlMS: Int?? = nil
    ) -> HerdrRequestPaneReportMetadataParams {
        return HerdrRequestPaneReportMetadataParams(
            agent: agent ?? self.agent,
            appliesToSource: appliesToSource ?? self.appliesToSource,
            clearDisplayAgent: clearDisplayAgent ?? self.clearDisplayAgent,
            clearStateLabels: clearStateLabels ?? self.clearStateLabels,
            clearTitle: clearTitle ?? self.clearTitle,
            displayAgent: displayAgent ?? self.displayAgent,
            paneID: paneID ?? self.paneID,
            seq: seq ?? self.seq,
            source: source ?? self.source,
            stateLabels: stateLabels ?? self.stateLabels,
            title: title ?? self.title,
            tokens: tokens ?? self.tokens,
            ttlMS: ttlMS ?? self.ttlMS
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneResizeParams
public struct HerdrRequestPaneResizeParams: Codable, Sendable {
    public let amount: Double?
    public let direction: HerdrRequestPaneDirection
    public let paneID: PaneID?

    public enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case direction = "direction"
        case paneID = "pane_id"
    }

    public init(amount: Double?, direction: HerdrRequestPaneDirection, paneID: PaneID?) {
        self.amount = amount
        self.direction = direction
        self.paneID = paneID
    }
}

// MARK: HerdrRequestPaneResizeParams convenience initializers and mutators

public extension HerdrRequestPaneResizeParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneResizeParams.self, from: data)
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
        amount: Double?? = nil,
        direction: HerdrRequestPaneDirection? = nil,
        paneID: PaneID?? = nil
    ) -> HerdrRequestPaneResizeParams {
        return HerdrRequestPaneResizeParams(
            amount: amount ?? self.amount,
            direction: direction ?? self.direction,
            paneID: paneID ?? self.paneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneSendInputParams
public struct HerdrRequestPaneSendInputParams: Codable, Sendable {
    public let keys: [String]?
    public let paneID: PaneID
    public let text: String?

    public enum CodingKeys: String, CodingKey {
        case keys = "keys"
        case paneID = "pane_id"
        case text = "text"
    }

    public init(keys: [String]?, paneID: PaneID, text: String?) {
        self.keys = keys
        self.paneID = paneID
        self.text = text
    }
}

// MARK: HerdrRequestPaneSendInputParams convenience initializers and mutators

public extension HerdrRequestPaneSendInputParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneSendInputParams.self, from: data)
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
        keys: [String]?? = nil,
        paneID: PaneID? = nil,
        text: String?? = nil
    ) -> HerdrRequestPaneSendInputParams {
        return HerdrRequestPaneSendInputParams(
            keys: keys ?? self.keys,
            paneID: paneID ?? self.paneID,
            text: text ?? self.text
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneSendKeysParams
public struct HerdrRequestPaneSendKeysParams: Codable, Sendable {
    public let keys: [String]
    public let paneID: PaneID

    public enum CodingKeys: String, CodingKey {
        case keys = "keys"
        case paneID = "pane_id"
    }

    public init(keys: [String], paneID: PaneID) {
        self.keys = keys
        self.paneID = paneID
    }
}

// MARK: HerdrRequestPaneSendKeysParams convenience initializers and mutators

public extension HerdrRequestPaneSendKeysParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneSendKeysParams.self, from: data)
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
        keys: [String]? = nil,
        paneID: PaneID? = nil
    ) -> HerdrRequestPaneSendKeysParams {
        return HerdrRequestPaneSendKeysParams(
            keys: keys ?? self.keys,
            paneID: paneID ?? self.paneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneSendTextParams
public struct HerdrRequestPaneSendTextParams: Codable, Sendable {
    public let paneID: PaneID
    public let text: String

    public enum CodingKeys: String, CodingKey {
        case paneID = "pane_id"
        case text = "text"
    }

    public init(paneID: PaneID, text: String) {
        self.paneID = paneID
        self.text = text
    }
}

// MARK: HerdrRequestPaneSendTextParams convenience initializers and mutators

public extension HerdrRequestPaneSendTextParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneSendTextParams.self, from: data)
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
        paneID: PaneID? = nil,
        text: String? = nil
    ) -> HerdrRequestPaneSendTextParams {
        return HerdrRequestPaneSendTextParams(
            paneID: paneID ?? self.paneID,
            text: text ?? self.text
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneSplitParams
public struct HerdrRequestPaneSplitParams: Codable, Sendable {
    public let cwd: String?
    public let direction: HerdrRequestDirection
    public let env: [String: String]?
    public let focus: Bool?
    public let ratio: Double?
    public let targetPaneID: PaneID?
    public let workspaceID: WorkspaceID?

    public enum CodingKeys: String, CodingKey {
        case cwd = "cwd"
        case direction = "direction"
        case env = "env"
        case focus = "focus"
        case ratio = "ratio"
        case targetPaneID = "target_pane_id"
        case workspaceID = "workspace_id"
    }

    public init(cwd: String?, direction: HerdrRequestDirection, env: [String: String]?, focus: Bool?, ratio: Double?, targetPaneID: PaneID?, workspaceID: WorkspaceID?) {
        self.cwd = cwd
        self.direction = direction
        self.env = env
        self.focus = focus
        self.ratio = ratio
        self.targetPaneID = targetPaneID
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrRequestPaneSplitParams convenience initializers and mutators

public extension HerdrRequestPaneSplitParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneSplitParams.self, from: data)
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
        cwd: String?? = nil,
        direction: HerdrRequestDirection? = nil,
        env: [String: String]?? = nil,
        focus: Bool?? = nil,
        ratio: Double?? = nil,
        targetPaneID: PaneID?? = nil,
        workspaceID: WorkspaceID?? = nil
    ) -> HerdrRequestPaneSplitParams {
        return HerdrRequestPaneSplitParams(
            cwd: cwd ?? self.cwd,
            direction: direction ?? self.direction,
            env: env ?? self.env,
            focus: focus ?? self.focus,
            ratio: ratio ?? self.ratio,
            targetPaneID: targetPaneID ?? self.targetPaneID,
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneSwapParams
public struct HerdrRequestPaneSwapParams: Codable, Sendable {
    public let direction: HerdrRequestPaneDirection?
    public let paneID: PaneID?
    public let sourcePaneID: PaneID?
    public let targetPaneID: PaneID?

    public enum CodingKeys: String, CodingKey {
        case direction = "direction"
        case paneID = "pane_id"
        case sourcePaneID = "source_pane_id"
        case targetPaneID = "target_pane_id"
    }

    public init(direction: HerdrRequestPaneDirection?, paneID: PaneID?, sourcePaneID: PaneID?, targetPaneID: PaneID?) {
        self.direction = direction
        self.paneID = paneID
        self.sourcePaneID = sourcePaneID
        self.targetPaneID = targetPaneID
    }
}

// MARK: HerdrRequestPaneSwapParams convenience initializers and mutators

public extension HerdrRequestPaneSwapParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneSwapParams.self, from: data)
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
        direction: HerdrRequestPaneDirection?? = nil,
        paneID: PaneID?? = nil,
        sourcePaneID: PaneID?? = nil,
        targetPaneID: PaneID?? = nil
    ) -> HerdrRequestPaneSwapParams {
        return HerdrRequestPaneSwapParams(
            direction: direction ?? self.direction,
            paneID: paneID ?? self.paneID,
            sourcePaneID: sourcePaneID ?? self.sourcePaneID,
            targetPaneID: targetPaneID ?? self.targetPaneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneTarget
public struct HerdrRequestPaneTarget: Codable, Sendable {
    public let paneID: PaneID

    public enum CodingKeys: String, CodingKey {
        case paneID = "pane_id"
    }

    public init(paneID: PaneID) {
        self.paneID = paneID
    }
}

// MARK: HerdrRequestPaneTarget convenience initializers and mutators

public extension HerdrRequestPaneTarget {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneTarget.self, from: data)
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
        paneID: PaneID? = nil
    ) -> HerdrRequestPaneTarget {
        return HerdrRequestPaneTarget(
            paneID: paneID ?? self.paneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPaneWaitForOutputParams
public struct HerdrRequestPaneWaitForOutputParams: Codable, Sendable {
    public let lines: Int?
    public let match: HerdrRequestMatch
    public let paneID: PaneID
    public let source: HerdrRequestSource
    public let stripANSI: Bool?
    public let timeoutMS: Int?

    public enum CodingKeys: String, CodingKey {
        case lines = "lines"
        case match = "match"
        case paneID = "pane_id"
        case source = "source"
        case stripANSI = "strip_ansi"
        case timeoutMS = "timeout_ms"
    }

    public init(lines: Int?, match: HerdrRequestMatch, paneID: PaneID, source: HerdrRequestSource, stripANSI: Bool?, timeoutMS: Int?) {
        self.lines = lines
        self.match = match
        self.paneID = paneID
        self.source = source
        self.stripANSI = stripANSI
        self.timeoutMS = timeoutMS
    }
}

// MARK: HerdrRequestPaneWaitForOutputParams convenience initializers and mutators

public extension HerdrRequestPaneWaitForOutputParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneWaitForOutputParams.self, from: data)
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
        lines: Int?? = nil,
        match: HerdrRequestMatch? = nil,
        paneID: PaneID? = nil,
        source: HerdrRequestSource? = nil,
        stripANSI: Bool?? = nil,
        timeoutMS: Int?? = nil
    ) -> HerdrRequestPaneWaitForOutputParams {
        return HerdrRequestPaneWaitForOutputParams(
            lines: lines ?? self.lines,
            match: match ?? self.match,
            paneID: paneID ?? self.paneID,
            source: source ?? self.source,
            stripANSI: stripANSI ?? self.stripANSI,
            timeoutMS: timeoutMS ?? self.timeoutMS
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestPaneZoomMode: String, Codable, Sendable {
    case off = "off"
    case on = "on"
    case toggle = "toggle"
}

// MARK: - HerdrRequestPaneZoomParams
public struct HerdrRequestPaneZoomParams: Codable, Sendable {
    public let mode: HerdrRequestPaneZoomMode?
    public let paneID: PaneID?

    public enum CodingKeys: String, CodingKey {
        case mode = "mode"
        case paneID = "pane_id"
    }

    public init(mode: HerdrRequestPaneZoomMode?, paneID: PaneID?) {
        self.mode = mode
        self.paneID = paneID
    }
}

// MARK: HerdrRequestPaneZoomParams convenience initializers and mutators

public extension HerdrRequestPaneZoomParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPaneZoomParams.self, from: data)
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
        mode: HerdrRequestPaneZoomMode?? = nil,
        paneID: PaneID?? = nil
    ) -> HerdrRequestPaneZoomParams {
        return HerdrRequestPaneZoomParams(
            mode: mode ?? self.mode,
            paneID: paneID ?? self.paneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPluginActionInvokeParams
public struct HerdrRequestPluginActionInvokeParams: Codable, Sendable {
    public let actionID: String
    public let context: HerdrRequestPluginInvocationContextClass?
    public let pluginID: String?

    public enum CodingKeys: String, CodingKey {
        case actionID = "action_id"
        case context = "context"
        case pluginID = "plugin_id"
    }

    public init(actionID: String, context: HerdrRequestPluginInvocationContextClass?, pluginID: String?) {
        self.actionID = actionID
        self.context = context
        self.pluginID = pluginID
    }
}

// MARK: HerdrRequestPluginActionInvokeParams convenience initializers and mutators

public extension HerdrRequestPluginActionInvokeParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPluginActionInvokeParams.self, from: data)
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
        context: HerdrRequestPluginInvocationContextClass?? = nil,
        pluginID: String?? = nil
    ) -> HerdrRequestPluginActionInvokeParams {
        return HerdrRequestPluginActionInvokeParams(
            actionID: actionID ?? self.actionID,
            context: context ?? self.context,
            pluginID: pluginID ?? self.pluginID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPluginInvocationContextClass
public struct HerdrRequestPluginInvocationContextClass: Codable, Sendable {
    public let clickedURL: String?
    public let correlationID: String?
    public let focusedPaneAgent: String?
    public let focusedPaneCwd: String?
    public let focusedPaneID: PaneID?
    public let focusedPaneStatus: HerdrRequestAgentStatusElement?
    public let invocationSource: String?
    public let linkHandlerID: String?
    public let selectedText: String?
    public let tabID: TabID?
    public let tabLabel: String?
    public let workspaceCwd: String?
    public let workspaceID: WorkspaceID?
    public let workspaceLabel: String?
    public let worktree: HerdrRequestWorkspaceWorktreeInfoClass?

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

    public init(clickedURL: String?, correlationID: String?, focusedPaneAgent: String?, focusedPaneCwd: String?, focusedPaneID: PaneID?, focusedPaneStatus: HerdrRequestAgentStatusElement?, invocationSource: String?, linkHandlerID: String?, selectedText: String?, tabID: TabID?, tabLabel: String?, workspaceCwd: String?, workspaceID: WorkspaceID?, workspaceLabel: String?, worktree: HerdrRequestWorkspaceWorktreeInfoClass?) {
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

// MARK: HerdrRequestPluginInvocationContextClass convenience initializers and mutators

public extension HerdrRequestPluginInvocationContextClass {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPluginInvocationContextClass.self, from: data)
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
        focusedPaneStatus: HerdrRequestAgentStatusElement?? = nil,
        invocationSource: String?? = nil,
        linkHandlerID: String?? = nil,
        selectedText: String?? = nil,
        tabID: TabID?? = nil,
        tabLabel: String?? = nil,
        workspaceCwd: String?? = nil,
        workspaceID: WorkspaceID?? = nil,
        workspaceLabel: String?? = nil,
        worktree: HerdrRequestWorkspaceWorktreeInfoClass?? = nil
    ) -> HerdrRequestPluginInvocationContextClass {
        return HerdrRequestPluginInvocationContextClass(
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
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestWorkspaceWorktreeInfoClass
public struct HerdrRequestWorkspaceWorktreeInfoClass: Codable, Sendable {
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

// MARK: HerdrRequestWorkspaceWorktreeInfoClass convenience initializers and mutators

public extension HerdrRequestWorkspaceWorktreeInfoClass {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestWorkspaceWorktreeInfoClass.self, from: data)
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
    ) -> HerdrRequestWorkspaceWorktreeInfoClass {
        return HerdrRequestWorkspaceWorktreeInfoClass(
            checkoutPath: checkoutPath ?? self.checkoutPath,
            isLinkedWorktree: isLinkedWorktree ?? self.isLinkedWorktree,
            repoKey: repoKey ?? self.repoKey,
            repoName: repoName ?? self.repoName,
            repoRoot: repoRoot ?? self.repoRoot
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPluginActionListParams
public struct HerdrRequestPluginActionListParams: Codable, Sendable {
    public let pluginID: String?

    public enum CodingKeys: String, CodingKey {
        case pluginID = "plugin_id"
    }

    public init(pluginID: String?) {
        self.pluginID = pluginID
    }
}

// MARK: HerdrRequestPluginActionListParams convenience initializers and mutators

public extension HerdrRequestPluginActionListParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPluginActionListParams.self, from: data)
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
        pluginID: String?? = nil
    ) -> HerdrRequestPluginActionListParams {
        return HerdrRequestPluginActionListParams(
            pluginID: pluginID ?? self.pluginID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPluginLinkParams
public struct HerdrRequestPluginLinkParams: Codable, Sendable {
    public let enabled: Bool?
    public let path: String
    public let source: HerdrRequestPluginSourceInfoClass?

    public enum CodingKeys: String, CodingKey {
        case enabled = "enabled"
        case path = "path"
        case source = "source"
    }

    public init(enabled: Bool?, path: String, source: HerdrRequestPluginSourceInfoClass?) {
        self.enabled = enabled
        self.path = path
        self.source = source
    }
}

// MARK: HerdrRequestPluginLinkParams convenience initializers and mutators

public extension HerdrRequestPluginLinkParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPluginLinkParams.self, from: data)
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
        enabled: Bool?? = nil,
        path: String? = nil,
        source: HerdrRequestPluginSourceInfoClass?? = nil
    ) -> HerdrRequestPluginLinkParams {
        return HerdrRequestPluginLinkParams(
            enabled: enabled ?? self.enabled,
            path: path ?? self.path,
            source: source ?? self.source
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPluginSourceInfoClass
public struct HerdrRequestPluginSourceInfoClass: Codable, Sendable {
    public let installedUnixMS: Int?
    public let kind: HerdrRequestKind?
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

    public init(installedUnixMS: Int?, kind: HerdrRequestKind?, managedPath: String?, owner: String?, repo: String?, requestedRef: String?, resolvedCommit: String?, subdir: String?) {
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

// MARK: HerdrRequestPluginSourceInfoClass convenience initializers and mutators

public extension HerdrRequestPluginSourceInfoClass {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPluginSourceInfoClass.self, from: data)
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
        kind: HerdrRequestKind?? = nil,
        managedPath: String?? = nil,
        owner: String?? = nil,
        repo: String?? = nil,
        requestedRef: String?? = nil,
        resolvedCommit: String?? = nil,
        subdir: String?? = nil
    ) -> HerdrRequestPluginSourceInfoClass {
        return HerdrRequestPluginSourceInfoClass(
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
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestKind: String, Codable, Sendable {
    case github = "github"
    case local = "local"
}

// MARK: - HerdrRequestPluginListParams
public struct HerdrRequestPluginListParams: Codable, Sendable {
    public let pluginID: String?

    public enum CodingKeys: String, CodingKey {
        case pluginID = "plugin_id"
    }

    public init(pluginID: String?) {
        self.pluginID = pluginID
    }
}

// MARK: HerdrRequestPluginListParams convenience initializers and mutators

public extension HerdrRequestPluginListParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPluginListParams.self, from: data)
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
        pluginID: String?? = nil
    ) -> HerdrRequestPluginListParams {
        return HerdrRequestPluginListParams(
            pluginID: pluginID ?? self.pluginID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPluginLogListParams
public struct HerdrRequestPluginLogListParams: Codable, Sendable {
    public let limit: Int?
    public let pluginID: String?

    public enum CodingKeys: String, CodingKey {
        case limit = "limit"
        case pluginID = "plugin_id"
    }

    public init(limit: Int?, pluginID: String?) {
        self.limit = limit
        self.pluginID = pluginID
    }
}

// MARK: HerdrRequestPluginLogListParams convenience initializers and mutators

public extension HerdrRequestPluginLogListParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPluginLogListParams.self, from: data)
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
        limit: Int?? = nil,
        pluginID: String?? = nil
    ) -> HerdrRequestPluginLogListParams {
        return HerdrRequestPluginLogListParams(
            limit: limit ?? self.limit,
            pluginID: pluginID ?? self.pluginID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPluginPaneCloseParams
public struct HerdrRequestPluginPaneCloseParams: Codable, Sendable {
    public let paneID: PaneID

    public enum CodingKeys: String, CodingKey {
        case paneID = "pane_id"
    }

    public init(paneID: PaneID) {
        self.paneID = paneID
    }
}

// MARK: HerdrRequestPluginPaneCloseParams convenience initializers and mutators

public extension HerdrRequestPluginPaneCloseParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPluginPaneCloseParams.self, from: data)
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
        paneID: PaneID? = nil
    ) -> HerdrRequestPluginPaneCloseParams {
        return HerdrRequestPluginPaneCloseParams(
            paneID: paneID ?? self.paneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPluginPaneFocusParams
public struct HerdrRequestPluginPaneFocusParams: Codable, Sendable {
    public let paneID: PaneID

    public enum CodingKeys: String, CodingKey {
        case paneID = "pane_id"
    }

    public init(paneID: PaneID) {
        self.paneID = paneID
    }
}

// MARK: HerdrRequestPluginPaneFocusParams convenience initializers and mutators

public extension HerdrRequestPluginPaneFocusParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPluginPaneFocusParams.self, from: data)
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
        paneID: PaneID? = nil
    ) -> HerdrRequestPluginPaneFocusParams {
        return HerdrRequestPluginPaneFocusParams(
            paneID: paneID ?? self.paneID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPluginPaneOpenParams
public struct HerdrRequestPluginPaneOpenParams: Codable, Sendable {
    public let cwd: String?
    public let direction: HerdrRequestDirection?
    public let entrypoint: String
    public let env: [String: String]?
    public let focus: Bool?
    public let height: HerdrRequestHeight?
    public let placement: HerdrRequestPluginPanePlacementEnum?
    public let pluginID: String
    public let targetPaneID: PaneID?
    public let width: HerdrRequestHeight?
    public let workspaceID: WorkspaceID?

    public enum CodingKeys: String, CodingKey {
        case cwd = "cwd"
        case direction = "direction"
        case entrypoint = "entrypoint"
        case env = "env"
        case focus = "focus"
        case height = "height"
        case placement = "placement"
        case pluginID = "plugin_id"
        case targetPaneID = "target_pane_id"
        case width = "width"
        case workspaceID = "workspace_id"
    }

    public init(cwd: String?, direction: HerdrRequestDirection?, entrypoint: String, env: [String: String]?, focus: Bool?, height: HerdrRequestHeight?, placement: HerdrRequestPluginPanePlacementEnum?, pluginID: String, targetPaneID: PaneID?, width: HerdrRequestHeight?, workspaceID: WorkspaceID?) {
        self.cwd = cwd
        self.direction = direction
        self.entrypoint = entrypoint
        self.env = env
        self.focus = focus
        self.height = height
        self.placement = placement
        self.pluginID = pluginID
        self.targetPaneID = targetPaneID
        self.width = width
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrRequestPluginPaneOpenParams convenience initializers and mutators

public extension HerdrRequestPluginPaneOpenParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPluginPaneOpenParams.self, from: data)
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
        cwd: String?? = nil,
        direction: HerdrRequestDirection?? = nil,
        entrypoint: String? = nil,
        env: [String: String]?? = nil,
        focus: Bool?? = nil,
        height: HerdrRequestHeight?? = nil,
        placement: HerdrRequestPluginPanePlacementEnum?? = nil,
        pluginID: String? = nil,
        targetPaneID: PaneID?? = nil,
        width: HerdrRequestHeight?? = nil,
        workspaceID: WorkspaceID?? = nil
    ) -> HerdrRequestPluginPaneOpenParams {
        return HerdrRequestPluginPaneOpenParams(
            cwd: cwd ?? self.cwd,
            direction: direction ?? self.direction,
            entrypoint: entrypoint ?? self.entrypoint,
            env: env ?? self.env,
            focus: focus ?? self.focus,
            height: height ?? self.height,
            placement: placement ?? self.placement,
            pluginID: pluginID ?? self.pluginID,
            targetPaneID: targetPaneID ?? self.targetPaneID,
            width: width ?? self.width,
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestHeight: Codable, Sendable {
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
        throw DecodingError.typeMismatch(HerdrRequestHeight.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for HerdrRequestHeight"))
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

public enum HerdrRequestPluginPanePlacementEnum: String, Codable, Sendable {
    case overlay = "overlay"
    case popup = "popup"
    case split = "split"
    case tab = "tab"
    case zoomed = "zoomed"
}

// MARK: - HerdrRequestPluginSetEnabledParams
public struct HerdrRequestPluginSetEnabledParams: Codable, Sendable {
    public let pluginID: String

    public enum CodingKeys: String, CodingKey {
        case pluginID = "plugin_id"
    }

    public init(pluginID: String) {
        self.pluginID = pluginID
    }
}

// MARK: HerdrRequestPluginSetEnabledParams convenience initializers and mutators

public extension HerdrRequestPluginSetEnabledParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPluginSetEnabledParams.self, from: data)
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
        pluginID: String? = nil
    ) -> HerdrRequestPluginSetEnabledParams {
        return HerdrRequestPluginSetEnabledParams(
            pluginID: pluginID ?? self.pluginID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestPluginUnlinkParams
public struct HerdrRequestPluginUnlinkParams: Codable, Sendable {
    public let pluginID: String

    public enum CodingKeys: String, CodingKey {
        case pluginID = "plugin_id"
    }

    public init(pluginID: String) {
        self.pluginID = pluginID
    }
}

// MARK: HerdrRequestPluginUnlinkParams convenience initializers and mutators

public extension HerdrRequestPluginUnlinkParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestPluginUnlinkParams.self, from: data)
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
        pluginID: String? = nil
    ) -> HerdrRequestPluginUnlinkParams {
        return HerdrRequestPluginUnlinkParams(
            pluginID: pluginID ?? self.pluginID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum HerdrRequestPopupSizeUnion: Codable, Sendable {
    case integer(Int)
    case string(String)

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
        throw DecodingError.typeMismatch(HerdrRequestPopupSizeUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for HerdrRequestPopupSizeUnion"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - HerdrRequestServerLiveHandoffParams
public struct HerdrRequestServerLiveHandoffParams: Codable, Sendable {
    public let expectedProtocol: Int?
    public let expectedVersion: String?
    public let importExe: String?

    public enum CodingKeys: String, CodingKey {
        case expectedProtocol = "expected_protocol"
        case expectedVersion = "expected_version"
        case importExe = "import_exe"
    }

    public init(expectedProtocol: Int?, expectedVersion: String?, importExe: String?) {
        self.expectedProtocol = expectedProtocol
        self.expectedVersion = expectedVersion
        self.importExe = importExe
    }
}

// MARK: HerdrRequestServerLiveHandoffParams convenience initializers and mutators

public extension HerdrRequestServerLiveHandoffParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestServerLiveHandoffParams.self, from: data)
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
        expectedProtocol: Int?? = nil,
        expectedVersion: String?? = nil,
        importExe: String?? = nil
    ) -> HerdrRequestServerLiveHandoffParams {
        return HerdrRequestServerLiveHandoffParams(
            expectedProtocol: expectedProtocol ?? self.expectedProtocol,
            expectedVersion: expectedVersion ?? self.expectedVersion,
            importExe: importExe ?? self.importExe
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestTabCreateParams
public struct HerdrRequestTabCreateParams: Codable, Sendable {
    public let cwd: String?
    public let env: [String: String]?
    public let focus: Bool?
    public let label: String?
    public let workspaceID: WorkspaceID?

    public enum CodingKeys: String, CodingKey {
        case cwd = "cwd"
        case env = "env"
        case focus = "focus"
        case label = "label"
        case workspaceID = "workspace_id"
    }

    public init(cwd: String?, env: [String: String]?, focus: Bool?, label: String?, workspaceID: WorkspaceID?) {
        self.cwd = cwd
        self.env = env
        self.focus = focus
        self.label = label
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrRequestTabCreateParams convenience initializers and mutators

public extension HerdrRequestTabCreateParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestTabCreateParams.self, from: data)
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
        cwd: String?? = nil,
        env: [String: String]?? = nil,
        focus: Bool?? = nil,
        label: String?? = nil,
        workspaceID: WorkspaceID?? = nil
    ) -> HerdrRequestTabCreateParams {
        return HerdrRequestTabCreateParams(
            cwd: cwd ?? self.cwd,
            env: env ?? self.env,
            focus: focus ?? self.focus,
            label: label ?? self.label,
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestTabListParams
public struct HerdrRequestTabListParams: Codable, Sendable {
    public let workspaceID: WorkspaceID?

    public enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
    }

    public init(workspaceID: WorkspaceID?) {
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrRequestTabListParams convenience initializers and mutators

public extension HerdrRequestTabListParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestTabListParams.self, from: data)
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
        workspaceID: WorkspaceID?? = nil
    ) -> HerdrRequestTabListParams {
        return HerdrRequestTabListParams(
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestTabMoveParams
public struct HerdrRequestTabMoveParams: Codable, Sendable {
    public let insertIndex: Int
    public let tabID: TabID

    public enum CodingKeys: String, CodingKey {
        case insertIndex = "insert_index"
        case tabID = "tab_id"
    }

    public init(insertIndex: Int, tabID: TabID) {
        self.insertIndex = insertIndex
        self.tabID = tabID
    }
}

// MARK: HerdrRequestTabMoveParams convenience initializers and mutators

public extension HerdrRequestTabMoveParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestTabMoveParams.self, from: data)
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
        insertIndex: Int? = nil,
        tabID: TabID? = nil
    ) -> HerdrRequestTabMoveParams {
        return HerdrRequestTabMoveParams(
            insertIndex: insertIndex ?? self.insertIndex,
            tabID: tabID ?? self.tabID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestTabRenameParams
public struct HerdrRequestTabRenameParams: Codable, Sendable {
    public let label: String
    public let tabID: TabID

    public enum CodingKeys: String, CodingKey {
        case label = "label"
        case tabID = "tab_id"
    }

    public init(label: String, tabID: TabID) {
        self.label = label
        self.tabID = tabID
    }
}

// MARK: HerdrRequestTabRenameParams convenience initializers and mutators

public extension HerdrRequestTabRenameParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestTabRenameParams.self, from: data)
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
        label: String? = nil,
        tabID: TabID? = nil
    ) -> HerdrRequestTabRenameParams {
        return HerdrRequestTabRenameParams(
            label: label ?? self.label,
            tabID: tabID ?? self.tabID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestTabTarget
public struct HerdrRequestTabTarget: Codable, Sendable {
    public let tabID: TabID

    public enum CodingKeys: String, CodingKey {
        case tabID = "tab_id"
    }

    public init(tabID: TabID) {
        self.tabID = tabID
    }
}

// MARK: HerdrRequestTabTarget convenience initializers and mutators

public extension HerdrRequestTabTarget {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestTabTarget.self, from: data)
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
        tabID: TabID? = nil
    ) -> HerdrRequestTabTarget {
        return HerdrRequestTabTarget(
            tabID: tabID ?? self.tabID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestWorkspaceCreateParams
public struct HerdrRequestWorkspaceCreateParams: Codable, Sendable {
    public let cwd: String?
    public let env: [String: String]?
    public let focus: Bool?
    public let label: String?

    public enum CodingKeys: String, CodingKey {
        case cwd = "cwd"
        case env = "env"
        case focus = "focus"
        case label = "label"
    }

    public init(cwd: String?, env: [String: String]?, focus: Bool?, label: String?) {
        self.cwd = cwd
        self.env = env
        self.focus = focus
        self.label = label
    }
}

// MARK: HerdrRequestWorkspaceCreateParams convenience initializers and mutators

public extension HerdrRequestWorkspaceCreateParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestWorkspaceCreateParams.self, from: data)
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
        cwd: String?? = nil,
        env: [String: String]?? = nil,
        focus: Bool?? = nil,
        label: String?? = nil
    ) -> HerdrRequestWorkspaceCreateParams {
        return HerdrRequestWorkspaceCreateParams(
            cwd: cwd ?? self.cwd,
            env: env ?? self.env,
            focus: focus ?? self.focus,
            label: label ?? self.label
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestWorkspaceMoveBlockParams
public struct HerdrRequestWorkspaceMoveBlockParams: Codable, Sendable {
    public let beforeWorkspaceID: WorkspaceID?
    public let workspaceIDS: [String]

    public enum CodingKeys: String, CodingKey {
        case beforeWorkspaceID = "before_workspace_id"
        case workspaceIDS = "workspace_ids"
    }

    public init(beforeWorkspaceID: WorkspaceID?, workspaceIDS: [String]) {
        self.beforeWorkspaceID = beforeWorkspaceID
        self.workspaceIDS = workspaceIDS
    }
}

// MARK: HerdrRequestWorkspaceMoveBlockParams convenience initializers and mutators

public extension HerdrRequestWorkspaceMoveBlockParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestWorkspaceMoveBlockParams.self, from: data)
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
        beforeWorkspaceID: WorkspaceID?? = nil,
        workspaceIDS: [String]? = nil
    ) -> HerdrRequestWorkspaceMoveBlockParams {
        return HerdrRequestWorkspaceMoveBlockParams(
            beforeWorkspaceID: beforeWorkspaceID ?? self.beforeWorkspaceID,
            workspaceIDS: workspaceIDS ?? self.workspaceIDS
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestWorkspaceMoveParams
public struct HerdrRequestWorkspaceMoveParams: Codable, Sendable {
    public let insertIndex: Int
    public let workspaceID: WorkspaceID

    public enum CodingKeys: String, CodingKey {
        case insertIndex = "insert_index"
        case workspaceID = "workspace_id"
    }

    public init(insertIndex: Int, workspaceID: WorkspaceID) {
        self.insertIndex = insertIndex
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrRequestWorkspaceMoveParams convenience initializers and mutators

public extension HerdrRequestWorkspaceMoveParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestWorkspaceMoveParams.self, from: data)
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
        insertIndex: Int? = nil,
        workspaceID: WorkspaceID? = nil
    ) -> HerdrRequestWorkspaceMoveParams {
        return HerdrRequestWorkspaceMoveParams(
            insertIndex: insertIndex ?? self.insertIndex,
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestWorkspaceRenameParams
public struct HerdrRequestWorkspaceRenameParams: Codable, Sendable {
    public let label: String
    public let workspaceID: WorkspaceID

    public enum CodingKeys: String, CodingKey {
        case label = "label"
        case workspaceID = "workspace_id"
    }

    public init(label: String, workspaceID: WorkspaceID) {
        self.label = label
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrRequestWorkspaceRenameParams convenience initializers and mutators

public extension HerdrRequestWorkspaceRenameParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestWorkspaceRenameParams.self, from: data)
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
        label: String? = nil,
        workspaceID: WorkspaceID? = nil
    ) -> HerdrRequestWorkspaceRenameParams {
        return HerdrRequestWorkspaceRenameParams(
            label: label ?? self.label,
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestWorkspaceReportMetadataParams
public struct HerdrRequestWorkspaceReportMetadataParams: Codable, Sendable {
    public let seq: Int?
    public let source: String
    public let tokens: [String: String?]
    public let ttlMS: Int?
    public let workspaceID: WorkspaceID

    public enum CodingKeys: String, CodingKey {
        case seq = "seq"
        case source = "source"
        case tokens = "tokens"
        case ttlMS = "ttl_ms"
        case workspaceID = "workspace_id"
    }

    public init(seq: Int?, source: String, tokens: [String: String?], ttlMS: Int?, workspaceID: WorkspaceID) {
        self.seq = seq
        self.source = source
        self.tokens = tokens
        self.ttlMS = ttlMS
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrRequestWorkspaceReportMetadataParams convenience initializers and mutators

public extension HerdrRequestWorkspaceReportMetadataParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestWorkspaceReportMetadataParams.self, from: data)
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
        seq: Int?? = nil,
        source: String? = nil,
        tokens: [String: String?]? = nil,
        ttlMS: Int?? = nil,
        workspaceID: WorkspaceID? = nil
    ) -> HerdrRequestWorkspaceReportMetadataParams {
        return HerdrRequestWorkspaceReportMetadataParams(
            seq: seq ?? self.seq,
            source: source ?? self.source,
            tokens: tokens ?? self.tokens,
            ttlMS: ttlMS ?? self.ttlMS,
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestWorkspaceTarget
public struct HerdrRequestWorkspaceTarget: Codable, Sendable {
    public let workspaceID: WorkspaceID

    public enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
    }

    public init(workspaceID: WorkspaceID) {
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrRequestWorkspaceTarget convenience initializers and mutators

public extension HerdrRequestWorkspaceTarget {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestWorkspaceTarget.self, from: data)
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
        workspaceID: WorkspaceID? = nil
    ) -> HerdrRequestWorkspaceTarget {
        return HerdrRequestWorkspaceTarget(
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestWorktreeCreateParams
public struct HerdrRequestWorktreeCreateParams: Codable, Sendable {
    public let base: String?
    public let branch: String?
    public let cwd: String?
    public let focus: Bool?
    public let label: String?
    public let path: String?
    public let workspaceID: WorkspaceID?

    public enum CodingKeys: String, CodingKey {
        case base = "base"
        case branch = "branch"
        case cwd = "cwd"
        case focus = "focus"
        case label = "label"
        case path = "path"
        case workspaceID = "workspace_id"
    }

    public init(base: String?, branch: String?, cwd: String?, focus: Bool?, label: String?, path: String?, workspaceID: WorkspaceID?) {
        self.base = base
        self.branch = branch
        self.cwd = cwd
        self.focus = focus
        self.label = label
        self.path = path
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrRequestWorktreeCreateParams convenience initializers and mutators

public extension HerdrRequestWorktreeCreateParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestWorktreeCreateParams.self, from: data)
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
        base: String?? = nil,
        branch: String?? = nil,
        cwd: String?? = nil,
        focus: Bool?? = nil,
        label: String?? = nil,
        path: String?? = nil,
        workspaceID: WorkspaceID?? = nil
    ) -> HerdrRequestWorktreeCreateParams {
        return HerdrRequestWorktreeCreateParams(
            base: base ?? self.base,
            branch: branch ?? self.branch,
            cwd: cwd ?? self.cwd,
            focus: focus ?? self.focus,
            label: label ?? self.label,
            path: path ?? self.path,
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestWorktreeListParams
public struct HerdrRequestWorktreeListParams: Codable, Sendable {
    public let cwd: String?
    public let workspaceID: WorkspaceID?

    public enum CodingKeys: String, CodingKey {
        case cwd = "cwd"
        case workspaceID = "workspace_id"
    }

    public init(cwd: String?, workspaceID: WorkspaceID?) {
        self.cwd = cwd
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrRequestWorktreeListParams convenience initializers and mutators

public extension HerdrRequestWorktreeListParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestWorktreeListParams.self, from: data)
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
        cwd: String?? = nil,
        workspaceID: WorkspaceID?? = nil
    ) -> HerdrRequestWorktreeListParams {
        return HerdrRequestWorktreeListParams(
            cwd: cwd ?? self.cwd,
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestWorktreeOpenParams
public struct HerdrRequestWorktreeOpenParams: Codable, Sendable {
    public let branch: String?
    public let cwd: String?
    public let focus: Bool?
    public let label: String?
    public let path: String?
    public let workspaceID: WorkspaceID?

    public enum CodingKeys: String, CodingKey {
        case branch = "branch"
        case cwd = "cwd"
        case focus = "focus"
        case label = "label"
        case path = "path"
        case workspaceID = "workspace_id"
    }

    public init(branch: String?, cwd: String?, focus: Bool?, label: String?, path: String?, workspaceID: WorkspaceID?) {
        self.branch = branch
        self.cwd = cwd
        self.focus = focus
        self.label = label
        self.path = path
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrRequestWorktreeOpenParams convenience initializers and mutators

public extension HerdrRequestWorktreeOpenParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestWorktreeOpenParams.self, from: data)
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
        cwd: String?? = nil,
        focus: Bool?? = nil,
        label: String?? = nil,
        path: String?? = nil,
        workspaceID: WorkspaceID?? = nil
    ) -> HerdrRequestWorktreeOpenParams {
        return HerdrRequestWorktreeOpenParams(
            branch: branch ?? self.branch,
            cwd: cwd ?? self.cwd,
            focus: focus ?? self.focus,
            label: label ?? self.label,
            path: path ?? self.path,
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - HerdrRequestWorktreeRemoveParams
public struct HerdrRequestWorktreeRemoveParams: Codable, Sendable {
    public let force: Bool?
    public let workspaceID: WorkspaceID

    public enum CodingKeys: String, CodingKey {
        case force = "force"
        case workspaceID = "workspace_id"
    }

    public init(force: Bool?, workspaceID: WorkspaceID) {
        self.force = force
        self.workspaceID = workspaceID
    }
}

// MARK: HerdrRequestWorktreeRemoveParams convenience initializers and mutators

public extension HerdrRequestWorktreeRemoveParams {
    init(data: Data) throws {
        self = try newHerdrRequestJSONDecoder().decode(HerdrRequestWorktreeRemoveParams.self, from: data)
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
        force: Bool?? = nil,
        workspaceID: WorkspaceID? = nil
    ) -> HerdrRequestWorktreeRemoveParams {
        return HerdrRequestWorktreeRemoveParams(
            force: force ?? self.force,
            workspaceID: workspaceID ?? self.workspaceID
        )
    }

    func jsonData() throws -> Data {
        return try newHerdrRequestJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newHerdrRequestJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newHerdrRequestJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
