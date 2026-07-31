import Foundation
@testable import HerdrSDK
import Testing

@Suite
struct ModelCoverageTests {
    @Test
    func identifiersProtocolRequestsAndStaticEndpoint() async throws {
        #expect(HerdrRequestID(rawValue: "r").rawValue == "r")
        #expect(WorkspaceID(rawValue: "w").rawValue == "w")
        #expect(TabID(rawValue: "t").rawValue == "t")
        #expect(PaneID(rawValue: "p").rawValue == "p")
        #expect(TerminalID(rawValue: "term").rawValue == "term")

        let endpoint = HerdrEndpoint(method: .ping, params: HerdrEmptyParameters())
        #expect(endpoint.method == .ping)
        _ = endpoint.params

        let typed = HerdrTypedRequest<HerdrEmptyParameters, HerdrJSONValue>(
            method: .ping,
            params: .init()
        )
        #expect(typed.method == .ping)
        _ = typed.params

        let url = URL(fileURLWithPath: "/tmp/herdr.sock")
        #expect(try await HerdrStaticEndpoint(url: url).socketURL() == url)
        _ = HerdrClient(
            endpointProvider: HerdrStaticEndpoint(url: url),
            sessionObservationTiming: .production
        )
    }

    @Test(
        "JSON values round-trip",
        arguments: [
            HerdrJSONValue.null,
            .bool(true),
            .integer(Int64.max),
            .double(1.25),
            .string("sheep"),
            .array([.integer(1), .null]),
            .object(["nested": .bool(false)]),
        ]
    )
    func jsonValueRoundTrip(value: HerdrJSONValue) throws {
        let encoded = try JSONEncoder().encode(value)
        #expect(try JSONDecoder().decode(HerdrJSONValue.self, from: encoded) == value)
        #expect(try HerdrJSONValue.encode(value, encoder: JSONEncoder()) == value)
    }

