import AppKit
import Foundation
import HerdrSDK
@testable import sheep
import Testing

@MainActor
@Suite(.serialized)
struct AppKitIntegrationTests {
    @Test
    func sidebarTabsNestedSplitsAndAccessibilityLabels() async throws {
        let session = try Self.session()
        let layout = PaneLayout(
            workspaceID: WorkspaceID(rawValue: "w1"),
            tabID: TabID(rawValue: "w1:t1"),
            zoomed: false,
            focusedPaneID: PaneID(rawValue: "w1:p1"),
            root: .split(
                direction: .right,
                ratio: 0.55,
                first: .pane(PaneID(rawValue: "w1:p1")),
                second: .split(
                    direction: .down,
                    ratio: 0.4,
                    first: .pane(PaneID(rawValue: "w1:p2")),
                    second: .pane(PaneID(rawValue: "w1:p3"))
                )
            )
        )
        let recorder = CommandRecorder()
        let model = AppModel(
            repository: StubRepository(
                update: HerdrSessionUpdate(connection: .connected, session: session),
                layout: layout,
                recorder: recorder
            ),
            gitStatus: StubGitStatus()
        )
        let controller = MainSplitViewController(
            model: model,
            ghosttyRuntime: nil,
            terminalAttachments: nil
        )
        controller.loadView()
        controller.viewDidLoad()
        try await Task.sleep(for: .milliseconds(100))

        let labels = allSubviews(in: controller.view).compactMap { $0.accessibilityLabel() }
        #expect(labels.contains("Spaces"))
        #expect(labels.contains("Agents grouped by space"))
        #expect(!labels.contains("Create space"))
        #expect(!labels.contains("Collapse sidebar"))
        #expect(!labels.contains("Tab 1"))
        #expect(!labels.contains("New tab"))

        #expect(controller.splitViewItems.first?.behavior == .sidebar)
        let visualEffects: [NSVisualEffectView] = allSubviews(in: controller.view)
        #expect(visualEffects.contains { $0.material == .sidebar })
        #expect(visualEffects.contains {
            $0.material == .contentBackground
                && $0.blendingMode == .behindWindow
                && $0.state == .followsWindowActiveState
        })
        let toolbar = MainWindowToolbar(splitView: controller.splitView)
        #expect(
            toolbar.toolbar.items.map(\.itemIdentifier)
                == MainWindowToolbar.itemIdentifiers
        )
        #expect(toolbar.toolbar.items[1].itemIdentifier == .toggleSidebar)
        #expect(toolbar.toolbar.items[2].itemIdentifier == .space)
        #expect(toolbar.toolbar.items[3] is NSTrackingSeparatorToolbarItem)

        let textFields: [NSTextField] = allSubviews(in: controller.view)
        let buttons: [NSButton] = allSubviews(in: controller.view)
        #expect(textFields.contains { $0.stringValue == "GROUPED" })
        #expect(!buttons.contains { $0.title == "New" })
        #expect(
            textFields
                .filter { $0.stringValue == "sheep" || $0.stringValue == "codex" }
                .allSatisfy { $0.alignment == .left }
        )
        let nativeFonts = (textFields.compactMap(\.font) + buttons.compactMap(\.font))
        #expect(!nativeFonts.contains {
            $0.fontDescriptor.symbolicTraits.contains(.monoSpace)
        })

        let tables: [NSTableView] = allSubviews(in: controller.view)
        #expect(tables.allSatisfy {
            $0.tableColumns.first?.resizingMask.contains(.autoresizingMask) == true
        })

        let splitViews: [NSSplitView] = allSubviews(in: controller.view)
        #expect(splitViews.count >= 3)
        let terminalSplits: [TerminalCardSplitView] = allSubviews(in: controller.view)
        #expect(terminalSplits.count == 2)
        #expect(terminalSplits.allSatisfy {
            $0.dividerThickness == TerminalCardSplitView.gutter
        })

        let terminalCards: [TerminalCardView] = allSubviews(in: controller.view)
        #expect(terminalCards.count == 3)
        #expect(terminalCards.allSatisfy {
            $0.layer?.cornerRadius == TerminalCardView.cornerRadius
                && $0.layer?.masksToBounds == true
                && $0.layer?.borderWidth == 1
        })
        #expect(terminalCards.allSatisfy { card in
            guard let terminal = card.contentView else { return false }
            let edgeConstraints = card.constraints.filter {
                ($0.firstItem as? NSView) === terminal
                    || ($0.secondItem as? NSView) === terminal
            }
            return edgeConstraints.count == 4
                && edgeConstraints.allSatisfy { $0.constant == 0 }
        })
        let cardLabels = terminalCards.compactMap { $0.accessibilityLabel() }
        #expect(
            Set(cardLabels)
                == Set(["Terminal card w1:p1", "Terminal card w1:p2", "Terminal card w1:p3"])
        )
        let focusedCard = try #require(terminalCard(paneID: "w1:p1", in: controller.view))
        let firstUnfocusedCard = try #require(
            terminalCard(paneID: "w1:p2", in: controller.view)
        )
        let secondUnfocusedCard = try #require(
            terminalCard(paneID: "w1:p3", in: controller.view)
        )
        #expect(!focusedCard.isDimmed)
        #expect(firstUnfocusedCard.isDimmed)
        #expect(secondUnfocusedCard.isDimmed)
        #expect(TerminalCardView.unfocusedOverlayOpacity == 0.3)

        let outlines: [NSOutlineView] = allSubviews(in: controller.view)
        #expect(outlines.first?.numberOfRows == 3)
        #expect(recorder.focusCount == 0)
    }

    @Test
    func disconnectedSessionRetainsContentAndShowsBanner() async throws {
        let session = try Self.session()
        let layout = PaneLayout(
            workspaceID: WorkspaceID(rawValue: "w1"),
            tabID: TabID(rawValue: "w1:t1"),
            zoomed: true,
            focusedPaneID: PaneID(rawValue: "w1:p1"),
            root: .pane(PaneID(rawValue: "w1:p1"))
        )
        let recorder = CommandRecorder()
        let model = AppModel(
            repository: StubRepository(
                update: HerdrSessionUpdate(
                    connection: .disconnected("socket closed"),
                    session: session
                ),
                layout: layout,
                recorder: recorder
            ),
            gitStatus: StubGitStatus()
        )
        let controller = MainSplitViewController(
            model: model,
            ghosttyRuntime: nil,
            terminalAttachments: nil
        )
        controller.loadView()
        controller.viewDidLoad()
        try await Task.sleep(for: .milliseconds(100))

        let fields: [NSTextField] = allSubviews(in: controller.view)
        #expect(fields.contains {
            $0.stringValue.contains("Disconnected")
                && $0.stringValue.contains("socket closed")
        })
        #expect(fields.contains { $0.stringValue == "Terminal unavailable" })
    }

    @Test
    func switchingTabsPreservesRenderedTerminalTreesUntilTabsClose() async throws {
        let firstTabID = TabID(rawValue: "w1:t1")
        let secondTabID = TabID(rawValue: "w1:t2")
        let repository = StreamingRepository(layouts: [
            firstTabID: PaneLayout(
                workspaceID: WorkspaceID(rawValue: "w1"),
                tabID: firstTabID,
                zoomed: false,
                focusedPaneID: PaneID(rawValue: "w1:p1"),
                root: .pane(PaneID(rawValue: "w1:p1"))
            ),
            secondTabID: PaneLayout(
                workspaceID: WorkspaceID(rawValue: "w1"),
                tabID: secondTabID,
                zoomed: false,
                focusedPaneID: PaneID(rawValue: "w1:p4"),
                root: .pane(PaneID(rawValue: "w1:p4"))
            ),
        ])
        let model = AppModel(repository: repository, gitStatus: StubGitStatus())
        let controller = MainSplitViewController(
            model: model,
            ghosttyRuntime: nil,
            terminalAttachments: nil
        )
        controller.loadView()
        controller.viewDidLoad()

        repository.yield(HerdrSessionUpdate(
            connection: .connected,
            session: try Self.twoTabSession(focusedTabID: firstTabID)
        ))
        try await Task.sleep(for: .milliseconds(50))
        let firstCard = try #require(
            terminalCard(paneID: "w1:p1", in: controller.view)
        )
        #expect(!firstCard.isHiddenOrHasHiddenAncestor)
        #expect(!firstCard.isDimmed)

        repository.yield(HerdrSessionUpdate(
            connection: .connected,
            session: try Self.twoTabSession(focusedTabID: secondTabID)
        ))
        try await Task.sleep(for: .milliseconds(50))
        let secondCard = try #require(
            terminalCard(paneID: "w1:p4", in: controller.view)
        )
        #expect(firstCard.isHiddenOrHasHiddenAncestor)
        #expect(!secondCard.isHiddenOrHasHiddenAncestor)
        #expect(!firstCard.isDimmed)
        #expect(!secondCard.isDimmed)

        repository.yield(HerdrSessionUpdate(
            connection: .connected,
            session: try Self.twoTabSession(focusedTabID: firstTabID)
        ))
        try await Task.sleep(for: .milliseconds(50))
        let restoredFirstCard = try #require(
            terminalCard(paneID: "w1:p1", in: controller.view)
        )
        #expect(restoredFirstCard === firstCard)
        #expect(!restoredFirstCard.isHiddenOrHasHiddenAncestor)
        #expect(secondCard.isHiddenOrHasHiddenAncestor)

        repository.yield(HerdrSessionUpdate(
            connection: .connected,
            session: try Self.session()
        ))
        try await Task.sleep(for: .milliseconds(50))
        #expect(terminalCard(paneID: "w1:p4", in: controller.view) == nil)
    }

    @Test
    func splitDragKeepsLocalRatioAcrossStaleLayoutsAndLateAcknowledgements() async throws {
        let tabID = TabID(rawValue: "w1:t1")
        let staleLayout = PaneLayout(
            workspaceID: WorkspaceID(rawValue: "w1"),
            tabID: tabID,
            zoomed: false,
            focusedPaneID: PaneID(rawValue: "w1:p1"),
            root: .split(
                direction: .right,
                ratio: 0.5,
                first: .pane(PaneID(rawValue: "w1:p1")),
                second: .pane(PaneID(rawValue: "w1:p2"))
            )
        )
        let repository = RatioRaceRepository(
            update: HerdrSessionUpdate(connection: .connected, session: try Self.session()),
            layout: staleLayout
        )
        let model = AppModel(repository: repository, gitStatus: StubGitStatus())
        let controller = MainSplitViewController(
            model: model,
            ghosttyRuntime: nil,
            terminalAttachments: nil
        )
        controller.loadView()
        controller.viewDidLoad()
        let window = NSWindow(contentViewController: controller)
        window.setContentSize(NSSize(width: 1_200, height: 800))
        window.contentView?.layoutSubtreeIfNeeded()
        try await Task.sleep(for: .milliseconds(100))
        window.contentView?.layoutSubtreeIfNeeded()

        let originalSplit = try #require(
            (allSubviews(in: controller.view) as [TerminalCardSplitView]).first
        )
        let originalCards: [TerminalCardView] = allSubviews(in: controller.view)
        #expect(originalCards.count == 2)

        drag(originalSplit, to: 0.6)
        model.onLayout?(.success(staleLayout))
        controller.view.layoutSubtreeIfNeeded()
        #expect(
            (allSubviews(in: controller.view) as [TerminalCardSplitView]).first
                === originalSplit
        )
        #expect(abs(dividerCenterRatio(in: originalSplit) - 0.6) < 0.02)

        // Allow the first write to start, then supersede it before its delayed
        // acknowledgement returns.
        try await Task.sleep(for: .milliseconds(300))
        drag(originalSplit, to: 0.75)
        model.onLayout?(.success(staleLayout))
        controller.view.layoutSubtreeIfNeeded()
        #expect(abs(dividerCenterRatio(in: originalSplit) - 0.75) < 0.02)

        try await Task.sleep(for: .milliseconds(400))
        controller.view.layoutSubtreeIfNeeded()
        let finalSplit = try #require(
            (allSubviews(in: controller.view) as [TerminalCardSplitView]).first
        )
        let finalCards: [TerminalCardView] = allSubviews(in: controller.view)
        #expect(finalSplit === originalSplit)
        #expect(zip(finalCards, originalCards).allSatisfy { pair in
            pair.0 === pair.1
        })
        #expect(abs(dividerCenterRatio(in: finalSplit) - 0.75) < 0.02)
        #expect(repository.recordedRatios.count == 2)
    }

    @Test
    func terminalResizeIndicatorUsesGhosttyGridFormatAndTiming() async throws {
        let card = TerminalCardView()
        card.frame = NSRect(x: 0, y: 0, width: 300, height: 200)
        card.showResizeIndicator(columns: 120, rows: 42)
        card.layoutSubtreeIfNeeded()

        #expect(card.isResizeIndicatorVisible)
        #expect(card.resizeIndicatorText == "120 ⨯ 42")
        #expect(card.resizeIndicatorCornerRadius > 0)
        #expect(TerminalCardView.resizeIndicatorFadeInDuration > 0)
        #expect(TerminalCardView.resizeIndicatorFadeOutDuration == 0.1)
        if #available(macOS 26.0, *) {
            #expect(card.resizeIndicatorUsesLiquidGlass)
        } else {
            #expect(!card.resizeIndicatorUsesLiquidGlass)
        }

        try await Task.sleep(for: .milliseconds(1_050))
        #expect(!card.isResizeIndicatorVisible)
    }

    @Test
    func workspaceTabsUseNativeAppKitWindowTabGroups() async throws {
        let firstTabID = TabID(rawValue: "w1:t1")
        let secondTabID = TabID(rawValue: "w1:t2")
        let repository = StreamingRepository(layouts: [
            firstTabID: PaneLayout(
                workspaceID: WorkspaceID(rawValue: "w1"),
                tabID: firstTabID,
                zoomed: false,
                focusedPaneID: PaneID(rawValue: "w1:p1"),
                root: .pane(PaneID(rawValue: "w1:p1"))
            ),
            secondTabID: PaneLayout(
                workspaceID: WorkspaceID(rawValue: "w1"),
                tabID: secondTabID,
                zoomed: false,
                focusedPaneID: PaneID(rawValue: "w1:p4"),
                root: .pane(PaneID(rawValue: "w1:p4"))
            ),
        ])
        let model = AppModel(repository: repository, gitStatus: StubGitStatus())
        let coordinator = WorkspaceTabCoordinator(
            model: model,
            ghosttyRuntime: nil,
            terminalAttachments: nil
        )
        defer { coordinator.shutdown() }
        coordinator.start(showWindow: false)

        repository.yield(HerdrSessionUpdate(
            connection: .connected,
            session: try Self.twoTabSession(focusedTabID: firstTabID)
        ))
        try await Task.sleep(for: .milliseconds(100))

        #expect(coordinator.nativeTabCount == 2)
        #expect(coordinator.nativeTabTitles == ["one", "two"])
        #expect(coordinator.selectedWindow?.tabbedWindows?.count == 2)
        #expect(coordinator.selectedWindow?.tabbingMode != .disallowed)
        #expect(
            coordinator.selectedWindow?.tabbingIdentifier
                == "com.851labs.sheep.workspace.w1"
        )
        #expect(firstTabID != secondTabID)
    }

    private static func session() throws -> HerdrSession {
        let json = """
        {
          "version": "0.7.5", "protocol": 18,
          "focused_workspace_id": "w1",
          "focused_tab_id": "w1:t1",
          "focused_pane_id": "w1:p1",
          "workspaces": [
            {
              "workspace_id": "w1", "number": 1, "label": "sheep",
              "focused": true, "pane_count": 3, "tab_count": 1,
              "active_tab_id": "w1:t1", "agent_status": "working"
            },
            {
              "workspace_id": "w2", "number": 2, "label": "elsewhere",
              "focused": false, "pane_count": 1, "tab_count": 1,
              "active_tab_id": "w2:t1", "agent_status": "idle"
            }
          ],
          "tabs": [
            {
              "tab_id": "w1:t1", "workspace_id": "w1", "number": 1,
              "label": "1", "focused": true, "pane_count": 3,
              "agent_status": "working"
            },
            {
              "tab_id": "w2:t1", "workspace_id": "w2", "number": 1,
              "label": "other", "focused": false, "pane_count": 1,
              "agent_status": "idle"
            }
          ],
          "panes": [
            {
              "pane_id": "w1:p1", "terminal_id": "term_1",
              "workspace_id": "w1", "tab_id": "w1:t1", "focused": true,
              "cwd": "/tmp", "display_agent": "codex",
              "agent_status": "working", "revision": 1
            },
            {
              "pane_id": "w1:p2", "terminal_id": "term_2",
              "workspace_id": "w1", "tab_id": "w1:t1", "focused": false,
              "cwd": "/tmp", "display_agent": "claude",
              "agent_status": "blocked", "revision": 1
            },
            {
              "pane_id": "w1:p3", "terminal_id": "term_3",
              "workspace_id": "w1", "tab_id": "w1:t1", "focused": false,
              "cwd": "/tmp", "agent_status": "idle", "revision": 1
            }
          ],
          "agents": [
            {
              "terminal_id": "term_1", "agent": "codex",
              "agent_status": "working", "workspace_id": "w1",
              "tab_id": "w1:t1", "pane_id": "w1:p1",
              "focused": true, "cwd": "/tmp", "revision": 1
            },
            {
              "terminal_id": "term_2", "agent": "claude",
              "agent_status": "blocked", "workspace_id": "w1",
              "tab_id": "w1:t1", "pane_id": "w1:p2",
              "focused": false, "cwd": "/tmp", "revision": 1
            }
          ]
        }
        """
        return try JSONDecoder().decode(HerdrSession.self, from: Data(json.utf8))
    }

    private static func twoTabSession(focusedTabID: TabID) throws -> HerdrSession {
        let firstFocused = focusedTabID.rawValue == "w1:t1"
        let json = """
        {
          "version": "0.7.5", "protocol": 18,
          "focused_workspace_id": "w1",
          "focused_tab_id": "\(focusedTabID.rawValue)",
          "focused_pane_id": "\(firstFocused ? "w1:p1" : "w1:p4")",
          "workspaces": [
            {
              "workspace_id": "w1", "number": 1, "label": "sheep",
              "focused": true, "pane_count": 2, "tab_count": 2,
              "active_tab_id": "\(focusedTabID.rawValue)", "agent_status": "working"
            }
          ],
          "tabs": [
            {
              "tab_id": "w1:t1", "workspace_id": "w1", "number": 1,
              "label": "one", "focused": \(firstFocused), "pane_count": 1,
              "agent_status": "working"
            },
            {
              "tab_id": "w1:t2", "workspace_id": "w1", "number": 2,
              "label": "two", "focused": \(!firstFocused), "pane_count": 1,
              "agent_status": "idle"
            }
          ],
          "panes": [
            {
              "pane_id": "w1:p1", "terminal_id": "term_1",
              "workspace_id": "w1", "tab_id": "w1:t1", "focused": \(firstFocused),
              "cwd": "/tmp", "agent_status": "working", "revision": 1
            },
            {
              "pane_id": "w1:p4", "terminal_id": "term_4",
              "workspace_id": "w1", "tab_id": "w1:t2", "focused": \(!firstFocused),
              "cwd": "/tmp", "agent_status": "idle", "revision": 1
            }
          ],
          "agents": []
        }
        """
        return try JSONDecoder().decode(HerdrSession.self, from: Data(json.utf8))
    }

    private func terminalCard(paneID: String, in root: NSView) -> TerminalCardView? {
        let cards: [TerminalCardView] = allSubviews(in: root)
        return cards.first { $0.accessibilityLabel() == "Terminal card \(paneID)" }
    }

    private func allSubviews<T: NSView>(in root: NSView) -> [T] {
        var result: [T] = []
        if let typed = root as? T {
            result.append(typed)
        }
        for subview in root.subviews {
            let descendants: [T] = allSubviews(in: subview)
            result.append(contentsOf: descendants)
        }
        return result
    }

    private func drag(_ split: TerminalCardSplitView, to ratio: CGFloat) {
        let extent = split.isVertical ? split.bounds.width : split.bounds.height
        split.setPosition(
            extent * ratio - split.dividerThickness / 2,
            ofDividerAt: 0
        )
        split.isDraggingDivider = true
        split.delegate?.splitViewDidResizeSubviews?(
            Notification(name: NSSplitView.didResizeSubviewsNotification, object: split)
        )
        split.isDraggingDivider = false
    }

    private func dividerCenterRatio(in split: TerminalCardSplitView) -> CGFloat {
        let extent = split.isVertical ? split.bounds.width : split.bounds.height
        let firstExtent = split.isVertical
            ? split.subviews[0].frame.width
            : split.subviews[0].frame.height
        return (firstExtent + split.dividerThickness / 2) / extent
    }
}

