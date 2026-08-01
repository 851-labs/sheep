import Foundation
@testable import HerdrSDK
import Testing

@Suite(.serialized)
struct ServiceTests {
    @Test
    func exposesEveryServiceFacade() {
        let client = HerdrClient(socketURL: URL(fileURLWithPath: "/tmp/herdr-sdk-test.sock"))
        #expect(client.server.client === client)
        #expect(client.notifications.client === client)
        #expect(client.windowTitles.client === client)
        #expect(client.sessions.client === client)
        #expect(client.workspaces.client === client)
        #expect(client.worktrees.client === client)
        #expect(client.tabs.client === client)
        #expect(client.panes.client === client)
        #expect(client.layouts.client === client)
        #expect(client.agents.client === client)
        #expect(client.events.client === client)
        #expect(client.integrations.client === client)
        #expect(client.plugins.client === client)
    }

    @Test
    func pingSnapshotAndFocusCalls() async throws {
        let recorder = RequestRecorder()
        let server = try FakeHerdrServer { descriptor, request in
            recorder.append(request)
            let method = request["method"] as? String
            let result: Any
            switch method {
            case "ping":
                result = ["version": "0.7.5", "protocol": 18]
            case "session.snapshot":
                result = ["snapshot": emptySession()]
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
        #expect(try await client.server.ping().protocolVersion == 18)
        #expect(try await client.sessions.snapshot().version == "0.7.5")
        try await client.workspaces.focus(WorkspaceID(rawValue: "w1"))
        try await client.tabs.focus(TabID(rawValue: "t1"))
        try await client.panes.focus(PaneID(rawValue: "p1"))

        #expect(recorder.requests.map { $0["method"] as? String } == [
            "ping", "session.snapshot", "workspace.focus", "tab.focus", "pane.focus",
        ])
    }

    @Test
    func workspaceAndTabCreationCalls() async throws {
        let recorder = RequestRecorder()
        let server = try FakeHerdrServer { descriptor, request in
            recorder.append(request)
            let result: Any
            switch request["method"] as? String {
            case "workspace.create":
                result = [
                    "workspace": workspaceObject(),
                    "tab": tabObject(),
                    "root_pane": paneObjectForService(),
                ]
            case "tab.create":
                result = [
                    "tab": tabObject(),
                    "root_pane": paneObjectForService(),
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
        let directory = URL(fileURLWithPath: "/tmp/example")
        let workspace = try await client.workspaces.create(
            cwd: directory,
            focus: false,
            environment: ["A": "B"]
        )
        #expect(workspace.workspace.label == "space")
        #expect(workspace.rootPane.id == PaneID(rawValue: "p1"))

        let tab = try await client.tabs.create(
            in: WorkspaceID(rawValue: "w1"),
            cwd: directory,
            focus: false,
            label: "custom",
            environment: ["C": "D"]
        )
        #expect(tab.tab.label == "tab")

        let requests = recorder.requests
        #expect(requests.count == 2)
        let workspaceParams = try #require(
            requests.first { $0["method"] as? String == "workspace.create" }?["params"]
                as? [String: Any]
        )
        #expect(workspaceParams["cwd"] as? String == "/tmp/example")
        #expect(workspaceParams["label"] as? String == "example")
        #expect(workspaceParams["focus"] as? Bool == false)
    }

    @Test
    func layoutCalls() async throws {
        let recorder = RequestRecorder()
        let server = try FakeHerdrServer { descriptor, request in
            recorder.append(request)
            FakeHerdrServer.sendJSON([
                "id": request["id"] ?? "",
                "result": ["layout": layoutObject()],
            ], to: descriptor)
        }
        defer { server.stop() }

        let client = HerdrClient(socketURL: server.socketURL)
        let exported = try await client.layouts.export(
            tabID: TabID(rawValue: "t1"),
            paneID: PaneID(rawValue: "p1")
        )
        #expect(exported.root == .pane(PaneID(rawValue: "p1")))
        #expect(
            try await client.layouts.setSplitRatio(
                tabID: TabID(rawValue: "t1"),
                path: [false, true],
                ratio: 0.25
            ) == exported
        )
        #expect(recorder.requests.count == 2)
    }

    @Test
    func rawCall() async throws {
        let server = try FakeHerdrServer { descriptor, request in
            FakeHerdrServer.sendJSON([
                "id": request["id"] ?? "",
                "result": ["answer": 42],
            ], to: descriptor)
        }
        defer { server.stop() }
        let client = HerdrClient(socketURL: server.socketURL)
        #expect(
            try await client.rawRequest(method: "future.raw")
                == .object(["answer": .integer(42)])
        )
    }

    @Test
    func genericServiceCall() async throws {
        let server = try FakeHerdrServer { descriptor, request in
            FakeHerdrServer.sendJSON([
                "id": request["id"] ?? "",
                "result": ["type": "ok"],
            ], to: descriptor)
        }
        defer { server.stop() }
        let client = HerdrClient(socketURL: server.socketURL)
        let success = try await client.server.send(
            HerdrEndpoint(method: .workspaceFocus, params: HerdrEmptyParameters())
        )
        if case .ok = success {
            // Expected.
        } else {
            Issue.record("Expected an ok result")
        }
    }

