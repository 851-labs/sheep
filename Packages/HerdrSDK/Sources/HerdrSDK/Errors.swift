import Foundation

public struct HerdrAPIError: LocalizedError, Equatable, Sendable {
    public let code: String
    public let message: String

    public init(code: String, message: String) {
        self.code = code
        self.message = message
    }

    public var errorDescription: String? { message }
}

public enum HerdrCompatibilityError: LocalizedError, Equatable, Sendable {
    case protocolMismatch(expected: Int, actual: UInt)
    case versionTooOld(minimum: String, actual: String)

    public var errorDescription: String? {
        switch self {
        case let .protocolMismatch(expected, actual):
            "HerdrSDK requires protocol \(expected); the server reports \(actual)."
        case let .versionTooOld(minimum, actual):
            "HerdrSDK requires Herdr \(minimum) or newer; the server reports \(actual)."
        }
    }
}
