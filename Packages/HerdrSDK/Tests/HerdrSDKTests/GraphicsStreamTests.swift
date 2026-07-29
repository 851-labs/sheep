import Darwin
import Foundation
@testable import HerdrSDK
import Testing

@Suite(.serialized)
struct GraphicsStreamTests {
    @Test
    func frameWritesHeaderAndBinaryPayload() throws {
        var descriptors = [Int32](repeating: -1, count: 2)
        #expect(socketpair(AF_UNIX, SOCK_STREAM, 0, &descriptors) == 0)
        let stream = HerdrPaneGraphicsStream(descriptor: descriptors[0])
        defer {
            stream.close()
            Darwin.close(descriptors[1])
        }

        let frame = HerdrGraphicsFrame(
            format: .rgba,
            imageWidth: 640,
            imageHeight: 480,
            placement: .init(
                viewportColumn: 2,
                viewportRow: 3,
                gridColumns: 20,
                gridRows: 10
            ),
            data: Data([1, 2, 3, 4])
        )
        try stream.send(frame)

        let header = try #require(
            try JSONSerialization.jsonObject(
                with: readLine(from: descriptors[1])
            ) as? [String: Any]
        )
        #expect(header["format"] as? String == "rgba")
        #expect(header["image_width"] as? Int == 640)
        #expect(header["image_height"] as? Int == 480)
        #expect(header["data_length"] as? Int == 4)
        let placement = try #require(header["placement"] as? [String: Any])
        #expect(placement["viewport_col"] as? Int == 2)
        #expect(placement["viewport_row"] as? Int == 3)
        #expect(placement["grid_cols"] as? Int == 20)
        #expect(placement["grid_rows"] as? Int == 10)
        #expect(try readExactly(4, from: descriptors[1]) == frame.data)
    }

    @Test
    func closeIsIdempotentAndRejectsFurtherFrames() throws {
        var descriptors = [Int32](repeating: -1, count: 2)
        #expect(socketpair(AF_UNIX, SOCK_STREAM, 0, &descriptors) == 0)
        let stream = HerdrPaneGraphicsStream(descriptor: descriptors[0])
        defer { Darwin.close(descriptors[1]) }

        stream.close()
        stream.close()
        do {
            try stream.send(
                .init(
                    format: .png,
                    imageWidth: 1,
                    imageHeight: 1,
                    placement: .init(
                        viewportColumn: 0,
                        viewportRow: 0,
                        gridColumns: 1,
                        gridRows: 1
                    ),
                    data: Data()
                )
            )
            Issue.record("Expected the closed stream to reject frames")
        } catch let error as HerdrAPIError {
            #expect(error.code == "graphics_stream_closed")
        }
    }

    @Test
    func clientPerformsGraphicsHandshakeBeforeStreaming() async throws {
        let requestCapture = RequestRecorder()
        let server = try FakeHerdrServer { descriptor, request in
            requestCapture.append(request)
            FakeHerdrServer.sendJSON([
                "id": request["id"] ?? "",
                "result": ["type": "pane_graphics_info"],
            ], to: descriptor)
            _ = readLine(from: descriptor)
        }
        defer { server.stop() }

        let stream = try await HerdrClient(socketURL: server.socketURL)
            .openGraphicsStream(paneID: PaneID(rawValue: "p9"))
        stream.close()

        let request = try #require(requestCapture.requests.first)
        #expect(request["method"] as? String == "pane.graphics.stream")
        let params = try #require(request["params"] as? [String: Any])
        #expect(params["pane_id"] as? String == "p9")
    }

    @Test
    func graphicsHandshakeFailureClosesAndSurfacesError() async throws {
        let server = try FakeHerdrServer { descriptor, request in
            FakeHerdrServer.sendJSON([
                "id": request["id"] ?? "",
                "error": ["code": "closed", "message": "pane closed"],
            ], to: descriptor)
        }
        defer { server.stop() }

        do {
            _ = try await HerdrClient(socketURL: server.socketURL)
                .openGraphicsStream(paneID: PaneID(rawValue: "closed"))
            Issue.record("Expected graphics handshake failure")
        } catch let error as HerdrAPIError {
            #expect(error.code == "closed")
        }
    }
}

private func readLine(from descriptor: Int32) -> Data {
    var data = Data()
    var byte: UInt8 = 0
    while Darwin.read(descriptor, &byte, 1) == 1 {
        if byte == 0x0A { break }
        data.append(byte)
    }
    return data
}

private func readExactly(_ count: Int, from descriptor: Int32) throws -> Data {
    var data = Data()
    var bytes = [UInt8](repeating: 0, count: count)
    while data.count < count {
        let readCount = Darwin.read(
            descriptor,
            &bytes,
            min(bytes.count, count - data.count)
        )
        guard readCount > 0 else { throw POSIXError(.ECONNRESET) }
        data.append(contentsOf: bytes.prefix(readCount))
    }
    return data
}
