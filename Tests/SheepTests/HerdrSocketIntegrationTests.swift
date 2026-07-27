import Darwin
import Foundation
import SheepApplication
import SheepDomain
@testable import SheepInfrastructure
import XCTest

final class HerdrSocketIntegrationTests: XCTestCase {
    func testRequestRejectsMalformedResponse() throws {
        let server = try FakeHerdrServer { descriptor, _ in
            FakeHerdrServer.send(Data("not-json\n".utf8), to: descriptor)
        }
        defer { server.stop() }

        let client = HerdrSocketClient(socketURL: server.socketURL)
        XCTAssertThrowsError(try client.request(method: "ping")) { error in
            XCTAssertEqual((error as? HerdrAPIError)?.code, "malformed_response")
        }
    }

    func testRequestSurfacesHerdrError() throws {
        let server = try FakeHerdrServer { descriptor, request in
            FakeHerdrServer.sendJSON([
                "id": request["id"] ?? "",
                "error": ["code": "closed", "message": "resource is closed"],
            ], to: descriptor)
        }
        defer { server.stop() }

        let client = HerdrSocketClient(socketURL: server.socketURL)
        XCTAssertThrowsError(try client.request(method: "pane.focus")) { error in
            XCTAssertEqual((error as? HerdrAPIError)?.code, "closed")
        }
    }

    func testSubscriptionPreservesEventCoalescedWithAcknowledgement() async throws {
        let eventReceived = expectation(description: "event received")
        let server = try FakeHerdrServer { descriptor, request in
            let acknowledgement = FakeHerdrServer.jsonLine([
                "id": request["id"] ?? "",
                "result": ["subscribed": true],
            ])
            let event = FakeHerdrServer.jsonLine([
                "event": "workspace.updated",
                "workspace_id": "w1",
                "future_field": true,
            ])
            FakeHerdrServer.send(acknowledgement + event, to: descriptor)
            Thread.sleep(forTimeInterval: 0.2)
        }
        defer { server.stop() }

        let subscription = try HerdrSocketClient(socketURL: server.socketURL)
            .makeSubscription(paneIDs: [PaneID(rawValue: "w1:p1")])
        let task = Task.detached {
            try? subscription.run { event in
                if (try? JSONSerialization.jsonObject(with: event)) != nil {
                    eventReceived.fulfill()
                }
            }
        }
        await fulfillment(of: [eventReceived], timeout: 2)
        subscription.cancel()
        _ = await task.result
    }

    func testRepositoryRefreshesAfterEventAndReportsSubscriptionLoss() async throws {
        let snapshots = LockedCounter()
        let subscriptions = LockedCounter()
        let updated = expectation(description: "authoritative snapshot refreshed")
        let disconnected = expectation(description: "subscription loss reported")
        let gates = ExpectationGates()

        let server = try FakeHerdrServer { descriptor, request in
            switch request["method"] as? String {
            case "session.snapshot":
                let count = snapshots.increment()
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": [
                        "snapshot": Self.snapshot(
                            label: count == 1 ? "initial" : "updated",
                            paneCount: count == 1 ? 1 : 2
                        ),
                    ],
                ], to: descriptor)
            case "events.subscribe":
                _ = subscriptions.increment()
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": ["subscribed": true],
                ], to: descriptor)
                Thread.sleep(forTimeInterval: 0.05)
                FakeHerdrServer.sendJSON([
                    "event": "workspace.updated",
                    "workspace_id": "w1",
                ], to: descriptor)
                Thread.sleep(forTimeInterval: 0.5)
            default:
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": [:],
                ], to: descriptor)
            }
        }
        defer { server.stop() }

        let repository = HerdrSessionRepositoryAdapter(
            supervisor: StaticSupervisor(socketURL: server.socketURL)
        )
        let observation = Task {
            let stream = await repository.observeSession()
            for await update in stream {
                if update.connection == .connected,
                   update.session?.focusedWorkspace?.label == "updated",
                   update.session?.panes.count == 2,
                   gates.claimUpdated() {
                    updated.fulfill()
                }
                if case .disconnected = update.connection, gates.claimDisconnected() {
                    disconnected.fulfill()
                }
            }
        }

        await fulfillment(of: [updated, disconnected], timeout: 3)
        observation.cancel()
        XCTAssertGreaterThanOrEqual(snapshots.value, 2)
        XCTAssertGreaterThanOrEqual(subscriptions.value, 2)
    }

    func testRepositoryRejectsIncompatibleHerdrVersion() async throws {
        let unavailable = expectation(description: "incompatible version reported")
        let gates = ExpectationGates()
        let server = try FakeHerdrServer { descriptor, request in
            FakeHerdrServer.sendJSON([
                "id": request["id"] ?? "",
                "result": ["snapshot": Self.snapshot(label: "old", version: "0.7.4")],
            ], to: descriptor)
        }
        defer { server.stop() }

        let repository = HerdrSessionRepositoryAdapter(
            supervisor: StaticSupervisor(socketURL: server.socketURL)
        )
        let observation = Task {
            let stream = await repository.observeSession()
            for await update in stream {
                if case let .unavailable(message) = update.connection,
                   message.contains("0.7.5"),
                   gates.claimUpdated() {
                    unavailable.fulfill()
                }
            }
        }

        await fulfillment(of: [unavailable], timeout: 2)
        observation.cancel()
    }

    func testRepositorySendsFocusCommandWithResourceIdentifier() async throws {
        let connected = expectation(description: "repository connected")
        let focused = expectation(description: "focus command received")
        let gates = ExpectationGates()
        let server = try FakeHerdrServer { descriptor, request in
            switch request["method"] as? String {
            case "session.snapshot":
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": ["snapshot": Self.snapshot(label: "ready")],
                ], to: descriptor)
            case "events.subscribe":
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": ["subscribed": true],
                ], to: descriptor)
                Thread.sleep(forTimeInterval: 1)
            case "workspace.focus":
                let params = request["params"] as? [String: Any]
                if params?["workspace_id"] as? String == "w1" {
                    focused.fulfill()
                }
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": [:],
                ], to: descriptor)
            default:
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": [:],
                ], to: descriptor)
            }
        }
        defer { server.stop() }

        let repository = HerdrSessionRepositoryAdapter(
            supervisor: StaticSupervisor(socketURL: server.socketURL)
        )
        let observation = Task {
            let stream = await repository.observeSession()
            for await update in stream where update.connection == .connected {
                if gates.claimUpdated() {
                    connected.fulfill()
                }
            }
        }
        await fulfillment(of: [connected], timeout: 2)
        try await repository.focusWorkspace(WorkspaceID(rawValue: "w1"))
        await fulfillment(of: [focused], timeout: 2)
        observation.cancel()
    }

    private static func snapshot(
        label: String,
        version: String = "0.7.5",
        paneCount: Int = 1
    ) -> [String: Any] {
        var panes: [[String: Any]] = [[
            "pane_id": "w1:p1",
            "terminal_id": "term_1",
            "workspace_id": "w1",
            "tab_id": "w1:t1",
            "focused": true,
            "cwd": "/tmp",
            "agent_status": "idle",
            "revision": 1,
        ]]
        if paneCount > 1 {
            panes.append([
                "pane_id": "w1:p2",
                "terminal_id": "term_2",
                "workspace_id": "w1",
                "tab_id": "w1:t1",
                "focused": false,
                "cwd": "/tmp",
                "agent_status": "working",
                "revision": 1,
            ])
        }
        return [
            "version": version,
            "protocol": 17,
            "focused_workspace_id": "w1",
            "focused_tab_id": "w1:t1",
            "focused_pane_id": "w1:p1",
            "workspaces": [[
                "workspace_id": "w1",
                "number": 1,
                "label": label,
                "focused": true,
                "pane_count": paneCount,
                "tab_count": 1,
                "active_tab_id": "w1:t1",
                "agent_status": "idle",
            ]],
            "tabs": [[
                "tab_id": "w1:t1",
                "workspace_id": "w1",
                "number": 1,
                "label": "1",
                "focused": true,
                "pane_count": paneCount,
                "agent_status": "idle",
            ]],
            "panes": panes,
            "agents": [],
        ]
    }
}