private struct StubRepository: HerdrSessionClient {
    let update: HerdrSessionUpdate
    let layout: PaneLayout
    let recorder: CommandRecorder

    func sessionUpdates() async -> AsyncStream<HerdrSessionUpdate> {
        AsyncStream { continuation in
            continuation.yield(update)
        }
    }

    func refreshSession() async {}
    func focusWorkspace(_ id: WorkspaceID) async throws { recorder.recordFocus() }
    func focusTab(_ id: TabID) async throws {}
    func focusPane(_ id: PaneID) async throws { recorder.recordFocus() }
    func createWorkspace(cwd: URL) async throws {}
    func createTab(workspaceID: WorkspaceID) async throws {}
    func closeTab(_ id: TabID) async throws {}
    func exportLayout(tabID: TabID) async throws -> PaneLayout { layout }
    func setSplitRatio(
        tabID: TabID,
        path: [Bool],
        ratio: Double
    ) async throws -> PaneLayout {
        layout
    }
}

private final class StreamingRepository: HerdrSessionClient, @unchecked Sendable {
    private let stream: AsyncStream<HerdrSessionUpdate>
    private let continuation: AsyncStream<HerdrSessionUpdate>.Continuation
    private let layouts: [TabID: PaneLayout]

    init(layouts: [TabID: PaneLayout]) {
        let (stream, continuation) = AsyncStream<HerdrSessionUpdate>.makeStream()
        self.stream = stream
        self.continuation = continuation
        self.layouts = layouts
    }

