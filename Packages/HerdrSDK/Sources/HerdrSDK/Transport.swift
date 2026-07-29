import Darwin
import Foundation

public protocol HerdrEndpointProvider: Sendable {
    func socketURL() async throws -> URL
}

public struct HerdrStaticEndpoint: HerdrEndpointProvider {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func socketURL() async throws -> URL { url }
}

struct HerdrSocketTransport: Sendable {
    let socketURL: URL
    private let socketFactory: @Sendable () -> Int32

    init(
        socketURL: URL,
        socketFactory: @escaping @Sendable () -> Int32 = {
            Darwin.socket(AF_UNIX, SOCK_STREAM, 0)
        }
    ) {
        self.socketURL = socketURL
        self.socketFactory = socketFactory
    }

    func makeRequestOperation(
        method: String,
        paramsData: Data,
        requestID: HerdrRequestID = .init(rawValue: UUID().uuidString)
    ) -> HerdrSocketRequestOperation {
        HerdrSocketRequestOperation(
            transport: self,
            method: method,
            paramsData: paramsData,
            requestID: requestID
        )
    }

    func request(
        method: String,
        paramsData: Data,
        requestID: HerdrRequestID = .init(rawValue: UUID().uuidString)
    ) throws -> Data {
        try makeRequestOperation(
            method: method,
            paramsData: paramsData,
            requestID: requestID
        ).run()
    }

    func requestPayload(
        method: String,
        paramsData: Data,
        requestID: HerdrRequestID
    ) throws -> Data {
        let params = try JSONSerialization.jsonObject(with: paramsData)
        var payload = try JSONSerialization.data(withJSONObject: [
            "id": requestID.rawValue,
            "method": method,
            "params": params,
        ])
        payload.append(0x0A)
        return payload
    }

    func openSubscription(
        filters: [HerdrEventFilter],
        requestID: HerdrRequestID = .init(rawValue: "herdr-sdk-events-\(UUID().uuidString)")
    ) throws -> HerdrEventConnection {
        let encoder = JSONEncoder()
        let paramsData = try encoder.encode(SubscribeParameters(subscriptions: filters))
        let params = try JSONSerialization.jsonObject(with: paramsData)
        var payload = try JSONSerialization.data(withJSONObject: [
            "id": requestID.rawValue,
            "method": HerdrMethod.eventsSubscribe.rawValue,
            "params": params,
        ])
        payload.append(0x0A)
        return HerdrEventConnection(
            descriptor: try openSocketDescriptor(),
            requestID: requestID,
            requestPayload: payload
        )
    }

    func openGraphicsStream(
        paneID: PaneID,
        requestID: HerdrRequestID = .init(rawValue: "herdr-sdk-graphics-\(UUID().uuidString)")
    ) throws -> HerdrPaneGraphicsStream {
        let descriptor = try openSocketDescriptor()
        var payload = try JSONSerialization.data(withJSONObject: [
            "id": requestID.rawValue,
            "method": HerdrMethod.paneGraphicsStream.rawValue,
            "params": ["pane_id": paneID.rawValue],
        ])
        payload.append(0x0A)
        do {
            try Self.writeAll(payload, to: descriptor)
            let response = try DescriptorLineReader(descriptor: descriptor).readLine()
            _ = try Self.validatedResult(from: response, requestID: requestID)
            return HerdrPaneGraphicsStream(descriptor: descriptor)
        } catch {
            Darwin.close(descriptor)
            throw error
        }
    }

