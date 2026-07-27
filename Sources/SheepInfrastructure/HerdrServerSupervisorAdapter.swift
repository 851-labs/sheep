import Foundation
import SheepApplication

public enum HerdrServerError: LocalizedError, Sendable {
    case startupTimedOut
    case launchFailed(String)

    public var errorDescription: String? {
        switch self {
        case .startupTimedOut:
            "Herdr did not become ready in time."
        case let .launchFailed(message):
            "Herdr could not be started: \(message)"
        }
    }
}

public actor HerdrServerSupervisorAdapter: HerdrServerSupervisor {
    private let locator: HerdrExecutableLocator
    private let socketURL: URL
    private let fileManager: FileManager
    private var launchedProcess: Process?
    private var logHandle: FileHandle?

    public init(
        locator: HerdrExecutableLocator = .init(),
        socketURL: URL? = nil,
        fileManager: FileManager = .default
    ) {
        self.locator = locator
        self.fileManager = fileManager
        if let socketURL {
            self.socketURL = socketURL
        } else if let override = ProcessInfo.processInfo.environment["HERDR_SOCKET_PATH"] {
            self.socketURL = URL(fileURLWithPath: override)
        } else {
            self.socketURL = fileManager.homeDirectoryForCurrentUser
                .appending(path: ".config/herdr/herdr.sock")
        }
    }

    public func ensureRunning() async throws -> URL {
        let client = HerdrSocketClient(socketURL: socketURL)
        if (try? client.ping()) != nil {
            return socketURL
        }

        let executable = try locator.locate()
        if launchedProcess?.isRunning != true {
            try launch(executable)
        }

        for attempt in 0..<50 {
            if (try? client.ping()) != nil {
                return socketURL
            }
            let delay = UInt64(min(100 + attempt * 20, 500)) * 1_000_000
            try await Task.sleep(nanoseconds: delay)
        }
        throw HerdrServerError.startupTimedOut
    }

    private func launch(_ executable: URL) throws {
        let logsDirectory = fileManager.homeDirectoryForCurrentUser
            .appending(path: "Library/Application Support/Sheep/Logs", directoryHint: .isDirectory)
        try fileManager.createDirectory(at: logsDirectory, withIntermediateDirectories: true)
        let logURL = logsDirectory.appending(path: "herdr-server.log")
        if !fileManager.fileExists(atPath: logURL.path) {
            fileManager.createFile(atPath: logURL.path, contents: nil)
        }

        let handle = try FileHandle(forWritingTo: logURL)
        try handle.seekToEnd()
        let process = Process()
        process.executableURL = executable
        process.arguments = ["server"]
        process.standardOutput = handle
        process.standardError = handle
        do {
            try process.run()
        } catch {
            try? handle.close()
            throw HerdrServerError.launchFailed(error.localizedDescription)
        }

        launchedProcess = process
        logHandle = handle
    }
}

