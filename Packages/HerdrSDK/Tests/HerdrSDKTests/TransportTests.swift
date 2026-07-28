import Darwin
import Foundation
@testable import HerdrSDK
import XCTest

final class TransportTests: XCTestCase {
    func testRawRequestRejectsMismatchedResponseID() async throws {
        let server = try FakeHerdrServer { descriptor, request in
            FakeHerdrServer.sendJSON([
                "id": "different-request",
                "result": ["type": "ok"],
            ], to: descriptor)
        }
        defer { server.stop() }

        let client = HerdrClient(socketURL: server.socketURL)
        do {
            _ = try await client.rawRequest(method: "future.method")
            XCTFail("Expected an identifier mismatch")
        } catch let error as HerdrAPIError {
            XCTAssertEqual(error.code, "response_id_mismatch")
        }
    }

    func testRawRequestSurfacesServerError() async throws {
        let server = try FakeHerdrServer { descriptor, request in
            FakeHerdrServer.sendJSON([
                "id": request["id"] ?? "",
                "error": ["code": "closed", "message": "resource is closed"],
            ], to: descriptor)
        }
        defer { server.stop() }

        let client = HerdrClient(socketURL: server.socketURL)
        do {
            _ = try await client.rawRequest(method: "pane.focus")
            XCTFail("Expected a server error")
        } catch let error as HerdrAPIError {
            XCTAssertEqual(error.code, "closed")
        }
    }

    func testPingAndSnapshotUseSemanticModels() async throws {
        let server = try FakeHerdrServer { descriptor, request in
            let result: [String: Any]
            switch request["method"] as? String {
            case "ping":
                result = ["type": "pong", "version": "0.7.5", "protocol": 17]
            case "session.snapshot":
                result = [
                    "type": "session_snapshot",
                    "snapshot": [
                        "version": "0.7.5",
                        "protocol": 17,
                        "focused_workspace_id": NSNull(),
                        "focused_tab_id": NSNull(),
                        "focused_pane_id": NSNull(),
                        "workspaces": [],
                        "tabs": [],
                        "panes": [],
                        "layouts": [],
                        "agents": [],
                    ],
                ]
            default:
                result = ["type": "ok"]
            }
            FakeHerdrServer.sendJSON([
                "id": request["id"] ?? "",
                "result": result,
            ], to: descriptor)
        }
        defer { server.stop() }

        let client = HerdrClient(socketURL: server.socketURL)
        let status = try await client.server.ping()
        XCTAssertEqual(status.protocolVersion, 17)
        let snapshot = try await client.sessions.snapshot()
        XCTAssertEqual(snapshot.version, "0.7.5")
    }

    func testSubscriptionPreservesEventCoalescedWithAcknowledgement() async throws {
        let server = try FakeHerdrServer { descriptor, request in
            let acknowledgement = FakeHerdrServer.jsonLine([
                "id": request["id"] ?? "",
                "result": ["type": "subscription_started"],
            ])
            let event = FakeHerdrServer.jsonLine([
                "event": "workspace_updated",
                "data": [
                    "type": "workspace_updated",
                    "workspace_id": "w1",
                ],
            ])
            FakeHerdrServer.send(acknowledgement + event, to: descriptor)
            Thread.sleep(forTimeInterval: 0.2)
        }
        defer { server.stop() }

        let client = HerdrClient(socketURL: server.socketURL)
        let stream = try await client.events.subscribe([
            .init(type: "workspace.updated"),
        ])
        for try await event in stream {
            guard case let .lifecycle(lifecycle) = event else { continue }
            XCTAssertEqual(lifecycle.event.rawValue, "workspace_updated")
            break
        }
    }

    func testCancellingRequestClosesBlockedSocket() async throws {
        let server = try FakeHerdrServer { _, _ in
            Thread.sleep(forTimeInterval: 1)
        }
        defer { server.stop() }

        let client = HerdrClient(socketURL: server.socketURL)
        let task = Task {
            try await client.rawRequest(method: "future.slow_method")
        }
        try await Task.sleep(for: .milliseconds(25))
        task.cancel()

        do {
            _ = try await task.value
            XCTFail("Expected cancellation")
        } catch is CancellationError {
            // Expected: cancellation shuts down the descriptor blocked in read(2).
        }
    }

