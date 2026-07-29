import Darwin
import Foundation

public typealias HerdrLifecycleEvent = HerdrEventEventEnvelope
public typealias HerdrSubscriptionEnvelope = HerdrSubscriptionSubscriptionEventEnvelope

public enum HerdrEvent: Sendable {
    case lifecycle(HerdrLifecycleEvent)
    case subscription(HerdrSubscriptionEnvelope)
}

public struct HerdrEventFilter: Encodable, Equatable, Sendable {
    public let type: String
    public let options: [String: HerdrJSONValue]

    public init(type: String, options: [String: HerdrJSONValue] = [:]) {
        self.type = type
        self.options = options
    }

    public static func paneAgentStatusChanged(_ paneID: PaneID) -> Self {
        .init(
            type: "pane.agent_status_changed",
            options: ["pane_id": .string(paneID.rawValue)]
        )
    }

    public static func paneScrollChanged(_ paneID: PaneID) -> Self {
        .init(
            type: "pane.scroll_changed",
            options: ["pane_id": .string(paneID.rawValue)]
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        try container.encode(type, forKey: .init("type"))
        for (key, value) in options {
            try container.encode(value, forKey: .init(key))
        }
    }
}

struct DynamicCodingKey: CodingKey {
    let stringValue: String
    let intValue: Int? = nil

    init(_ value: String) {
        stringValue = value
    }

    init?(stringValue: String) {
        self.init(stringValue)
    }

    init?(intValue: Int) {
        return nil
    }
}

final class HerdrEventConnection: @unchecked Sendable {
    private let descriptor: Int32
    private let requestID: HerdrRequestID
    private let requestPayload: Data
    private let lock = NSLock()
    private var closed = false

    init(descriptor: Int32, requestID: HerdrRequestID, requestPayload: Data) {
        self.descriptor = descriptor
        self.requestID = requestID
        self.requestPayload = requestPayload
    }

    deinit {
        cancel()
    }

    func run(
        onSubscribed: @escaping @Sendable () -> Void = {},
        onEvent: @escaping @Sendable (HerdrEvent) -> Void
    ) throws {
        defer { cancel() }
        guard !isClosed else { return }
        try HerdrSocketTransport.writeAll(requestPayload, to: descriptor)
        let reader = DescriptorLineReader(descriptor: descriptor)
        _ = try HerdrSocketTransport.validatedResult(
            from: reader.readLine(),
            requestID: requestID
        )
        onSubscribed()

        let decoder = JSONDecoder()
        while !isClosed {
            let data = try reader.readLine()
            let discriminator = try Self.eventDiscriminator(from: data)
            if HerdrSchemaCatalog.subscriptionEventTypes.contains(discriminator) {
                let event = try decoder.decode(HerdrSubscriptionEnvelope.self, from: data)
                onEvent(.subscription(event))
            } else if HerdrSchemaCatalog.eventTypes.contains(discriminator) {
                let event = try decoder.decode(HerdrLifecycleEvent.self, from: data)
                onEvent(.lifecycle(event))
            } else {
                throw HerdrCompatibilityError.unknownEventDiscriminator(
                    discriminator
                )
            }
        }
    }

    func cancel() {
        let shouldClose = lock.withLock {
            guard !closed else { return false }
            closed = true
            return true
        }
        guard shouldClose else { return }
        Darwin.shutdown(descriptor, SHUT_RDWR)
        Darwin.close(descriptor)
    }

    private var isClosed: Bool {
        lock.withLock { closed }
    }

    private static func eventDiscriminator(from data: Data) throws -> String {
        guard let object = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let discriminator = object["event"] as? String else {
            throw HerdrAPIError(
                code: "malformed_event",
                message: "Herdr emitted an event without a discriminator."
            )
        }
        return discriminator
    }
}

public struct HerdrEventsService: HerdrService {
    public let client: HerdrClient
    init(client: HerdrClient) { self.client = client }

    public func subscribe(
        _ filters: [HerdrEventFilter]
    ) async throws -> AsyncThrowingStream<HerdrEvent, Error> {
        let connection = try await client.makeEventConnection(filters: filters)
        return AsyncThrowingStream { continuation in
            let task = Task.detached {
                do {
                    try connection.run { continuation.yield($0) }
                } catch {
                    if !Task.isCancelled {
                        continuation.finish(throwing: error)
                    }
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
                connection.cancel()
            }
        }
    }
}