    @Test
    func typedSendAndRequestOverloads() async throws {
        let server = try FakeHerdrServer { descriptor, request in
            FakeHerdrServer.sendJSON([
                "id": request["id"] ?? "",
                "result": ["value": "typed"],
            ], to: descriptor)
        }
        defer { server.stop() }

        struct Response: Codable, Sendable {
            let value: String
        }
        let request = HerdrTypedRequest<HerdrEmptyParameters, Response>(
            method: .ping,
            params: .init()
        )
        let client = HerdrClient(socketURL: server.socketURL)
        #expect(try await client.send(request).value == "typed")
    }

    @Test
    func snapshotRejectsIncompatibleServers() async throws {
        for (version, protocolVersion, expected) in [
            ("0.7.4", 18, "version"),
            ("0.7.5", 19, "protocol"),
        ] {
            let server = try FakeHerdrServer { descriptor, request in
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": [
                        "snapshot": emptySession(
                            version: version,
                            protocolVersion: UInt(protocolVersion)
                        ),
                    ],
                ], to: descriptor)
            }
            defer { server.stop() }
            do {
                _ = try await HerdrClient(socketURL: server.socketURL).sessions.snapshot()
                Issue.record("Expected \(expected) compatibility failure")
            } catch is HerdrCompatibilityError {
                // Expected.
            }
        }
    }

    @Test
    func protocol17SessionSupportsSharedAPIsAndRejectsProtocol18Features() async throws {
        let recorder = RequestRecorder()
        let server = try FakeHerdrServer { descriptor, request in
            recorder.append(request)
            let result: Any
            switch request["method"] as? String {
            case "session.snapshot":
                result = ["snapshot": emptySession(protocolVersion: 17)]
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
        #expect(try await client.sessions.snapshot().protocolVersion == 17)
        #expect(await client.protocolVersion == 17)
        #expect(await client.capabilities?.workspaceBlockReordering == false)
        try await client.workspaces.focus(WorkspaceID(rawValue: "w1"))

        let expected = HerdrCompatibilityError.featureUnavailable(
            feature: "workspace.move_block",
            introduced: 18,
            actual: 17
        )
        await #expect(throws: expected) {
            try await client.send(HerdrEndpoints.workspaceMoveBlock(
                .init(beforeWorkspaceID: nil, workspaceIDS: ["w1"])
            ))
        }
        await #expect(throws: expected) {
            try await client.rawRequest(method: "workspace.move_block")
        }
        await #expect(throws: HerdrCompatibilityError.featureUnavailable(
            feature: "workspace.reordered",
            introduced: 18,
            actual: 17
        )) {
            _ = try await client.events.subscribe([
                .init(type: "workspace.reordered"),
            ])
        }
        #expect(recorder.requests.map { $0["method"] as? String } == [
            "session.snapshot", "workspace.focus",
        ])
    }

    @Test
    func protocol18FeatureProbesUnknownServerAndExposesCapabilities() async throws {
        let recorder = RequestRecorder()
        let server = try FakeHerdrServer { descriptor, request in
            recorder.append(request)
            let result: Any
            switch request["method"] as? String {
            case "ping":
                result = ["version": "0.7.5", "protocol": 18]
            case "workspace.move_block":
                result = ["type": "workspace_list", "workspaces": []]
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
        let result = try await client.send(HerdrEndpoints.workspaceMoveBlock(
            .init(beforeWorkspaceID: nil, workspaceIDS: ["w1"])
        ))
        if case .workspaceList = result {
            // Expected.
        } else {
            Issue.record("Expected workspace_list")
        }
        #expect(await client.protocolVersion == 18)
        #expect(await client.capabilities?.workspaceBlockReordering == true)
        #expect(recorder.requests.map { $0["method"] as? String } == [
            "ping", "workspace.move_block",
        ])

        await #expect(throws: HerdrCompatibilityError.featureObsoleted(
            feature: "workspace.focus",
            obsoleted: 18,
            actual: 18
        )) {
            try await client.send(ObsoletedRequest())
        }
    }
}

private struct ObsoletedRequest: HerdrRequest {
    typealias Parameters = HerdrEmptyParameters
    typealias Response = HerdrResponseResult

    let method = HerdrMethod.workspaceFocus
    let params = HerdrEmptyParameters()
    let availability = HerdrProtocolAvailability(
        introduced: 17,
        obsoleted: 18
    )
}

private func workspaceObject() -> [String: Any] {
    [
        "workspace_id": "w1", "number": 1, "label": "space", "focused": true,
        "pane_count": 1, "tab_count": 1, "active_tab_id": "t1",
        "agent_status": "idle",
    ]
}

private func tabObject() -> [String: Any] {
    [
        "tab_id": "t1", "workspace_id": "w1", "number": 1, "label": "tab",
        "focused": true, "pane_count": 1, "agent_status": "idle",
    ]
}

private func paneObjectForService() -> [String: Any] {
    [
        "pane_id": "p1", "terminal_id": "term1", "workspace_id": "w1",
        "tab_id": "t1", "focused": true, "agent_status": "idle", "revision": 1,
    ]
}

private func layoutObject() -> [String: Any] {
    [
        "workspace_id": "w1",
        "tab_id": "t1",
        "zoomed": false,
        "focused_pane_id": "p1",
        "root": ["type": "pane", "pane_id": "p1"],
    ]
}
