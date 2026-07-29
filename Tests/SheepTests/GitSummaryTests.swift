import Testing
@testable import sheep

@Suite
struct GitSummaryTests {
    @Test
    func compactDescriptionIncludesDivergence() {
        let summary = GitSummary(branch: "main", ahead: 2, behind: 3)
        #expect(summary.compactDescription == "main ↑2 ↓3")
        #expect(GitSummary(branch: "detached").compactDescription == "detached")
    }
}
