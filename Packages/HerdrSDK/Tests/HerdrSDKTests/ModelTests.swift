import Foundation
import HerdrSDK
import Testing

@Suite
struct ModelTests {
    @Test
    func agentStatusUrgency() {
        #expect(
            [
                AgentStatus.blocked,
                .working,
                .done,
                .idle,
                .unknown,
            ].map(\.urgency) == [5, 4, 3, 2, 1]
        )
    }

    @Test
    func layoutDecodesHerdrShapeAndZoom() throws {
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
        #expect(layout.root.paneIDs().map(\.rawValue) == ["w1:p1", "w1:p2"])
        #expect(layout.root.leavesWithPaths().map(\.path) == [[false], [true]])

        let zoomed = PaneLayout(
            workspaceID: layout.workspaceID,
            tabID: layout.tabID,
            zoomed: true,
            focusedPaneID: PaneID(rawValue: "w1:p2"),
            root: layout.root
        )
        #expect(zoomed.visibleRoot == .pane(PaneID(rawValue: "w1:p2")))
    }

    @Test
    func protocol18SnapshotIgnoresUnknownFields() throws {
        let json = """
        {
          "version": "0.7.5",
          "protocol": 18,
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
        #expect(session.protocolVersion == 18)
        #expect(session.focusedWorkspace?.label == "sheep")
        #expect(session.focusedTab?.id == TabID(rawValue: "w1:t1"))
        #expect(session.agents.first?.displayName == "codex")
    }

    @Test
    func selectionFallsBackFromStaleFocusedIdentifiers() throws {
        let json = """
        {
          "version": "0.7.5", "protocol": 18,
          "focused_workspace_id": "closed-workspace",
          "focused_tab_id": "closed-tab",
          "focused_pane_id": "closed-pane",
          "workspaces": [{
            "workspace_id": "w1", "number": 1, "label": "sheep",
            "focused": false, "pane_count": 1, "tab_count": 1,
            "active_tab_id": "w1:t1", "agent_status": "idle"
          }],
          "tabs": [{
            "tab_id": "w1:t1", "workspace_id": "w1", "number": 1,
            "label": "1", "focused": false, "pane_count": 1,
            "agent_status": "idle"
          }],
          "panes": [{
            "pane_id": "w1:p1", "terminal_id": "term_1",
            "workspace_id": "w1", "tab_id": "w1:t1", "focused": true,
            "cwd": "/tmp/sheep", "agent_status": "idle", "revision": 1
          }],
          "agents": []
        }
        """
        let session = try JSONDecoder().decode(HerdrSession.self, from: Data(json.utf8))

        #expect(session.focusedWorkspace?.id == WorkspaceID(rawValue: "w1"))
        #expect(session.focusedTab?.id == TabID(rawValue: "w1:t1"))
        #expect(session.focusedPane?.id == PaneID(rawValue: "w1:p1"))
    }
}
