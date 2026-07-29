import Foundation
@testable import HerdrSDK
import Testing

@Suite(.serialized)
struct SessionObservationTests {
    private let timing = HerdrSessionObservationTiming(
        reconnectPollInterval: .milliseconds(3),
        safetyRefreshInterval: .milliseconds(15),
        debounceDelay: .milliseconds(2),
        retryDelays: [.milliseconds(2), .milliseconds(4)]
    )

    @Test
    func timingCapsRetryDelay() {
        #expect(timing.retryDelay(at: 0) == .milliseconds(2))
        #expect(timing.retryDelay(at: 20) == .milliseconds(4))
    }

    @Test
    func observationBootstrapsRefreshesAndResubscribesForNewPanes() async throws {
        let recorder = RequestRecorder()
        let firstPane = observedPane(id: "p1")
        let secondPane = observedPane(id: "p2")
        let server = try FakeHerdrServer { descriptor, request in
            recorder.append(request)
            switch request["method"] as? String {
            case "session.snapshot":
                let panes = recorder.count(method: "session.snapshot") == 1
                    ? [firstPane]
                    : [firstPane, secondPane]
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": ["snapshot": emptySession(panes: panes)],
                ], to: descriptor)
            case "events.subscribe":
                var data = FakeHerdrServer.jsonLine([
                    "id": request["id"] ?? "",
                    "result": ["type": "subscription_started"],
                ])
                if recorder.count(method: "events.subscribe") == 1 {
                    data += FakeHerdrServer.jsonLine([
                        "event": "workspace_updated",
                        "data": [
                            "type": "workspace_updated",
                            "workspace_id": "w1",
                        ],
                    ])
                }
                FakeHerdrServer.send(data, to: descriptor)
                Thread.sleep(forTimeInterval: 0.1)
            case "workspace.create":
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": [
                        "workspace": observationWorkspace(),
                        "tab": observationTab(),
                        "root_pane": observationPaneObject(),
                    ],
                ], to: descriptor)
            case "tab.create":
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": [
                        "tab": observationTab(),
                        "root_pane": observationPaneObject(),
                    ],
                ], to: descriptor)
            case "layout.export", "layout.set_split_ratio":
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": ["layout": observationLayout()],
                ], to: descriptor)
            default:
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": ["type": "ok"],
                ], to: descriptor)
            }
        }
        defer { server.stop() }

        let client = HerdrClient(
            socketURL: server.socketURL,
            sessionObservationTiming: timing
        )
        let stream = await client.sessionUpdates()
        let updates = UpdateRecorder()
        let consumer = Task {
            for await update in stream {
                updates.append(update)
            }
        }
        let secondStream = await client.sessionUpdates()
        let secondConsumer = Task {
            for await _ in secondStream {}
        }
        defer {
            consumer.cancel()
            secondConsumer.cancel()
        }

        #expect(
            await eventually {
                recorder.count(method: "session.snapshot") >= 2
                    && recorder.count(method: "events.subscribe") >= 2
            }
        )
        #expect(
            await eventually {
                await client.currentSession?.panes.count == 2
            }
        )
        #expect(updates.values.contains { $0.connection == .connected })

        let subscriptions = recorder.requests.filter {
            $0["method"] as? String == "events.subscribe"
        }
        let latestParams = try #require(subscriptions.last?["params"] as? [String: Any])
        let filters = try #require(latestParams["subscriptions"] as? [[String: Any]])
        #expect(filters.contains { $0["pane_id"] as? String == "p2" })

        try await client.focusWorkspace(WorkspaceID(rawValue: "w1"))
        try await client.focusTab(TabID(rawValue: "t1"))
        try await client.focusPane(PaneID(rawValue: "p1"))
        try await client.focusPane(PaneID(rawValue: "p1"))
        try await client.createWorkspace(cwd: URL(fileURLWithPath: "/tmp/workspace"))
        try await client.createTab(workspaceID: WorkspaceID(rawValue: "w1"))
        #expect(
            try await client.exportLayout(tabID: TabID(rawValue: "t1")).focusedPaneID
                == PaneID(rawValue: "p1")
        )
        try await client.setSplitRatio(
            tabID: TabID(rawValue: "t1"),
            path: [false],
            ratio: 0.4
        )
        #expect(
            await eventually {
                recorder.count(method: "pane.focus") == 2
                    && recorder.count(method: "session.snapshot") >= 3
            }
        )

        consumer.cancel()
        _ = await consumer.result
        #expect(await client.sessionRunTask != nil)

        server.stop()
        await client.refreshSession()
        #expect(
            await eventually {
                let state = await client.sessionConnection
                if case .disconnected = state { return true }
                return false
            }
        )
    }

    @Test
    func safetyRefreshRunsWithoutEvents() async throws {
        let recorder = RequestRecorder()
        let server = try FakeHerdrServer { descriptor, request in
            recorder.append(request)
            if request["method"] as? String == "session.snapshot" {
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": ["snapshot": emptySession()],
                ], to: descriptor)
            } else {
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": ["type": "subscription_started"],
                ], to: descriptor)
                Thread.sleep(forTimeInterval: 0.1)
            }
        }
        defer { server.stop() }
        let client = HerdrClient(
            socketURL: server.socketURL,
            sessionObservationTiming: timing
        )
        let stream = await client.sessionUpdates()
        let consumer = Task { for await _ in stream {} }
        defer { consumer.cancel() }
        #expect(
            await eventually {
                recorder.count(method: "session.snapshot") >= 2
            }
        )
    }

    @Test
    func closedSubscriptionPublishesDisconnectedThenReconnects() async throws {
        let recorder = RequestRecorder()
        let server = try FakeHerdrServer { descriptor, request in
            recorder.append(request)
            if request["method"] as? String == "session.snapshot" {
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": ["snapshot": emptySession()],
                ], to: descriptor)
            } else {
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": ["type": "subscription_started"],
                ], to: descriptor)
            }
        }
        defer { server.stop() }
        let client = HerdrClient(
            socketURL: server.socketURL,
            sessionObservationTiming: timing
        )
        let stream = await client.sessionUpdates()
        let updates = UpdateRecorder()
        let consumer = Task {
            for await update in stream { updates.append(update) }
        }
        defer { consumer.cancel() }

        #expect(
            await eventually {
                updates.values.contains {
                    if case .disconnected = $0.connection { return true }
                    return false
                } && recorder.count(method: "session.snapshot") >= 2
            }
        )
    }

    @Test
    func cancellingManualRefreshIsSilent() async throws {
        let server = try FakeHerdrServer { descriptor, request in
            if request["method"] as? String == "session.snapshot" {
                Thread.sleep(forTimeInterval: 0.1)
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": ["snapshot": emptySession()],
                ], to: descriptor)
            } else {
                FakeHerdrServer.sendJSON([
                    "id": request["id"] ?? "",
                    "result": ["type": "subscription_started"],
                ], to: descriptor)
                Thread.sleep(forTimeInterval: 0.1)
            }
        }
        defer { server.stop() }
        let client = HerdrClient(
            socketURL: server.socketURL,
            sessionObservationTiming: timing
        )
        let stream = await client.sessionUpdates()
        let consumer = Task { for await _ in stream {} }
        defer { consumer.cancel() }
        try await Task.sleep(for: .milliseconds(5))

        let refresh = Task { await client.refreshSession() }
        try await Task.sleep(for: .milliseconds(5))
        refresh.cancel()
        await refresh.value
    }

    @Test
    func unavailableConnectionRetriesAndRetainsConnectingSemantics() async {
        let missing = URL(fileURLWithPath: "/tmp/missing-\(UUID()).sock")
        let client = HerdrClient(
            socketURL: missing,
            sessionObservationTiming: timing
        )
        let stream = await client.sessionUpdates()
        let updates = UpdateRecorder()
        let consumer = Task {
            for await update in stream {
                updates.append(update)
            }
        }

        #expect(
            await eventually {
                updates.values.contains {
                    if case .unavailable = $0.connection { return true }
                    return false
                }
            }
        )
        #expect(updates.values.first?.connection == .connecting)

        consumer.cancel()
        _ = await consumer.result
        #expect(
            await eventually {
                let runTask = await client.sessionRunTask
                let connection = await client.sessionConnection
                return runTask == nil && connection == .connecting
            }
        )
    }

    @Test
    func manualRefreshBeforeObservationIsANoOp() async {
        let client = HerdrClient(
            socketURL: URL(fileURLWithPath: "/tmp/missing-\(UUID()).sock"),
            sessionObservationTiming: timing
        )
        await client.refreshSession()
        #expect(await client.currentSession == nil)
        #expect(await client.sessionConnection == .connecting)
    }
}

