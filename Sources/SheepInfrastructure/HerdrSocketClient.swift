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
        let request: [String: Any] = [
            "id": UUID().uuidString,
            "method": method,
            "params": params,
        ]
        var payload = try JSONSerialization.data(withJSONObject: request)
        payload.append(0x0A)

        let handle = try openSocket()
        defer { try? handle.close() }
        try handle.write(contentsOf: payload)
        let response = try readLine(from: handle)
        try validate(response)
        return response
    }

    func ping() throws {
        _ = try request(method: "ping")
    }

    func subscribe(
        paneIDs: [PaneID],
        onEvent: @escaping @Sendable (Data) -> Void
    ) throws {
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

        let request: [String: Any] = [
            "id": "sheep-events-\(UUID().uuidString)",
            "method": "events.subscribe",
            "params": ["subscriptions": subscriptions],
        ]
        var payload = try JSONSerialization.data(withJSONObject: request)
        payload.append(0x0A)

        let handle = try openSocket()
        defer { try? handle.close() }
        try handle.write(contentsOf: payload)

        _ = try readLine(from: handle)
        while true {
            let event = try readLine(from: handle)
            onEvent(event)
        }
    }

    private func openSocket() throws -> FileHandle {
        let descriptor = Darwin.socket(AF_UNIX, SOCK_STREAM, 0)
        guard descriptor >= 0 else {
            throw POSIXError(POSIXErrorCode(rawValue: errno) ?? .EIO)
        }

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
        return FileHandle(fileDescriptor: descriptor, closeOnDealloc: true)
    }

    private func readLine(from handle: FileHandle) throws -> Data {
        var buffer = Data()
        while true {
            guard let chunk = try handle.read(upToCount: 4_096), !chunk.isEmpty else {
                throw POSIXError(.ECONNRESET)
            }
            buffer.append(chunk)
            if let newline = buffer.firstIndex(of: 0x0A) {
                return buffer.prefix(upTo: newline)
            }
            guard buffer.count <= 32 * 1_024 * 1_024 else {
                throw HerdrAPIError(code: "oversized_response", message: "Herdr response is too large.")
            }
        }
    }

    private func validate(_ data: Data) throws {
        if let envelope = try? JSONDecoder().decode(ErrorEnvelope.self, from: data) {
            throw HerdrAPIError(code: envelope.error.code, message: envelope.error.message)
        }
    }
}

private struct ErrorEnvelope: Decodable {
    let error: HerdrAPIErrorBody
}

private struct HerdrAPIErrorBody: Decodable {
    let code: String
    let message: String
}
