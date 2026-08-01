import Foundation

public typealias HerdrResponseResult = HerdrSuccessResult

public struct HerdrEmptyParameters: Codable, Sendable {
    public init() {}
}

public protocol HerdrRequest: Sendable {
    associatedtype Parameters: Encodable & Sendable
    associatedtype Response: Decodable & Sendable

    var method: HerdrMethod { get }
    var params: Parameters { get }
    var availability: HerdrProtocolAvailability { get }
}

public extension HerdrRequest {
    var availability: HerdrProtocolAvailability { method.availability }
}

public struct HerdrEndpoint<Parameters: Encodable & Sendable>: HerdrRequest {
    public typealias Response = HerdrResponseResult

    public let method: HerdrMethod
    public let params: Parameters

    public init(method: HerdrMethod, params: Parameters) {
        self.method = method
        self.params = params
    }
}

public struct HerdrTypedRequest<
    Parameters: Encodable & Sendable,
    Response: Decodable & Sendable
>: HerdrRequest {
    public let method: HerdrMethod
    public let params: Parameters

    public init(method: HerdrMethod, params: Parameters) {
        self.method = method
        self.params = params
    }
}
