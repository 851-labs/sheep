import Foundation
import SheepDomain

public enum WorkspaceProjection {
    public static func repositoryDirectory(
        for workspace: Workspace,
        in session: HerdrSession
    ) -> URL? {
        if let checkoutPath = workspace.worktree?.checkoutPath {
            return URL(fileURLWithPath: checkoutPath, isDirectory: true)
        }

        let activeTabPanes = session.panes(in: workspace.activeTabID)
        let candidate = activeTabPanes.first(where: \.focused)
            ?? activeTabPanes.first
        return (candidate?.foregroundCWD ?? candidate?.cwd).map {
            URL(fileURLWithPath: $0, isDirectory: true)
        }
    }
}