    func testSubscriptionRejectsUnknownEventWithCompatibilityError() async throws {
        let server = try FakeHerdrServer { descriptor, request in
            let acknowledgement = FakeHerdrServer.jsonLine([
                "id": request["id"] ?? "",
                "result": ["type": "subscription_started"],
            ])
            let event = FakeHerdrServer.jsonLine([
                "event": "future_event",
                "data": ["type": "future_event"],
            ])
            FakeHerdrServer.send(acknowledgement + event, to: descriptor)
        }
        defer { server.stop() }

        let client = HerdrClient(socketURL: server.socketURL)
        let stream = try await client.events.subscribe([
            .init(type: "workspace.updated"),
        ])
        do {
            for try await _ in stream {}
            XCTFail("Expected an unknown event error")
        } catch let error as HerdrCompatibilityError {
            XCTAssertEqual(error, .unknownEventDiscriminator("future_event"))
        }
    }
}

private final class FakeHerdrServer: @unchecked Sendable {
    typealias Handler = @Sendable (Int32, [String: Any]) -> Void

    let socketURL: URL
    private let descriptor: Int32
    private let handler: Handler
    private let lock = NSLock()
    private var stopped = false

    init(handler: @escaping Handler) throws {
        self.handler = handler
        socketURL = URL(
            fileURLWithPath: "/tmp/herdr-sdk-\(UUID().uuidString.prefix(8)).sock"
        )
        let listener = Darwin.socket(AF_UNIX, SOCK_STREAM, 0)
        guard listener >= 0 else { throw POSIXError(.EIO) }
        descriptor = listener
        Darwin.unlink(socketURL.path)

        var address = sockaddr_un()
        address.sun_family = sa_family_t(AF_UNIX)
        let bytes = Array(socketURL.path.utf8CString)
        withUnsafeMutableBytes(of: &address.sun_path) { destination in
            bytes.withUnsafeBytes { destination.copyBytes(from: $0) }
        }
        let bound = withUnsafePointer(to: &address) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                Darwin.bind(listener, $0, socklen_t(MemoryLayout<sockaddr_un>.size))
            }
        }
        guard bound == 0, Darwin.listen(listener, 16) == 0 else {
            Darwin.close(listener)
            throw POSIXError(POSIXErrorCode(rawValue: errno) ?? .EIO)
        }
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            acceptLoop()
        }
    }

    deinit {
        stop()
    }

    func stop() {
        let shouldStop = lock.withLock {
            guard !stopped else { return false }
            stopped = true
            return true
        }
        guard shouldStop else { return }
        Darwin.shutdown(descriptor, SHUT_RDWR)
        Darwin.close(descriptor)
        Darwin.unlink(socketURL.path)
    }

    private func acceptLoop() {
        while !lock.withLock({ stopped }) {
            let client = Darwin.accept(descriptor, nil, nil)
            guard client >= 0 else { return }
            DispatchQueue.global(qos: .userInitiated).async { [handler] in
                defer { Darwin.close(client) }
                guard let request = Self.readRequest(from: client) else { return }
                handler(client, request)
            }
        }
    }

    private static func readRequest(from descriptor: Int32) -> [String: Any]? {
        var data = Data()
        var bytes = [UInt8](repeating: 0, count: 4_096)
        while true {
            let count = Darwin.read(descriptor, &bytes, bytes.count)
            guard count > 0 else { return nil }
            data.append(contentsOf: bytes.prefix(count))
            if let newline = data.firstIndex(of: 0x0A) {
                return (try? JSONSerialization.jsonObject(
                    with: data.prefix(upTo: newline)
                )) as? [String: Any]
            }
        }
    }

    static func jsonLine(_ object: [String: Any]) -> Data {
        var data = try! JSONSerialization.data(withJSONObject: object)
        data.append(0x0A)
        return data
    }

    static func sendJSON(_ object: [String: Any], to descriptor: Int32) {
        send(jsonLine(object), to: descriptor)
    }

    static func send(_ data: Data, to descriptor: Int32) {
        data.withUnsafeBytes { rawBuffer in
            guard let base = rawBuffer.baseAddress else { return }
            var sent = 0
            while sent < data.count {
                let count = Darwin.send(
                    descriptor,
                    base.advanced(by: sent),
                    data.count - sent,
                    0
                )
                guard count > 0 else { return }
                sent += count
            }
        }
    }
}