private struct StaticSupervisor: HerdrServerSupervisor {
    let socketURL: URL

    func ensureRunning() async throws -> URL {
        socketURL
    }
}

private final class LockedCounter: @unchecked Sendable {
    private let lock = NSLock()
    private var storage = 0

    var value: Int {
        lock.withLock { storage }
    }

    func increment() -> Int {
        lock.withLock {
            storage += 1
            return storage
        }
    }
}

private final class ExpectationGates: @unchecked Sendable {
    private let lock = NSLock()
    private var updated = false
    private var disconnected = false

    func claimUpdated() -> Bool {
        lock.withLock {
            guard !updated else { return false }
            updated = true
            return true
        }
    }

    func claimDisconnected() -> Bool {
        lock.withLock {
            guard !disconnected else { return false }
            disconnected = true
            return true
        }
    }
}

private final class FakeHerdrServer: @unchecked Sendable {
    typealias Handler = @Sendable (Int32, [String: Any]) -> Void

    let socketURL: URL
    private let descriptor: Int32
    private let handler: Handler
    private let stateLock = NSLock()
    private var stopped = false

    init(handler: @escaping Handler) throws {
        self.handler = handler
        socketURL = URL(
            fileURLWithPath: "/tmp/sheep-\(UUID().uuidString.prefix(8)).sock"
        )

        let listener = Darwin.socket(AF_UNIX, SOCK_STREAM, 0)
        guard listener >= 0 else { throw POSIXError(.EIO) }
        descriptor = listener
        Darwin.unlink(socketURL.path)

        var address = sockaddr_un()
        address.sun_family = sa_family_t(AF_UNIX)
        let bytes = Array(socketURL.path.utf8CString)
        withUnsafeMutableBytes(of: &address.sun_path) { destination in
            bytes.withUnsafeBytes { source in
                destination.copyBytes(from: source)
            }
        }
        let bindResult = withUnsafePointer(to: &address) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                Darwin.bind(listener, $0, socklen_t(MemoryLayout<sockaddr_un>.size))
            }
        }
        guard bindResult == 0, Darwin.listen(listener, 16) == 0 else {
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
        stateLock.lock()
        guard !stopped else {
            stateLock.unlock()
            return
        }
        stopped = true
        stateLock.unlock()
        Darwin.shutdown(descriptor, SHUT_RDWR)
        Darwin.close(descriptor)
        Darwin.unlink(socketURL.path)
    }

    private func acceptLoop() {
        while !stateLock.withLock({ stopped }) {
            let client = Darwin.accept(descriptor, nil, nil)
            guard client >= 0 else { return }
            var noSignal: Int32 = 1
            setsockopt(
                client,
                SOL_SOCKET,
                SO_NOSIGPIPE,
                &noSignal,
                socklen_t(MemoryLayout<Int32>.size)
            )
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
            data.append(bytes, count: count)
            if let newline = data.firstIndex(of: 0x0A) {
                let line = data.prefix(upTo: newline)
                return (try? JSONSerialization.jsonObject(with: line)) as? [String: Any]
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
