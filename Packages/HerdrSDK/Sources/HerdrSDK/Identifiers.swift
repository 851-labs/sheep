public protocol HerdrIdentifier: Codable, Hashable, RawRepresentable, Sendable
where RawValue == String {}

public struct HerdrRequestID: HerdrIdentifier {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }
}

public struct WorkspaceID: HerdrIdentifier {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }
}

public struct TabID: HerdrIdentifier {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }
}

public struct PaneID: HerdrIdentifier {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }
}

public struct TerminalID: HerdrIdentifier {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }
}
