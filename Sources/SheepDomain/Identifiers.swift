public protocol SheepIdentifier: Codable, Hashable, RawRepresentable, Sendable
where RawValue == String {}

public struct WorkspaceID: SheepIdentifier {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }
}

public struct TabID: SheepIdentifier {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }
}

public struct PaneID: SheepIdentifier {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }
}

public struct TerminalID: SheepIdentifier {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }
}

