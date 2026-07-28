import Foundation
import HerdrSDK
import HerdrSDKLocal
import XCTest

final class HerdrSDKTests: XCTestCase {
    func testSchemaCatalogCoversProtocol17() {
        XCTAssertEqual(HerdrProtocolMetadata.protocolVersion, 17)
        XCTAssertEqual(
            HerdrSchemaCatalog.methods,
            Set(HerdrMethod.allCases.map(\.rawValue))
        )
        XCTAssertEqual(HerdrSchemaCatalog.methods.count, 90)
        XCTAssertEqual(HerdrSchemaCatalog.resultTypes.count, 57)
    }

    func testLocalAttachmentUsesDirectTakeover() async throws {
        let executable = URL(fileURLWithPath: "/bin/echo")
        let server = HerdrLocalServer(
            configuration: .init(executableURL: executable)
        )
        let attachment = try await server.terminalAttachment(
            terminalID: .init(rawValue: "term_123")
        )
        XCTAssertEqual(attachment.executableURL, executable)
        XCTAssertEqual(attachment.arguments, [
            "terminal",
            "attach",
            "term_123",
            "--takeover",
        ])
    }

    func testProtocolSnapshotIgnoresUnknownFields() throws {
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
        XCTAssertEqual(snapshot.protocolVersion, 17)
        XCTAssertTrue(snapshot.layouts.isEmpty)
    }

    func testUnknownResultAndEventDiscriminatorsFailDecoding() {
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                HerdrResponseResult.self,
                from: Data(#"{"type":"future_result"}"#.utf8)
            )
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                HerdrLifecycleEvent.self,
                from: Data(
                    #"{"event":"future.event","data":{"type":"future_event"}}"#.utf8
                )
            )
        )
    }

    func testStrongIdentifiersAndArbitraryJSONRoundTrip() throws {
        let paneID = PaneID(rawValue: "pane_9223372036854775807")
        let target = HerdrRequestPaneTarget(paneID: paneID)
        let encodedTarget = try JSONEncoder().encode(target)
        XCTAssertEqual(
            try JSONDecoder().decode(HerdrRequestPaneTarget.self, from: encodedTarget).paneID,
            paneID
        )

        let value = HerdrJSONValue.object([
            "large": .integer(Int64.max),
            "nested": .array([.bool(true), .null]),
        ])
        let encodedValue = try JSONEncoder().encode(value)
        XCTAssertEqual(try JSONDecoder().decode(HerdrJSONValue.self, from: encodedValue), value)
    }

    func testInstalledHerdrSnapshotContractWhenAvailable() throws {
        let executable: URL
        do {
            executable = try HerdrExecutableLocator().locate()
        } catch {
            throw XCTSkip("Herdr is not installed")
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
            throw XCTSkip("No running local Herdr server")
        }

        let response = try JSONDecoder().decode(SnapshotEnvelope.self, from: data)
        XCTAssertEqual(response.result.snapshot.protocolVersion, 17)
        XCTAssertFalse(response.result.snapshot.workspaces.isEmpty)
    }
}

private struct SnapshotEnvelope: Decodable {
    struct Result: Decodable {
        let snapshot: HerdrSession
    }

    let result: Result
}
