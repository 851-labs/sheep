import Foundation
import HerdrSDK

public actor HerdrLocalServer: HerdrEndpointProvider {
    public let configuration: HerdrLocalConfiguration
    private var launchedProcess: Process?
    private var logHandle: FileHandle?

    public init(configuration: HerdrLocalConfiguration = .init()) {
        self.configuration = configuration
    }

    public func socketURL() async throws -> URL {
        try await ensureRunning()
    }

    public func ensureRunning() async throws -> URL {
        let socketURL = resolvedSocketURL
        if await isReady(socketURL) {
            return socketURL
        }

        let executable = try executableURL()
        if launchedProcess?.isRunning != true {
            try launch(executable)
        }

        let clock = ContinuousClock()
        let deadline = clock.now.advanced(by: configuration.startupTimeout)
        var attempt = 0
        while clock.now < deadline {
            if await isReady(socketURL) {
                return socketURL
            }
            let milliseconds = min(100 + attempt * 20, 500)
            try await Task.sleep(for: .milliseconds(milliseconds))
            attempt += 1
        }
        throw HerdrLocalError.startupTimedOut
    }

    public func terminalAttachment(
        terminalID: TerminalID,
        takeover: Bool = true
    ) throws -> HerdrTerminalAttachment {
        try HerdrTerminalAttachmentFactory(executableURL: executableURL())
            .attachment(terminalID: terminalID, takeover: takeover)
    }

    public func executableURL() throws -> URL {
        if let explicit = configuration.executableURL {
            guard FileManager.default.isExecutableFile(atPath: explicit.path) else {
                throw HerdrLocalError.executableNotFound
            }
            return explicit
        }
        return try HerdrExecutableLocator(environment: configuration.environment).locate()
    }

    private var resolvedSocketURL: URL {
        if let explicit = configuration.socketURL {
            return explicit
        }
        if let override = configuration.environment["HERDR_SOCKET_PATH"] {
            return URL(fileURLWithPath: override)
        }
        return FileManager.default.homeDirectoryForCurrentUser
            .appending(path: ".config/herdr/herdr.sock")
    }

    private func isReady(_ socketURL: URL) async -> Bool {
        let client = HerdrClient(socketURL: socketURL)
        return (try? await client.server.ping()) != nil
    }

    private func launch(_ executableURL: URL) throws {
        let logURL = configuration.logURL ?? FileManager.default
            .homeDirectoryForCurrentUser
            .appending(path: "Library/Logs/HerdrSDK/herdr-server.log")
        try FileManager.default.createDirectory(
            at: logURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        if !FileManager.default.fileExists(atPath: logURL.path) {
            FileManager.default.createFile(atPath: logURL.path, contents: nil)
        }
        let handle = try FileHandle(forWritingTo: logURL)
        try handle.seekToEnd()

        let process = Process()
        process.executableURL = executableURL
        process.arguments = ["server"]
        process.standardOutput = handle
        process.standardError = handle
        do {
            try process.run()
        } catch {
            try? handle.close()
            throw HerdrLocalError.launchFailed(error.localizedDescription)
        }
        launchedProcess = process
        logHandle = handle
    }
}

public struct HerdrTerminalAttachment: Equatable, Sendable {
    public let executableURL: URL
    public let arguments: [String]

    public init(executableURL: URL, arguments: [String]) {
        self.executableURL = executableURL
        self.arguments = arguments
    }
}

public struct HerdrTerminalAttachmentFactory: Equatable, Sendable {
    public let executableURL: URL

    public init(executableURL: URL) throws {
        guard FileManager.default.isExecutableFile(atPath: executableURL.path) else {
            throw HerdrLocalError.executableNotFound
        }
        self.executableURL = executableURL
    }

    public func attachment(
        terminalID: TerminalID,
        takeover: Bool = true
    ) -> HerdrTerminalAttachment {
        var arguments = ["terminal", "attach", terminalID.rawValue]
        if takeover {
            arguments.append("--takeover")
        }
        return HerdrTerminalAttachment(
            executableURL: executableURL,
            arguments: arguments
        )
    }
}

public struct HerdrLocalRuntime: Sendable {
    public let server: HerdrLocalServer
    public let client: HerdrClient

    public init(configuration: HerdrLocalConfiguration = .init()) {
        let server = HerdrLocalServer(configuration: configuration)
        self.server = server
        client = HerdrClient(endpointProvider: server)
    }
}

public extension HerdrClient {
    static func local(
        configuration: HerdrLocalConfiguration = .init()
    ) -> HerdrClient {
        HerdrClient(endpointProvider: HerdrLocalServer(configuration: configuration))
    }
}