    func openSocketDescriptor() throws -> Int32 {
        let descriptor = socketFactory()
        guard descriptor >= 0 else {
            throw Self.posixError(errno, fallback: .EIO)
        }
        var noSignal: Int32 = 1
        setsockopt(
            descriptor,
            SOL_SOCKET,
            SO_NOSIGPIPE,
            &noSignal,
            socklen_t(MemoryLayout<Int32>.size)
        )

        var address = sockaddr_un()
        address.sun_family = sa_family_t(AF_UNIX)
        let bytes = Array(socketURL.path.utf8CString)
        guard bytes.count <= MemoryLayout.size(ofValue: address.sun_path) else {
            Darwin.close(descriptor)
            throw POSIXError(.ENAMETOOLONG)
        }
        withUnsafeMutableBytes(of: &address.sun_path) { destination in
            bytes.withUnsafeBytes { destination.copyBytes(from: $0) }
        }
        let result = withUnsafePointer(to: &address) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                Darwin.connect(
                    descriptor,
                    $0,
                    socklen_t(MemoryLayout<sockaddr_un>.size)
                )
            }
        }
        guard result == 0 else {
            let code = errno
            Darwin.close(descriptor)
            throw Self.posixError(code, fallback: .ECONNREFUSED)
        }
        return descriptor
    }

    static func validatedResult(
        from data: Data,
        requestID: HerdrRequestID
    ) throws -> Data {
        guard let envelope = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let responseID = envelope["id"] as? String else {
            throw HerdrAPIError(
                code: "malformed_response",
                message: "Herdr sent a malformed response."
            )
        }
        guard responseID == requestID.rawValue else {
            throw HerdrAPIError(
                code: "response_id_mismatch",
                message: "Herdr responded to \(responseID), expected \(requestID.rawValue)."
            )
        }
        if let error = envelope["error"] as? [String: Any] {
            throw HerdrAPIError(
                code: error["code"] as? String ?? "unknown",
                message: error["message"] as? String ?? "Herdr returned an unknown error."
            )
        }
        guard let result = envelope["result"] else {
            throw HerdrAPIError(
                code: "malformed_response",
                message: "Herdr response has no result."
            )
        }
        return try JSONSerialization.data(withJSONObject: result)
    }

    static func writeAll(_ data: Data, to descriptor: Int32) throws {
        guard !data.isEmpty else { return }
        try data.withUnsafeBytes { rawBuffer in
            let base = rawBuffer.baseAddress!
            var sent = 0
            while sent < data.count {
                let count = Darwin.send(
                    descriptor,
                    base.advanced(by: sent),
                    data.count - sent,
                    0
                )
                guard count > 0 else {
                    throw Self.posixError(errno, fallback: .EIO)
                }
                sent += count
            }
        }
    }

    static func posixError(
        _ code: Int32,
        fallback: POSIXErrorCode
    ) -> POSIXError {
        POSIXError(POSIXErrorCode(rawValue: code) ?? fallback)
    }
}

final class HerdrSocketRequestOperation: @unchecked Sendable {
    private let transport: HerdrSocketTransport
    private let method: String
    private let paramsData: Data
    private let requestID: HerdrRequestID
    private let lock = NSLock()
    private var descriptor: Int32?
    private var cancelled = false

    init(
        transport: HerdrSocketTransport,
        method: String,
        paramsData: Data,
        requestID: HerdrRequestID
    ) {
        self.transport = transport
        self.method = method
        self.paramsData = paramsData
        self.requestID = requestID
    }

    func run() throws -> Data {
        let payload = try transport.requestPayload(
            method: method,
            paramsData: paramsData,
            requestID: requestID
        )
        let socket = try transport.openSocketDescriptor()
        let mayRun = lock.withLock {
            guard !cancelled else { return false }
            descriptor = socket
            return true
        }
        guard mayRun else {
            Darwin.close(socket)
            throw CancellationError()
        }
        defer { closeIfOwned(socket) }

        do {
            try HerdrSocketTransport.writeAll(payload, to: socket)
            let response = try DescriptorLineReader(descriptor: socket).readLine()
            return try HerdrSocketTransport.validatedResult(
                from: response,
                requestID: requestID
            )
        } catch {
            if lock.withLock({ cancelled }) {
                throw CancellationError()
            }
            throw error
        }
    }

    func cancel() {
        let socket = lock.withLock { () -> Int32? in
            guard !cancelled else { return nil }
            cancelled = true
            defer { descriptor = nil }
            return descriptor
        }
        guard let socket else { return }
        Darwin.shutdown(socket, SHUT_RDWR)
        Darwin.close(socket)
    }

    private func closeIfOwned(_ socket: Int32) {
        let shouldClose = lock.withLock {
            guard descriptor == socket else { return false }
            descriptor = nil
            return true
        }
        if shouldClose {
            Darwin.close(socket)
        }
    }
}

private struct SubscribeParameters: Encodable {
    let subscriptions: [HerdrEventFilter]
}

final class DescriptorLineReader {
    private let descriptor: Int32
    private let maximumLineBytes: Int
    private var buffer = Data()

    init(descriptor: Int32, maximumLineBytes: Int = 32 * 1_024 * 1_024) {
        self.descriptor = descriptor
        self.maximumLineBytes = maximumLineBytes
    }

    func readLine() throws -> Data {
        while buffer.firstIndex(of: 0x0A) == nil {
            var bytes = [UInt8](repeating: 0, count: 4_096)
            let count = Darwin.read(descriptor, &bytes, bytes.count)
            guard count > 0 else { break }
            buffer.append(contentsOf: bytes.prefix(count))
            guard buffer.count <= maximumLineBytes else {
                throw HerdrAPIError(
                    code: "oversized_response",
                    message: "Herdr response is larger than 32 MiB."
                )
            }
        }
        guard let newline = buffer.firstIndex(of: 0x0A) else {
            throw POSIXError(.ECONNRESET)
        }
        let line = Data(buffer.prefix(upTo: newline))
        buffer.removeSubrange(...newline)
        return line
    }
}
