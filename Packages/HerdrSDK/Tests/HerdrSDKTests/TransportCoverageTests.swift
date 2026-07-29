import Darwin
import Foundation
@testable import HerdrSDK
import Testing

@Suite(.serialized)
struct TransportCoverageTests {
    @Test
    func synchronousTransportRequestAndPayload() throws {
        let server = try FakeHerdrServer { descriptor, request in
            FakeHerdrServer.sendJSON([
                "id": request["id"] ?? "",
                "result": ["answer": 42],
            ], to: descriptor)
        }
        defer { server.stop() }

        let transport = HerdrSocketTransport(socketURL: server.socketURL)
        let result = try transport.request(
            method: "future.answer",
            paramsData: Data(#"{"question":"life"}"#.utf8),
            requestID: HerdrRequestID(rawValue: "fixed")
        )
        let object = try #require(
            JSONSerialization.jsonObject(with: result) as? [String: Any]
        )
        #expect(object["answer"] as? Int == 42)

        let payload = try transport.requestPayload(
            method: "future.answer",
            paramsData: Data(#"{"question":"life"}"#.utf8),
            requestID: HerdrRequestID(rawValue: "fixed")
        )
        #expect(payload.last == 0x0A)
        let request = try #require(
            JSONSerialization.jsonObject(with: payload.dropLast()) as? [String: Any]
        )
        #expect(request["id"] as? String == "fixed")
        #expect(request["method"] as? String == "future.answer")
    }

    @Test
    func transportRejectsMalformedParametersAndSocketPaths() {
        let transport = HerdrSocketTransport(socketURL: URL(fileURLWithPath: "/tmp/unused"))
        #expect(throws: (any Error).self) {
            try transport.requestPayload(
                method: "bad",
                paramsData: Data("not-json".utf8),
                requestID: HerdrRequestID(rawValue: "1")
            )
        }

        let longPath = "/tmp/" + String(repeating: "x", count: 256)
        do {
            _ = try HerdrSocketTransport(
                socketURL: URL(fileURLWithPath: longPath)
            ).openSocketDescriptor()
            Issue.record("Expected an overlong socket path failure")
        } catch let error as POSIXError {
            #expect(error.code == .ENAMETOOLONG)
        } catch {
            Issue.record(error)
        }

        do {
            _ = try HerdrSocketTransport(
                socketURL: URL(fileURLWithPath: "/tmp/missing-\(UUID()).sock")
            ).openSocketDescriptor()
            Issue.record("Expected a connection failure")
        } catch let error as POSIXError {
            #expect(error.code == .ENOENT || error.code == .ECONNREFUSED)
        } catch {
            Issue.record(error)
        }

