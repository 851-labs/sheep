import Darwin
import Foundation
@testable import HerdrSDK

final class RequestRecorder: @unchecked Sendable {
    private let lock = NSLock()
    private var storage: [[String: Any]] = []

    var requests: [[String: Any]] {
        lock.withLock { storage }
    }

    func append(_ request: [String: Any]) {
        lock.withLock { storage.append(request) }
    }

    func count(method: String) -> Int {
        lock.withLock {
            storage.count { $0["method"] as? String == method }
        }
    }
}

final class FakeHerdrServer: @unchecked Sendable {
    typealias Handler = @Sendable (Int32, [String: Any]) -> Void

    let socketURL: URL
    private let descriptor: Int32
    private let handler: Handler
    private let lock = NSLock()
    private var stopped = false

    init(handler: @escaping Handler) throws {
        self.handler = handler
        socketURL = URL(
            fileURLWithPath: "/tmp/herdr-sdk-\(UUID().uuidString.prefix(8)).sock"
        )
        let listener = Darwin.socket(AF_UNIX, SOCK_STREAM, 0)
        guard listener >= 0 else { throw POSIXError(.EIO) }
        descriptor = listener
        Darwin.unlink(socketURL.path)

        var address = sockaddr_un()
        address.sun_family = sa_family_t(AF_UNIX)
        let bytes = Array(socketURL.path.utf8CString)
        withUnsafeMutableBytes(of: &address.sun_path) { destination in
            bytes.withUnsafeBytes { destination.copyBytes(from: $0) }
        }
        let bound = withUnsafePointer(to: &address) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                Darwin.bind(listener, $0, socklen_t(MemoryLayout<sockaddr_un>.size))
            }
        }
        guard bound == 0, Darwin.listen(listener, 16) == 0 else {
            Darwin.close(listener)
            throw POSIXError(POSIXErrorCode(rawValue: errno) ?? .EIO)
        }
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            acceptLoop()
        }
    }

    deinit {
        stop()
    }

    func stop() {
        let shouldStop = lock.withLock {
            guard !stopped else { return false }
            stopped = true
            return true
        }
        guard shouldStop else { return }
        Darwin.shutdown(descriptor, SHUT_RDWR)
        Darwin.close(descriptor)
        Darwin.unlink(socketURL.path)
    }

    private func acceptLoop() {
        while !lock.withLock({ stopped }) {
            let client = Darwin.accept(descriptor, nil, nil)
            guard client >= 0 else { return }
            DispatchQueue.global(qos: .userInitiated).async { [handler] in
                defer { Darwin.close(client) }
                guard let request = Self.readRequest(from: client) else { return }
                handler(client, request)
            }
        }
    }

    static func readRequest(from descriptor: Int32) -> [String: Any]? {
        var data = Data()
        var bytes = [UInt8](repeating: 0, count: 4_096)
        while true {
            let count = Darwin.read(descriptor, &bytes, bytes.count)
            guard count > 0 else { return nil }
            data.append(contentsOf: bytes.prefix(count))
            if let newline = data.firstIndex(of: 0x0A) {
                return (try? JSONSerialization.jsonObject(
                    with: data.prefix(upTo: newline)
                )) as? [String: Any]
            }
        }
    }

    static func jsonLine(_ object: [String: Any]) -> Data {
        var data = try! JSONSerialization.data(withJSONObject: object)
        data.append(0x0A)
        return data
    }

    static func sendJSON(_ object: [String: Any], to descriptor: Int32) {
        send(jsonLine(object), to: descriptor)
    }

    static func send(_ data: Data, to descriptor: Int32) {
        data.withUnsafeBytes { rawBuffer in
            guard let base = rawBuffer.baseAddress else { return }
            var sent = 0
            while sent < data.count {
                let count = Darwin.send(
                    descriptor,
                    base.advanced(by: sent),
                    data.count - sent,
                    0
                )
                guard count > 0 else { return }
                sent += count
            }
        }
    }
}

func emptySession(
    version: String = "0.7.5",
    protocolVersion: UInt = 17,
    panes: [Pane] = []
) -> [String: Any] {
    [
        "version": version,
        "protocol": protocolVersion,
        "focused_workspace_id": NSNull(),
        "focused_tab_id": NSNull(),
        "focused_pane_id": NSNull(),
        "workspaces": [],
        "tabs": [],
        "panes": panes.map { pane in
            [
                "pane_id": pane.id.rawValue,
                "terminal_id": pane.terminalID.rawValue,
                "workspace_id": pane.workspaceID.rawValue,
                "tab_id": pane.tabID.rawValue,
                "focused": pane.focused,
                "agent_status": pane.agentStatus.rawValue,
                "revision": pane.revision,
            ] as [String: Any]
        },
        "layouts": [],
        "agents": [],
    ]
}
