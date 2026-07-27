import XCTest
@testable import SheepDomain
@testable import SheepApplication

final class DomainTests: XCTestCase {
    func testAgentStatusUrgency() {
        XCTAssertGreaterThan(AgentStatus.blocked.urgency, AgentStatus.working.urgency)
        XCTAssertGreaterThan(AgentStatus.working.urgency, AgentStatus.done.urgency)
    }

    func testGitSummaryDescription() {
        let summary = GitSummary(branch: "main", ahead: 2, behind: 3)
        XCTAssertEqual(summary.compactDescription, "main ↑2 ↓3")
    }

    func testLayoutDecodesHerdrShape() throws {
        let json = """
        {
          "workspace_id": "w1",
          "tab_id": "w1:t1",
          "zoomed": false,
          "focused_pane_id": "w1:p1",
          "root": {
            "type": "split",
            "direction": "right",
            "ratio": 0.6,
            "first": {"type": "pane", "pane_id": "w1:p1"},
            "second": {"type": "pane", "pane_id": "w1:p2"}
          }
        }
        """
        let layout = try JSONDecoder().decode(PaneLayout.self, from: Data(json.utf8))
        XCTAssertEqual(layout.root.paneIDs().map(\.rawValue), ["w1:p1", "w1:p2"])
        XCTAssertEqual(layout.root.leavesWithPaths().map(\.path), [[false], [true]])
    }

    func testProtocol17SnapshotIgnoresUnknownFields() throws {
        let json = """
        {
          "version": "0.7.5",
          "protocol": 17,
          "focused_workspace_id": "w1",
          "focused_tab_id": "w1:t1",
          "focused_pane_id": "w1:p1",
          "workspaces": [{
            "workspace_id": "w1", "number": 1, "label": "sheep",
            "focused": true, "pane_count": 1, "tab_count": 1,
            "active_tab_id": "w1:t1", "agent_status": "idle",
            "future_field": {"is_safe": true}
          }],
          "tabs": [{
            "tab_id": "w1:t1", "workspace_id": "w1", "number": 1,
            "label": "1", "focused": true, "pane_count": 1,
            "agent_status": "idle"
          }],
          "panes": [{
            "pane_id": "w1:p1", "terminal_id": "term_1",
            "workspace_id": "w1", "tab_id": "w1:t1", "focused": true,
            "cwd": "/tmp", "agent_status": "idle", "revision": 3,
            "scroll": {"offset_from_bottom": 0}
          }],
          "agents": [{
            "terminal_id": "term_1", "agent": "codex", "agent_status": "idle",
            "workspace_id": "w1", "tab_id": "w1:t1", "pane_id": "w1:p1",
            "focused": true, "cwd": "/tmp", "revision": 3
          }],
          "layouts": []
        }
        """

        let session = try JSONDecoder().decode(HerdrSession.self, from: Data(json.utf8))
        XCTAssertEqual(session.protocolVersion, 17)
        XCTAssertEqual(session.focusedWorkspace?.label, "sheep")
        XCTAssertEqual(session.focusedTab?.id, TabID(rawValue: "w1:t1"))
        XCTAssertEqual(session.agents.first?.displayName, "codex")
    }
}
