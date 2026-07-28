import AppKit
import Foundation
import SheepApplication
import SheepDomain
@testable import sheep
import XCTest

@MainActor
final class AppKitStructureTests: XCTestCase {
    func testPaletteUsesAdaptiveSystemColors() {
        XCTAssertEqual(Palette.terminal, .textBackgroundColor)
        XCTAssertEqual(Palette.selected, .selectedContentBackgroundColor)
        XCTAssertEqual(Palette.idle, .systemTeal)
        XCTAssertEqual(Palette.working, .systemYellow)
        XCTAssertEqual(Palette.warning, .systemOrange)
        XCTAssertEqual(Palette.blocked, .systemPink)
        XCTAssertEqual(Palette.error, .systemRed)
    }

    func testGhosttyGeometrySeparatesResizeFromDisplayAndScaleChanges() {
        var geometry = GhosttySurfaceGeometryState()
        let initialSize = GhosttySurfacePixelSize(width: 1_600, height: 1_200)

        XCTAssertTrue(geometry.recordContentScale(x: 2, y: 2))
        XCTAssertTrue(geometry.recordDisplayID(42))
        XCTAssertTrue(geometry.recordPixelSize(initialSize))

        XCTAssertFalse(geometry.recordContentScale(x: 2, y: 2))
        XCTAssertFalse(geometry.recordDisplayID(42))
        XCTAssertFalse(geometry.recordPixelSize(initialSize))

        XCTAssertTrue(
            geometry.recordPixelSize(
                GhosttySurfacePixelSize(width: 1_500, height: 1_200)
            )
        )
        XCTAssertFalse(geometry.recordContentScale(x: 2, y: 2))
        XCTAssertFalse(geometry.recordDisplayID(42))

        XCTAssertTrue(geometry.recordContentScale(x: 1, y: 1))
        XCTAssertTrue(geometry.recordDisplayID(7))
    }

