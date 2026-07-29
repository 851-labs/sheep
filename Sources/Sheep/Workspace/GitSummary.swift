public struct GitSummary: Equatable, Sendable {
    public let branch: String
    public let ahead: Int
    public let behind: Int

    public init(branch: String, ahead: Int = 0, behind: Int = 0) {
        self.branch = branch
        self.ahead = ahead
        self.behind = behind
    }

    public var compactDescription: String {
        var components = [branch]
        if ahead > 0 { components.append("↑\(ahead)") }
        if behind > 0 { components.append("↓\(behind)") }
        return components.joined(separator: " ")
    }
}
