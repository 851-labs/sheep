import XCTest
@testable import sheep

final class GitSummaryTests: XCTestCase {
    func testCompactDescriptionIncludesDivergence() {
        let summary = GitSummary(branch: "main", ahead: 2, behind: 3)
        XCTAssertEqual(summary.compactDescription, "main ↑2 ↓3")
        XCTAssertEqual(GitSummary(branch: "detached").compactDescription, "detached")
    }
}
