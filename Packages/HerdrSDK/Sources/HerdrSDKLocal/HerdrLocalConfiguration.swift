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
}

public enum HerdrLocalError: LocalizedError, Equatable, Sendable {
    case executableNotFound
    case startupTimedOut
    case launchFailed(String)

    public var errorDescription: String? {
        switch self {
        case .executableNotFound:
            "Herdr is not installed. Install Herdr and try again."
        case .startupTimedOut:
            "Herdr did not become ready before the startup timeout."
        case let .launchFailed(message):
            "Herdr could not be started: \(message)"
        }
    }
}