private final class UpdateRecorder: @unchecked Sendable {
    private let lock = NSLock()
    private var storage: [HerdrSessionUpdate] = []

    var values: [HerdrSessionUpdate] {
        lock.withLock { storage }
    }

    func append(_ update: HerdrSessionUpdate) {
        lock.withLock { storage.append(update) }
    }
}

private func eventually(
    timeout: Duration = .seconds(1),
    condition: @escaping @Sendable () async -> Bool
) async -> Bool {
    let clock = ContinuousClock()
    let deadline = clock.now.advanced(by: timeout)
    while clock.now < deadline {
        if await condition() { return true }
        try? await Task.sleep(for: .milliseconds(2))
    }
    return await condition()
}

private func observedPane(id: String) -> Pane {
    Pane(
        id: PaneID(rawValue: id),
        terminalID: TerminalID(rawValue: "term-\(id)"),
        workspaceID: WorkspaceID(rawValue: "w1"),
        tabID: TabID(rawValue: "t1"),
        focused: id == "p1",
        cwd: nil,
        foregroundCWD: nil,
        label: nil,
        agent: nil,
        title: nil,
        terminalTitle: nil,
        displayAgent: nil,
        agentStatus: .idle,
        revision: 1
    )
}

private func observationWorkspace() -> [String: Any] {
    [
        "workspace_id": "w1", "number": 1, "label": "space", "focused": true,
        "pane_count": 1, "tab_count": 1, "active_tab_id": "t1",
        "agent_status": "idle",
    ]
}

private func observationTab() -> [String: Any] {
    [
        "tab_id": "t1", "workspace_id": "w1", "number": 1, "label": "tab",
        "focused": true, "pane_count": 1, "agent_status": "idle",
    ]
}

private func observationPaneObject() -> [String: Any] {
    [
        "pane_id": "p1", "terminal_id": "term1", "workspace_id": "w1",
        "tab_id": "t1", "focused": true, "agent_status": "idle", "revision": 1,
    ]
}

private func observationLayout() -> [String: Any] {
    [
        "workspace_id": "w1", "tab_id": "t1", "zoomed": false,
        "focused_pane_id": "p1",
        "root": ["type": "pane", "pane_id": "p1"],
    ]
}
