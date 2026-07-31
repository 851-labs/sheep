import Foundation
import HerdrSDK
import Testing
@testable import sheep

@Suite
struct WorkspaceProjectionTests {
    @Test
    func repositoryDirectoryFallsBackToActivePaneCWD() throws {
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
        let workspace = try #require(session.focusedWorkspace)

        #expect(
            WorkspaceProjection.repositoryDirectory(for: workspace, in: session)?.path
                == "/tmp/sheep"
        )
    }
}
