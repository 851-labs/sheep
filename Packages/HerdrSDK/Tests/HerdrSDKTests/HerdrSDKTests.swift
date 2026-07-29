import Foundation
import HerdrSDK
import HerdrSDKLocal
import Testing

@Suite
struct HerdrSDKTests {
    @Test
    func schemaCatalogCoversProtocol17() {
        #expect(HerdrProtocolMetadata.protocolVersion == 17)
        #expect(
            HerdrSchemaCatalog.methods
                == Set(HerdrMethod.allCases.map(\.rawValue))
        )
        #expect(HerdrSchemaCatalog.methods.count == 90)
        #expect(HerdrSchemaCatalog.resultTypes.count == 57)
    }

    @Test
    func localAttachmentUsesDirectTakeover() async throws {
        let executable = URL(fileURLWithPath: "/bin/echo")
        let server = HerdrLocalServer(
            configuration: .init(executableURL: executable)
        )
        let attachment = try await server.terminalAttachment(
            terminalID: .init(rawValue: "term_123")
        )
        #expect(attachment.executableURL == executable)
        #expect(attachment.arguments == [
            "terminal",
            "attach",
            "term_123",
            "--takeover",
        ])
    }

    @Test
    func protocolSnapshotIgnoresUnknownFields() throws {
        let data = Data(
            """
            {
              "version": "0.7.5",
              "protocol": 17,
              "focused_workspace_id": null,
              "focused_tab_id": null,
              "focused_pane_id": null,
              "workspaces": [],
              "tabs": [],
              "panes": [],
              "layouts": [],
              "agents": [],
              "future_field": {"safe": true}
            }
            """.utf8
        )
        let snapshot = try JSONDecoder().decode(HerdrSession.self, from: data)
        #expect(snapshot.protocolVersion == 17)
        #expect(snapshot.layouts.isEmpty)
    }

    @Test
    func unknownResultAndEventDiscriminatorsFailDecoding() {
        do {
            _ = try JSONDecoder().decode(
                HerdrResponseResult.self,
                from: Data(#"{"type":"future_result"}"#.utf8)
            )
            Issue.record("Expected an unknown result discriminator")
        } catch {
            #expect(
                error as? HerdrCompatibilityError
                    == .unknownResultDiscriminator("future_result")
            )
        }
        #expect(throws: (any Error).self) {
            try JSONDecoder().decode(
                HerdrLifecycleEvent.self,
                from: Data(
                    #"{"event":"future.event","data":{"type":"future_event"}}"#.utf8
                )
            )
        }
    }

    @Test
    func strongIdentifiersAndArbitraryJSONRoundTrip() throws {
        let paneID = PaneID(rawValue: "pane_9223372036854775807")
        let target = HerdrRequestPaneTarget(paneID: paneID)
        let encodedTarget = try JSONEncoder().encode(target)
        #expect(
            try JSONDecoder()
                .decode(HerdrRequestPaneTarget.self, from: encodedTarget)
                .paneID == paneID
        )

        let value = HerdrJSONValue.object([
            "large": .integer(Int64.max),
            "nested": .array([.bool(true), .null]),
        ])
        let encodedValue = try JSONEncoder().encode(value)
        #expect(try JSONDecoder().decode(HerdrJSONValue.self, from: encodedValue) == value)
    }

    @Test
    func installedHerdrSnapshotContractWhenAvailable() throws {
        let executable: URL
        do {
            executable = try HerdrExecutableLocator().locate()
        } catch {
            return
        }

        let process = Process()
        let output = Pipe()
        process.executableURL = executable
        process.arguments = ["api", "snapshot"]
        process.standardOutput = output
        try process.run()
        let data = output.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        guard process.terminationStatus == 0 else {
            return
        }

        let response = try JSONDecoder().decode(SnapshotEnvelope.self, from: data)
        #expect(response.result.snapshot.protocolVersion == 17)
        #expect(!response.result.snapshot.workspaces.isEmpty)
    }
}

private struct SnapshotEnvelope: Decodable {
    struct Result: Decodable {
        let snapshot: HerdrSession
    }

    let result: Result
}