    func testSidebarTabsNestedSplitsAndAccessibilityLabels() async throws {
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
                update: SessionUpdate(connection: .connected, session: session),
                layout: layout,
                recorder: recorder
            ),
            gitStatus: StubGitStatus()
        )
        let controller = MainSplitViewController(
            model: model,
            ghosttyRuntime: nil,
            herdrExecutable: nil
        )
        controller.loadView()
        controller.viewDidLoad()
        try await Task.sleep(for: .milliseconds(100))

        let labels = allSubviews(in: controller.view).compactMap { $0.accessibilityLabel() }
        XCTAssertTrue(labels.contains("Spaces"))
        XCTAssertTrue(labels.contains("Agents grouped by space"))
        XCTAssertFalse(labels.contains("Create space"))
        XCTAssertFalse(labels.contains("Collapse sidebar"))
        XCTAssertTrue(labels.contains("Tab 1"))
        XCTAssertFalse(labels.contains("Tab other"))

        XCTAssertEqual(controller.splitViewItems.first?.behavior, .sidebar)
        let visualEffects: [NSVisualEffectView] = allSubviews(in: controller.view)
        XCTAssertTrue(visualEffects.contains { $0.material == .sidebar })
        XCTAssertTrue(visualEffects.contains {
            $0.material == .contentBackground
                && $0.blendingMode == .behindWindow
                && $0.state == .followsWindowActiveState
        })
        let toolbar = MainWindowToolbar(splitView: controller.splitView)
        XCTAssertEqual(
            toolbar.toolbar.items.map(\.itemIdentifier),
            MainWindowToolbar.itemIdentifiers
        )
        XCTAssertEqual(toolbar.toolbar.items[1].itemIdentifier, .toggleSidebar)
        XCTAssertEqual(toolbar.toolbar.items[2].itemIdentifier, .space)
        XCTAssertTrue(toolbar.toolbar.items[3] is NSTrackingSeparatorToolbarItem)

        let textFields: [NSTextField] = allSubviews(in: controller.view)
        let buttons: [NSButton] = allSubviews(in: controller.view)
        XCTAssertTrue(textFields.contains { $0.stringValue == "GROUPED" })
        XCTAssertFalse(buttons.contains { $0.title == "New" })
        XCTAssertTrue(
            textFields
                .filter { $0.stringValue == "sheep" || $0.stringValue == "codex" }
                .allSatisfy { $0.alignment == .left }
        )
        let nativeFonts = (textFields.compactMap(\.font) + buttons.compactMap(\.font))
        XCTAssertFalse(nativeFonts.contains {
            $0.fontDescriptor.symbolicTraits.contains(.monoSpace)
        })

        let tables: [NSTableView] = allSubviews(in: controller.view)
        XCTAssertTrue(tables.allSatisfy {
            $0.tableColumns.first?.resizingMask.contains(.autoresizingMask) == true
        })

        let splitViews: [NSSplitView] = allSubviews(in: controller.view)
        XCTAssertGreaterThanOrEqual(splitViews.count, 3)
        let terminalSplits: [TerminalCardSplitView] = allSubviews(in: controller.view)
        XCTAssertEqual(terminalSplits.count, 2)
        XCTAssertTrue(terminalSplits.allSatisfy {
            $0.dividerThickness == TerminalCardSplitView.gutter
        })

        let terminalCards: [TerminalCardView] = allSubviews(in: controller.view)
        XCTAssertEqual(terminalCards.count, 3)
        XCTAssertTrue(terminalCards.allSatisfy {
            $0.layer?.cornerRadius == TerminalCardView.cornerRadius
                && $0.layer?.masksToBounds == true
                && $0.layer?.borderWidth == 1
        })
        XCTAssertTrue(terminalCards.allSatisfy { card in
            guard let terminal = card.subviews.first else { return false }
            let edgeConstraints = card.constraints.filter {
                ($0.firstItem as? NSView) === terminal
                    || ($0.secondItem as? NSView) === terminal
            }
            return edgeConstraints.count == 4
                && edgeConstraints.allSatisfy { $0.constant == 0 }
        })
        let cardLabels = terminalCards.compactMap { $0.accessibilityLabel() }
        XCTAssertEqual(
            Set(cardLabels),
            Set(["Terminal card w1:p1", "Terminal card w1:p2", "Terminal card w1:p3"])
        )

        let outlines: [NSOutlineView] = allSubviews(in: controller.view)
        XCTAssertEqual(outlines.first?.numberOfRows, 3)
        XCTAssertEqual(recorder.focusCount, 0)
    }

    func testDisconnectedSessionRetainsContentAndShowsBanner() async throws {
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
                update: SessionUpdate(
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
            herdrExecutable: nil
        )
        controller.loadView()
        controller.viewDidLoad()
        try await Task.sleep(for: .milliseconds(100))

        let fields: [NSTextField] = allSubviews(in: controller.view)
        XCTAssertTrue(fields.contains {
            $0.stringValue.contains("Disconnected")
                && $0.stringValue.contains("socket closed")
        })
        XCTAssertTrue(fields.contains { $0.stringValue == "Terminal unavailable" })
    }

    private static func session() throws -> HerdrSession {
        let json = """
        {
          "version": "0.7.5", "protocol": 17,
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
}

private struct StubRepository: HerdrSessionRepository {
    let update: SessionUpdate
    let layout: PaneLayout
    let recorder: CommandRecorder

    func observeSession() async -> AsyncStream<SessionUpdate> {
        AsyncStream { continuation in
            continuation.yield(update)
        }
    }

    func refresh() async {}
    func focusWorkspace(_ id: WorkspaceID) async throws { recorder.recordFocus() }
    func focusTab(_ id: TabID) async throws {}
    func focusPane(_ id: PaneID) async throws { recorder.recordFocus() }
    func createWorkspace(cwd: URL) async throws {}
    func createTab(workspaceID: WorkspaceID) async throws {}
    func exportLayout(tabID: TabID) async throws -> PaneLayout { layout }
    func setSplitRatio(tabID: TabID, path: [Bool], ratio: Double) async throws {}
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
