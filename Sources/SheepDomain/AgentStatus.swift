public enum AgentStatus: String, Codable, CaseIterable, Sendable {
    case idle
    case working
    case blocked
    case done
    case unknown

    public var urgency: Int {
        switch self {
        case .blocked: 5
        case .working: 4
        case .done: 3
        case .idle: 2
        case .unknown: 1
        }
    }
}