    func yield(_ update: HerdrSessionUpdate) {
        continuation.yield(update)
    }

    func sessionUpdates() async -> AsyncStream<HerdrSessionUpdate> { stream }
    func refreshSession() async {}
    func focusWorkspace(_ id: WorkspaceID) async throws {}
    func focusTab(_ id: TabID) async throws {}
    func focusPane(_ id: PaneID) async throws {}
    func createWorkspace(cwd: URL) async throws {}
    func createTab(workspaceID: WorkspaceID) async throws {}
    func closeTab(_ id: TabID) async throws {}

    func exportLayout(tabID: TabID) async throws -> PaneLayout {
        try #require(layouts[tabID])
    }

    func setSplitRatio(
        tabID: TabID,
        path: [Bool],
        ratio: Double
    ) async throws -> PaneLayout {
        try #require(layouts[tabID])
    }
}

private final class RatioRaceRepository: HerdrSessionClient, @unchecked Sendable {
    private let update: HerdrSessionUpdate
    private let layout: PaneLayout
    private let lock = NSLock()
    private var ratios: [Double] = []

    init(update: HerdrSessionUpdate, layout: PaneLayout) {
        self.update = update
        self.layout = layout
    }

    var recordedRatios: [Double] {
        lock.withLock { ratios }
    }