    @Test
    func errorsDescribeEveryCase() {
        #expect(HerdrAPIError(code: "x", message: "message").errorDescription == "message")
        #expect(
            HerdrCompatibilityError.protocolMismatch(expected: 18, actual: 19)
                .errorDescription == "HerdrSDK requires protocol 18; the server reports 19."
        )
        #expect(
            HerdrCompatibilityError.versionTooOld(minimum: "0.7.5", actual: "0.7.4")
                .errorDescription == "HerdrSDK requires Herdr 0.7.5 or newer; the server reports 0.7.4."
        )
        #expect(
            HerdrCompatibilityError.unknownResultDiscriminator("future")
                .errorDescription
                == "Herdr returned an unknown protocol-18 result discriminator: future."
        )
        #expect(
            HerdrCompatibilityError.unknownEventDiscriminator("future")
                .errorDescription
                == "Herdr emitted an unknown protocol-18 event discriminator: future."
        )
    }

    @Test
    func sessionSelectionSortingAndEmptyFallbacks() throws {
        let tabOne: Tab = try decode([
            "tab_id": "t1", "workspace_id": "w1", "number": 1, "label": "one",
            "focused": false, "pane_count": 1, "agent_status": "idle",
        ])
        let tabTwo: Tab = try decode([
            "tab_id": "t2", "workspace_id": "w1", "number": 2, "label": "two",
            "focused": false, "pane_count": 1, "agent_status": "idle",
        ])
        let workspace: Workspace = try decode([
            "workspace_id": "w1", "number": 1, "label": "space", "focused": false,
            "pane_count": 1, "tab_count": 2, "active_tab_id": "missing",
            "agent_status": "idle",
        ])
        let pane: Pane = try decode(paneObject(id: "p1", tabID: "t1", focused: false))
        let session = HerdrSession(
            version: "0.7.5",
            protocolVersion: 18,
            focusedWorkspaceID: nil,
            focusedTabID: nil,
            focusedPaneID: nil,
            workspaces: [workspace],
            tabs: [tabTwo, tabOne],
            panes: [pane],
            agents: []
        )

        #expect(session.focusedWorkspace == workspace)
        #expect(session.focusedTab == tabOne)
        #expect(session.focusedPane == pane)
        #expect(session.tabs(in: workspace.id).map(\.id) == [tabOne.id, tabTwo.id])
        #expect(session.panes(in: tabTwo.id).isEmpty)

        let explicitlyFocused = HerdrSession(
            version: "0.7.5",
            protocolVersion: 18,
            focusedWorkspaceID: workspace.id,
            focusedTabID: tabTwo.id,
            focusedPaneID: pane.id,
            workspaces: [workspace],
            tabs: [tabOne, tabTwo],
            panes: [pane],
            agents: []
        )
        #expect(explicitlyFocused.focusedWorkspace == workspace)
        #expect(explicitlyFocused.focusedTab == tabTwo)
        #expect(explicitlyFocused.focusedPane == pane)

        let empty = HerdrSession(
            version: "0.7.5",
            protocolVersion: 18,
            focusedWorkspaceID: WorkspaceID(rawValue: "missing"),
            focusedTabID: TabID(rawValue: "missing"),
            focusedPaneID: PaneID(rawValue: "missing"),
            workspaces: [],
            tabs: [],
            panes: [],
            agents: []
        )
        #expect(empty.focusedWorkspace == nil)
        #expect(empty.focusedTab == nil)
        #expect(empty.focusedPane == nil)
    }

    @Test
    func displayFallbacksAndAgentIdentity() throws {
        let paneValues: [(String, [String: Any])] = [
            ("display", ["display_agent": "display"]),
            ("title", ["title": "title"]),
            ("terminal", ["terminal_title_stripped": "terminal"]),
            ("label", ["label": "label"]),
            ("agent", ["agent": "agent"]),
            ("terminal", [:]),
        ]
        for (expected, additions) in paneValues {
            var object = paneObject()
            additions.forEach { object[$0] = $1 }
            let pane: Pane = try decode(object)
            #expect(pane.displayTitle == expected)
        }

        let agentValues: [(String, [String: Any])] = [
            ("display", ["display_agent": "display"]),
            ("agent", ["agent": "agent"]),
            ("name", ["name": "name"]),
            ("agent", [:]),
        ]
        for (expected, additions) in agentValues {
            var object = agentObject()
            additions.forEach { object[$0] = $1 }
            let agent: Agent = try decode(object)
            #expect(agent.displayName == expected)
            #expect(agent.id == agent.paneID)
        }

        let contexts: [(String, [String: Any])] = [
            ("title", ["title": "title"]),
            ("terminal", ["terminal_title_stripped": "terminal"]),
            ("/foreground", ["foreground_cwd": "/foreground"]),
            ("/cwd", ["cwd": "/cwd"]),
            ("", [:]),
        ]
        for (expected, additions) in contexts {
            var object = agentObject()
            additions.forEach { object[$0] = $1 }
            #expect(try decode(object, as: Agent.self).displayContext == expected)
        }
    }

    @Test
    func paneLayoutRoundTripsBothNodeKinds() throws {
        let root = PaneLayout.Node.split(
            direction: .down,
            ratio: 0.4,
            first: .pane(PaneID(rawValue: "p1")),
            second: .pane(PaneID(rawValue: "p2"))
        )
        let layout = PaneLayout(
            workspaceID: WorkspaceID(rawValue: "w1"),
            tabID: TabID(rawValue: "t1"),
            zoomed: false,
            focusedPaneID: PaneID(rawValue: "p1"),
            root: root
        )
        #expect(layout.visibleRoot == root)
        #expect(root.paneIDs().map(\.rawValue) == ["p1", "p2"])
        #expect(root.leavesWithPaths(path: [true]).map(\.path) == [
            [true, false],
            [true, true],
        ])

        let encoded = try JSONEncoder().encode(layout)
        #expect(try JSONDecoder().decode(PaneLayout.self, from: encoded) == layout)
    }

    @Test
    func compatibilityAcceptsAndRejectsEveryBoundary() throws {
        try validateCompatibility(session(version: "0.7.5"))
        try validateCompatibility(session(version: "0.7.5-beta.1"))
        try validateCompatibility(session(version: "1.0"))

        #expect(throws: HerdrCompatibilityError.protocolMismatch(expected: 18, actual: 17)) {
            try validateCompatibility(session(protocolVersion: 17))
        }
        #expect(throws: HerdrCompatibilityError.versionTooOld(minimum: "0.7.5", actual: "0.7.4")) {
            try validateCompatibility(session(version: "0.7.4"))
        }
        #expect(throws: HerdrCompatibilityError.versionTooOld(minimum: "0.7.5", actual: "invalid")) {
            try validateCompatibility(session(version: "invalid"))
        }
        #expect(throws: HerdrCompatibilityError.versionTooOld(minimum: "0.7.5", actual: "")) {
            try validateCompatibility(session(version: ""))
        }
    }
}

private func decode<T: Decodable>(
    _ object: [String: Any],
    as type: T.Type = T.self
) throws -> T {
    try JSONDecoder().decode(
        T.self,
        from: JSONSerialization.data(withJSONObject: object)
    )
}

private func session(
    version: String = "0.7.5",
    protocolVersion: UInt = 18
) -> HerdrSession {
    HerdrSession(
        version: version,
        protocolVersion: protocolVersion,
        focusedWorkspaceID: nil,
        focusedTabID: nil,
        focusedPaneID: nil,
        workspaces: [],
        tabs: [],
        panes: [],
        agents: []
    )
}

private func paneObject(
    id: String = "p1",
    tabID: String = "t1",
    focused: Bool = true
) -> [String: Any] {
    [
        "pane_id": id,
        "terminal_id": "term1",
        "workspace_id": "w1",
        "tab_id": tabID,
        "focused": focused,
        "agent_status": "idle",
        "revision": 1,
    ]
}

private func agentObject() -> [String: Any] {
    [
        "terminal_id": "term1",
        "agent_status": "idle",
        "workspace_id": "w1",
        "tab_id": "t1",
        "pane_id": "p1",
        "focused": true,
        "revision": 1,
    ]
}
