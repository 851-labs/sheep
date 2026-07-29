import Darwin
import Foundation
@testable import HerdrSDK
import Testing

@Suite(.serialized)
struct TransportTests {
    @Test
    func rawRequestRejectsMismatchedResponseID() async throws {
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
            Issue.record("Expected an identifier mismatch")
        } catch let error as HerdrAPIError {
            #expect(error.code == "response_id_mismatch")
        }
    }

    @Test
    func rawRequestSurfacesServerError() async throws {
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
            Issue.record("Expected a server error")
        } catch let error as HerdrAPIError {
            #expect(error.code == "closed")
        }
    }

    @Test
    func pingAndSnapshotUseSemanticModels() async throws {
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
        #expect(status.protocolVersion == 17)
        let snapshot = try await client.sessions.snapshot()
        #expect(snapshot.version == "0.7.5")
    }

    @Test
    func focusMutationsDecodeLightweightAcknowledgements() async throws {
        let server = try FakeHerdrServer { descriptor, request in
            FakeHerdrServer.sendJSON([
                "id": request["id"] ?? "",
                "result": ["type": "ok"],
            ], to: descriptor)
        }
        defer { server.stop() }

        let client = HerdrClient(socketURL: server.socketURL)
        try await client.workspaces.focus(WorkspaceID(rawValue: "w1"))
        try await client.tabs.focus(TabID(rawValue: "t1"))
        try await client.panes.focus(PaneID(rawValue: "p1"))
    }

    @Test
    func subscriptionPreservesEventCoalescedWithAcknowledgement() async throws {
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
            #expect(lifecycle.event.rawValue == "workspace_updated")
            break
        }
    }

    @Test
    func cancellingRequestClosesBlockedSocket() async throws {
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
            Issue.record("Expected cancellation")
        } catch is CancellationError {
            // Expected: cancellation shuts down the descriptor blocked in read(2).
        }
    }

    @Test
    func subscriptionRejectsUnknownEventWithCompatibilityError() async throws {
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
            Issue.record("Expected an unknown event error")
        } catch let error as HerdrCompatibilityError {
            #expect(error == .unknownEventDiscriminator("future_event"))
        }
    }
}
