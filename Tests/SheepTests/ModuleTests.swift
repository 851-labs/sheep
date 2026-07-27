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
    }
}