    func sessionUpdates() async -> AsyncStream<HerdrSessionUpdate> {
        AsyncStream { continuation in continuation.yield(update) }
    }

    func refreshSession() async {}
    func focusWorkspace(_ id: WorkspaceID) async throws {}
    func focusTab(_ id: TabID) async throws {}
    func focusPane(_ id: PaneID) async throws {}
    func createWorkspace(cwd: URL) async throws {}
    func createTab(workspaceID: WorkspaceID) async throws {}
    func closeTab(_ id: TabID) async throws {}
    func exportLayout(tabID: TabID) async throws -> PaneLayout { layout }

    func setSplitRatio(
        tabID: TabID,
        path: [Bool],
        ratio: Double
    ) async throws -> PaneLayout {
        lock.withLock { ratios.append(ratio) }
        if ratio < 0.7 {
            try? await Task.sleep(for: .milliseconds(500))
        } else {
            try? await Task.sleep(for: .milliseconds(10))
        }
        guard case let .split(direction, _, first, second) = layout.root else {
            return layout
        }
        return PaneLayout(
            workspaceID: layout.workspaceID,
            tabID: layout.tabID,
            zoomed: layout.zoomed,
            focusedPaneID: layout.focusedPaneID,
            root: .split(
                direction: direction,
                ratio: ratio,
                first: first,
                second: second
            )
        )
    }
}

private final class CommandRecorder: @unchecked Sendable {
    private let lock = NSLock()
    private var storage = 0

    var focusCount: Int {
        lock.withLock { storage }
    }

    func recordFocus() {
        lock.withLock { storage += 1 }
    }
}

private struct StubGitStatus: GitStatusProvider {
    func summary(for directory: URL) async -> GitSummary? { nil }
}
