import Darwin
import Foundation
import SheepDomain

public struct HerdrAPIError: LocalizedError, Sendable {
    public let code: String
    public let message: String

    public var errorDescription: String? { message }
}

struct HerdrSocketClient: Sendable {
    let socketURL: URL

    func request(method: String, params: [String: Any] = [:]) throws -> Data {
        let handle = try openSocket()
        defer { try? handle.close() }
        try handle.write(contentsOf: Self.requestPayload(method: method, params: params))
        let response = try SocketLineReader(handle: handle).readLine()
        try validateHerdrResponse(response)
        return response
    }

    func ping() throws {
        _ = try request(method: "ping")
    }

    func makeSubscription(paneIDs: [PaneID]) throws -> HerdrEventSubscription {
        var subscriptions: [[String: Any]] = [
            ["type": "workspace.created"],
            ["type": "workspace.updated"],
            ["type": "workspace.metadata_updated"],
            ["type": "workspace.renamed"],
            ["type": "workspace.moved"],
            ["type": "workspace.closed"],
            ["type": "workspace.focused"],
            ["type": "tab.created"],
            ["type": "tab.closed"],
            ["type": "tab.focused"],
            ["type": "tab.renamed"],
            ["type": "tab.moved"],
            ["type": "pane.created"],
            ["type": "pane.closed"],
            ["type": "pane.updated"],
            ["type": "pane.focused"],
            ["type": "pane.moved"],
            ["type": "pane.exited"],
            ["type": "pane.agent_detected"],
            ["type": "layout.updated"],
        ]
        subscriptions += paneIDs.map {
            ["type": "pane.agent_status_changed", "pane_id": $0.rawValue]
        }

        let payload = try Self.requestPayload(
            method: "events.subscribe",
            params: ["subscriptions": subscriptions],
            id: "sheep-events-\(UUID().uuidString)"
        )
        let descriptor = try openSocketDescriptor()
        return HerdrEventSubscription(descriptor: descriptor, requestPayload: payload)
    }

    fileprivate func openSocket() throws -> FileHandle {
        FileHandle(fileDescriptor: try openSocketDescriptor(), closeOnDealloc: true)
    }

    private func openSocketDescriptor() throws -> Int32 {
        let descriptor = Darwin.socket(AF_UNIX, SOCK_STREAM, 0)
        guard descriptor >= 0 else {
            throw POSIXError(POSIXErrorCode(rawValue: errno) ?? .EIO)
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
        let path = socketURL.path
        let pathBytes = Array(path.utf8CString)
        let capacity = MemoryLayout.size(ofValue: address.sun_path)
        guard pathBytes.count <= capacity else {
            Darwin.close(descriptor)
            throw POSIXError(.ENAMETOOLONG)
        }

        withUnsafeMutableBytes(of: &address.sun_path) { destination in
            pathBytes.withUnsafeBytes { source in
                destination.copyBytes(from: source)
            }
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
            throw POSIXError(POSIXErrorCode(rawValue: code) ?? .ECONNREFUSED)
        }
        return descriptor
    }

    private static func requestPayload(
        method: String,
        params: [String: Any],
        id: String = UUID().uuidString
    ) throws -> Data {
        var payload = try JSONSerialization.data(withJSONObject: [
            "id": id,
            "method": method,
            "params": params,
        ])
        payload.append(0x0A)
        return payload
    }
}

final class HerdrEventSubscription: @unchecked Sendable {
    let id = UUID()
    private let descriptor: Int32
    private let requestPayload: Data
    private let stateLock = NSLock()
    private var cancelled = false

    fileprivate init(descriptor: Int32, requestPayload: Data) {
        self.descriptor = descriptor
        self.requestPayload = requestPayload
    }

    deinit {
        cancel()
    }

    func run(onEvent: @escaping @Sendable (Data) -> Void) throws {
        defer { closeConnection() }
        try writeAll(requestPayload)
        let reader = DescriptorLineReader(descriptor: descriptor)
        try validateHerdrResponse(reader.readLine())

        while !isCancelled {
            let event = try reader.readLine()
            guard (try? JSONSerialization.jsonObject(with: event)) != nil else {
                throw HerdrAPIError(
                    code: "malformed_event",
                    message: "Herdr sent a malformed event."
                )
            }
            onEvent(event)
        }
    }

    func cancel() {
        closeConnection()
    }

    private func closeConnection() {
        stateLock.lock()
        guard !cancelled else {
            stateLock.unlock()
            return
        }
        cancelled = true
        stateLock.unlock()
        Darwin.shutdown(descriptor, SHUT_RDWR)
        Darwin.close(descriptor)
    }

    private var isCancelled: Bool {
        stateLock.withLock { cancelled }
    }

    private func writeAll(_ data: Data) throws {
        try data.withUnsafeBytes { rawBuffer in
            guard let base = rawBuffer.baseAddress else { return }
            var sent = 0
            while sent < data.count {
                let count = Darwin.send(
                    descriptor,
                    base.advanced(by: sent),
                    data.count - sent,
                    0
                )
                guard count > 0 else {
                    throw POSIXError(POSIXErrorCode(rawValue: errno) ?? .EIO)
                }
                sent += count
            }
        }
    }
}

private final class SocketLineReader {
    private let handle: FileHandle
    private var buffer = Data()

    init(handle: FileHandle) {
        self.handle = handle
    }

    func readLine() throws -> Data {
        while true {
            if let newline = buffer.firstIndex(of: 0x0A) {
                let line = Data(buffer.prefix(upTo: newline))
                buffer.removeSubrange(...newline)
                return line
            }
            guard let chunk = try handle.read(upToCount: 4_096), !chunk.isEmpty else {
                throw POSIXError(.ECONNRESET)
            }
            buffer.append(chunk)
            guard buffer.count <= 32 * 1_024 * 1_024 else {
                throw HerdrAPIError(
                    code: "oversized_response",
                    message: "Herdr response is too large."
                )
            }
        }
    }
}

private final class DescriptorLineReader {
    private let descriptor: Int32
    private var buffer = Data()

    init(descriptor: Int32) {
        self.descriptor = descriptor
    }

    func readLine() throws -> Data {
        while true {
            if let newline = buffer.firstIndex(of: 0x0A) {
                let line = Data(buffer.prefix(upTo: newline))
                buffer.removeSubrange(...newline)
                return line
            }
            var bytes = [UInt8](repeating: 0, count: 4_096)
            let count = Darwin.read(descriptor, &bytes, bytes.count)
            guard count > 0 else {
                throw POSIXError(.ECONNRESET)
            }
            buffer.append(contentsOf: bytes.prefix(count))
            guard buffer.count <= 32 * 1_024 * 1_024 else {
                throw HerdrAPIError(
                    code: "oversized_response",
                    message: "Herdr response is too large."
                )
            }
        }
    }
}

private func validateHerdrResponse(_ data: Data) throws {
    guard let object = try? JSONSerialization.jsonObject(with: data),
          let envelope = object as? [String: Any] else {
        throw HerdrAPIError(code: "malformed_response", message: "Herdr sent a malformed response.")
    }
    if let error = envelope["error"] as? [String: Any] {
        throw HerdrAPIError(
            code: error["code"] as? String ?? "unknown",
            message: error["message"] as? String ?? "Herdr returned an unknown error."
        )
    }
    guard envelope.keys.contains("result") else {
        throw HerdrAPIError(code: "malformed_response", message: "Herdr response has no result.")
    }
}
