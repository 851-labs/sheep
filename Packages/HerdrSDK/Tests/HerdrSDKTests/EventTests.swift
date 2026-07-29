import Darwin
import Foundation
@testable import HerdrSDK
import Testing

@Suite(.serialized)
struct EventTests {
    @Test
    func paneFiltersEncodeTheirOptions() throws {
        #expect(DynamicCodingKey(stringValue: "value")?.stringValue == "value")
        #expect(DynamicCodingKey(intValue: 1) == nil)
        for (filter, type) in [
            (HerdrEventFilter.paneAgentStatusChanged(PaneID(rawValue: "p1")),
             "pane.agent_status_changed"),
            (HerdrEventFilter.paneScrollChanged(PaneID(rawValue: "p1")),
             "pane.scroll_changed"),
        ] {
            #expect(filter.type == type)
            #expect(filter.options == ["pane_id": .string("p1")])
            let object = try #require(
                JSONSerialization.jsonObject(with: JSONEncoder().encode(filter))
                    as? [String: Any]
            )
            #expect(object["type"] as? String == type)
            #expect(object["pane_id"] as? String == "p1")
        }
    }

    @Test
    func subscriptionEventsDecodeThroughTypedBranch() async throws {
        let server = try FakeHerdrServer { descriptor, request in
            FakeHerdrServer.send(
                FakeHerdrServer.jsonLine([
                    "id": request["id"] ?? "",
                    "result": ["type": "subscription_started"],
                ]) + FakeHerdrServer.jsonLine([
                    "event": "pane.agent_status_changed",
                    "data": [
                        "type": "pane.agent_status_changed",
                        "pane_id": "p1",
                        "agent": "codex",
                        "agent_status": "working",
                    ],
                ]),
                to: descriptor
            )
        }
        defer { server.stop() }

        let stream = try await HerdrClient(socketURL: server.socketURL)
            .events.subscribe([.paneAgentStatusChanged(PaneID(rawValue: "p1"))])
        for try await event in stream {
            guard case let .subscription(envelope) = event else {
                Issue.record("Expected subscription event")
                return
            }
            #expect(envelope.event.rawValue == "pane.agent_status_changed")
            #expect(envelope.data.paneID == PaneID(rawValue: "p1"))
            return
        }
        Issue.record("Expected an event")
    }

    @Test
    func malformedEventIsReported() async throws {
        let server = try FakeHerdrServer { descriptor, request in
            FakeHerdrServer.send(
                FakeHerdrServer.jsonLine([
                    "id": request["id"] ?? "",
                    "result": ["type": "subscription_started"],
                ]) + FakeHerdrServer.jsonLine(["data": ["type": "missing"]]),
                to: descriptor
            )
        }
        defer { server.stop() }

        let stream = try await HerdrClient(socketURL: server.socketURL)
            .events.subscribe([])
        do {
            for try await _ in stream {}
            Issue.record("Expected malformed event")
        } catch let error as HerdrAPIError {
            #expect(error.code == "malformed_event")
        }
    }

    @Test
    func terminatingConsumerCancelsBlockedSubscription() async throws {
        let server = try FakeHerdrServer { descriptor, request in
            FakeHerdrServer.sendJSON([
                "id": request["id"] ?? "",
                "result": ["type": "subscription_started"],
            ], to: descriptor)
            Thread.sleep(forTimeInterval: 1)
        }
        defer { server.stop() }

        let stream = try await HerdrClient(socketURL: server.socketURL)
            .events.subscribe([])
        let consumer = Task {
            for try await _ in stream {}
        }
        try await Task.sleep(for: .milliseconds(20))
        consumer.cancel()
        do {
            try await consumer.value
        } catch is CancellationError {
            // Cancellation is an acceptable stream termination.
        }
    }

    @Test
    func preCancelledConnectionReturnsWithoutUsingDescriptor() throws {
        var descriptors = [Int32](repeating: -1, count: 2)
        #expect(socketpair(AF_UNIX, SOCK_STREAM, 0, &descriptors) == 0)
        defer { Darwin.close(descriptors[1]) }
        let connection = HerdrEventConnection(
            descriptor: descriptors[0],
            requestID: HerdrRequestID(rawValue: "cancelled"),
            requestPayload: Data()
        )
        connection.cancel()
        try connection.run { _ in
            Issue.record("A cancelled connection cannot emit events")
        }
    }

    @Test
    func cancellationAfterAcknowledgementExitsEventLoopCleanly() throws {
        var descriptors = [Int32](repeating: -1, count: 2)
        #expect(socketpair(AF_UNIX, SOCK_STREAM, 0, &descriptors) == 0)
        let requestID = HerdrRequestID(rawValue: "subscribed")
        let connection = HerdrEventConnection(
            descriptor: descriptors[0],
            requestID: requestID,
            requestPayload: Data("subscribe\n".utf8)
        )
        let peer = descriptors[1]
        DispatchQueue.global(qos: .userInitiated).async {
            _ = readLineForEventTest(from: peer)
            FakeHerdrServer.sendJSON([
                "id": requestID.rawValue,
                "result": ["type": "subscription_started"],
            ], to: peer)
            Darwin.close(peer)
        }
        try connection.run(
            onSubscribed: { connection.cancel() },
            onEvent: { _ in Issue.record("Expected no event") }
        )
    }
}

private func readLineForEventTest(from descriptor: Int32) -> Data {
    var data = Data()
    var byte: UInt8 = 0
    while Darwin.read(descriptor, &byte, 1) == 1 {
        if byte == 0x0A { break }
        data.append(byte)
    }
    return data
}
