import Foundation

public struct HerdrExecutableLocator: Sendable {
    private let environment: [String: String]
    private let standardPaths: [String]

    public init(environment: [String: String] = ProcessInfo.processInfo.environment) {
        self.environment = environment
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        standardPaths = [
            "/opt/homebrew/bin/herdr",
            "/usr/local/bin/herdr",
            "/opt/local/bin/herdr",
            "\(home)/.local/bin/herdr",
        ]
    }

    init(environment: [String: String], standardPaths: [String]) {
        self.environment = environment
        self.standardPaths = standardPaths
    }

    public func locate() throws -> URL {
        let fileManager = FileManager.default
        if let override = environment["HERDR_BIN_PATH"],
           fileManager.isExecutableFile(atPath: override) {
            return URL(fileURLWithPath: override)
        }

        let candidates = standardPaths + (environment["PATH"] ?? "")
            .split(separator: ":")
            .map { "\($0)/herdr" }

        guard let path = candidates.first(where: fileManager.isExecutableFile(atPath:)) else {
            throw HerdrLocalError.executableNotFound
        }
        return URL(fileURLWithPath: path)
    }
}