        do {
            _ = try HerdrSocketTransport(
                socketURL: URL(fileURLWithPath: "/tmp/unused"),
                socketFactory: { -1 }
            ).openSocketDescriptor()
            Issue.record("Expected socket creation failure")
        } catch {
            #expect(error is POSIXError)
        }
    }

    @Test(arguments: [
        Data("[]".utf8),
        Data(#"{"result":{}}"#.utf8),
        Data(#"{"id":3,"result":{}}"#.utf8),
    ])
    func malformedResponseEnvelopesAreRejected(_ data: Data) {
        do {
            _ = try HerdrSocketTransport.validatedResult(
                from: data,
                requestID: HerdrRequestID(rawValue: "expected")
            )
            Issue.record("Expected malformed response")
        } catch let error as HerdrAPIError {
            #expect(error.code == "malformed_response")
        } catch {
            Issue.record(error)
        }
    }

    @Test
    func missingResultAndDefaultServerErrorAreTyped() {
        do {
            _ = try HerdrSocketTransport.validatedResult(
                from: Data(#"{"id":"expected"}"#.utf8),
                requestID: HerdrRequestID(rawValue: "expected")
            )
            Issue.record("Expected missing result failure")
        } catch let error as HerdrAPIError {
            #expect(error.code == "malformed_response")
        } catch {
            Issue.record(error)
        }

        do {
            _ = try HerdrSocketTransport.validatedResult(
                from: Data(#"{"id":"expected","error":{}}"#.utf8),
                requestID: HerdrRequestID(rawValue: "expected")
            )
            Issue.record("Expected server error")
        } catch let error as HerdrAPIError {
            #expect(error.code == "unknown")
            #expect(error.message == "Herdr returned an unknown error.")
        } catch {
            Issue.record(error)
        }
    }

    @Test
    func writeAllSupportsEmptyDataAndReportsClosedPeer() throws {
        var descriptors = [Int32](repeating: -1, count: 2)
        #expect(socketpair(AF_UNIX, SOCK_STREAM, 0, &descriptors) == 0)
        defer { Darwin.close(descriptors[0]) }
        var noSignal: Int32 = 1
        setsockopt(
            descriptors[0],
            SOL_SOCKET,
            SO_NOSIGPIPE,
            &noSignal,
            socklen_t(MemoryLayout<Int32>.size)
        )

        try HerdrSocketTransport.writeAll(Data(), to: descriptors[0])
        Darwin.close(descriptors[1])
        #expect(throws: (any Error).self) {
            try HerdrSocketTransport.writeAll(Data([1]), to: descriptors[0])
        }
        #expect(
            HerdrSocketTransport.posixError(Int32.max, fallback: .EIO).code == .EIO
        )
        #expect(
            HerdrSocketTransport.posixError(EACCES, fallback: .EIO).code == .EACCES
        )
    }

    @Test
    func operationCancelledBeforeRunThrowsCancellation() throws {
        let server = try FakeHerdrServer { _, _ in }
        defer { server.stop() }
        let operation = HerdrSocketTransport(socketURL: server.socketURL)
            .makeRequestOperation(
                method: "cancelled",
                paramsData: Data("{}".utf8),
                requestID: HerdrRequestID(rawValue: "cancelled")
            )
        operation.cancel()
        operation.cancel()
        #expect(throws: CancellationError.self) {
            try operation.run()
        }
    }

    @Test
    func lineReaderPreservesCoalescedLinesAndReportsEOF() throws {
        var descriptors = [Int32](repeating: -1, count: 2)
        #expect(socketpair(AF_UNIX, SOCK_STREAM, 0, &descriptors) == 0)
        let reader = DescriptorLineReader(descriptor: descriptors[0])
        defer { Darwin.close(descriptors[0]) }

        try HerdrSocketTransport.writeAll(Data("one\ntwo\n".utf8), to: descriptors[1])
        Darwin.close(descriptors[1])
        #expect(try String(decoding: reader.readLine(), as: UTF8.self) == "one")
        #expect(try String(decoding: reader.readLine(), as: UTF8.self) == "two")
        do {
            _ = try reader.readLine()
            Issue.record("Expected EOF")
        } catch let error as POSIXError {
            #expect(error.code == .ECONNRESET)
        }
    }

    @Test
    func lineReaderRejectsOversizedLines() throws {
        var descriptors = [Int32](repeating: -1, count: 2)
        #expect(socketpair(AF_UNIX, SOCK_STREAM, 0, &descriptors) == 0)
        let reader = DescriptorLineReader(descriptor: descriptors[0], maximumLineBytes: 1_024)
        let writer = descriptors[1]
        var noSignal: Int32 = 1
        setsockopt(
            writer,
            SOL_SOCKET,
            SO_NOSIGPIPE,
            &noSignal,
            socklen_t(MemoryLayout<Int32>.size)
        )
        DispatchQueue.global(qos: .userInitiated).async {
            let chunk = Data(repeating: 0x61, count: 4_096)
            try? HerdrSocketTransport.writeAll(chunk, to: writer)
            Darwin.close(writer)
        }
        defer {
            Darwin.close(descriptors[0])
        }
        do {
            _ = try reader.readLine()
            Issue.record("Expected oversized line")
        } catch let error as HerdrAPIError {
            #expect(error.code == "oversized_response")
        }
    }
}
