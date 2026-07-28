import Foundation

public struct HerdrExecutableLocator: Sendable {
    private let environment: [String: String]

    public init(environment: [String: String] = ProcessInfo.processInfo.environment) {
        self.environment = environment
    }

    public func locate() throws -> URL {
        let fileManager = FileManager.default
        if let override = environment["HERDR_BIN_PATH"],
           fileManager.isExecutableFile(atPath: override) {
            return URL(fileURLWithPath: override)
        }

        let home = fileManager.homeDirectoryForCurrentUser.path
        let candidates = [
            "/opt/homebrew/bin/herdr",
            "/usr/local/bin/herdr",
            "/opt/local/bin/herdr",
            "\(home)/.local/bin/herdr",
        ] + (environment["PATH"] ?? "")
            .split(separator: ":")
            .map { "\($0)/herdr" }

        guard let path = candidates.first(where: fileManager.isExecutableFile(atPath:)) else {
            throw HerdrLocalError.executableNotFound
        }
        return URL(fileURLWithPath: path)
    }
}
