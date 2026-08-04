import Foundation
import HerdrSDK

public struct HerdrLocalConfiguration: Sendable {
    public var executableURL: URL?
    public var socketURL: URL?
    public var logURL: URL?
    public var environment: [String: String]
    public var startupTimeout: Duration

    public init(
        executableURL: URL? = nil,
        socketURL: URL? = nil,
        logURL: URL? = nil,
        environment: [String: String] = ProcessInfo.processInfo.environment,
        startupTimeout: Duration = .seconds(15)
    ) {
        self.executableURL = executableURL
        self.socketURL = socketURL
        self.logURL = logURL
        self.environment = environment
        self.startupTimeout = startupTimeout
    }

    public var resolvedSocketURL: URL {
        if let socketURL {
            return socketURL
        }
        if let override = environment["HERDR_SOCKET_PATH"] {
            return URL(fileURLWithPath: override)
        }
        return FileManager.default.homeDirectoryForCurrentUser
            .appending(path: ".config/herdr/herdr.sock")
    }

    public func resolvedExecutableURL() throws -> URL {
        var locatorEnvironment = environment
        if let executableURL {
            guard FileManager.default.isExecutableFile(atPath: executableURL.path) else {
                throw HerdrLocalError.executableNotFound
            }
            locatorEnvironment["HERDR_BIN_PATH"] = executableURL.path
            locatorEnvironment["PATH"] = ""
            return try HerdrExecutableLocator(
                environment: locatorEnvironment,
                standardPaths: []
            ).locate(compatibleWith: resolvedSocketURL)
        }
        return try HerdrExecutableLocator(environment: locatorEnvironment)
            .locate(compatibleWith: resolvedSocketURL)
    }
}

public enum HerdrLocalError: LocalizedError, Equatable, Sendable {
    case executableNotFound
    case noCompatibleExecutable(serverProtocol: UInt?)
    case startupTimedOut
    case launchFailed(String)

    public var errorDescription: String? {
        switch self {
        case .executableNotFound:
            "Herdr is not installed. Install Herdr and try again."
        case let .noCompatibleExecutable(protocolVersion):
            if let protocolVersion {
                "No installed Herdr executable supports the running server's protocol \(protocolVersion)."
            } else {
                "No installed Herdr executable is compatible with the running server."
            }
        case .startupTimedOut:
            "Herdr did not become ready before the startup timeout."
        case let .launchFailed(message):
            "Herdr could not be started: \(message)"
        }
    }
}
