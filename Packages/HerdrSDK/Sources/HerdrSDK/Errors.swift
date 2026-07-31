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
    case unknownResultDiscriminator(String)
    case unknownEventDiscriminator(String)

    public var errorDescription: String? {
        switch self {
        case let .protocolMismatch(expected, actual):
            "HerdrSDK requires protocol \(expected); the server reports \(actual)."
        case let .versionTooOld(minimum, actual):
            "HerdrSDK requires Herdr \(minimum) or newer; the server reports \(actual)."
        case let .unknownResultDiscriminator(value):
            "Herdr returned an unknown protocol-\(HerdrProtocolMetadata.protocolVersion) "
                + "result discriminator: \(value)."
        case let .unknownEventDiscriminator(value):
            "Herdr emitted an unknown protocol-\(HerdrProtocolMetadata.protocolVersion) "
                + "event discriminator: \(value)."
        }
    }
}
