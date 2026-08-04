import Foundation

public struct HerdrExecutableLocator: Sendable {
    private let environment: [String: String]
    private let standardPaths: [String]
    private let statusProbe: @Sendable (URL, URL, [String: String]) -> HerdrExecutableServerStatus?

    public init(environment: [String: String] = ProcessInfo.processInfo.environment) {
        self.environment = environment
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        standardPaths = [
            "/opt/homebrew/bin/herdr",
            "/usr/local/bin/herdr",
            "/opt/local/bin/herdr",
            "\(home)/.local/bin/herdr",
        ]
        statusProbe = Self.readStatus
    }

    init(
        environment: [String: String],
        standardPaths: [String],
        statusProbe: @escaping @Sendable (
            URL,
            URL,
            [String: String]
        ) -> HerdrExecutableServerStatus? = Self.readStatus
    ) {
        self.environment = environment
        self.standardPaths = standardPaths
        self.statusProbe = statusProbe
    }

    public func locate() throws -> URL {
        guard let executable = executableCandidates.first else {
            throw HerdrLocalError.executableNotFound
        }
        return executable
    }

    /// Locates a Herdr binary that can speak to the server currently listening
    /// at `socketURL`. If no server is running yet, ordinary discovery order is
    /// preserved so the selected binary can be used to start it.
    public func locate(compatibleWith socketURL: URL) throws -> URL {
        // Explicit overrides are authoritative. Compatibility discovery is for
        // choosing between automatically discovered installations.
        if let override = environment["HERDR_BIN_PATH"],
           FileManager.default.isExecutableFile(atPath: override) {
            return URL(fileURLWithPath: override)
        }
        let candidates = executableCandidates
        guard !candidates.isEmpty else {
            throw HerdrLocalError.executableNotFound
        }

        var runningServerProtocol: UInt?
        for candidate in candidates {
            guard let status = statusProbe(candidate, socketURL, environment),
                  status.running else {
                continue
            }
            runningServerProtocol = status.protocolVersion
            if status.compatible == true {
                return candidate
            }
        }

        guard runningServerProtocol == nil else {
            throw HerdrLocalError.noCompatibleExecutable(
                serverProtocol: runningServerProtocol
            )
        }
        return candidates[0]
    }

    private var executableCandidates: [URL] {
        let fileManager = FileManager.default
        if let override = environment["HERDR_BIN_PATH"],
           fileManager.isExecutableFile(atPath: override) {
            return [URL(fileURLWithPath: override)]
        }
        var paths = standardPaths
        paths.append(contentsOf: (environment["PATH"] ?? "")
            .split(separator: ":")
            .map { "\($0)/herdr" })

        var seen = Set<String>()
        return paths.compactMap { path in
            guard seen.insert(path).inserted,
                  fileManager.isExecutableFile(atPath: path) else {
                return nil
            }
            return URL(fileURLWithPath: path)
        }
    }

    private static func readStatus(
        of executableURL: URL,
        socketURL: URL,
        environment: [String: String]
    ) -> HerdrExecutableServerStatus? {
        let outputURL = FileManager.default.temporaryDirectory
            .appending(path: "herdr-status-\(UUID().uuidString).json")
        guard FileManager.default.createFile(atPath: outputURL.path, contents: nil),
              let output = try? FileHandle(forUpdating: outputURL) else {
            return nil
        }
        defer {
            try? output.close()
            try? FileManager.default.removeItem(at: outputURL)
        }

        let process = Process()
        process.executableURL = executableURL
        process.arguments = ["status", "--json"]
        var processEnvironment = environment
        processEnvironment["HERDR_SOCKET_PATH"] = socketURL.path
        process.environment = processEnvironment

        process.standardOutput = output
        process.standardError = FileHandle.nullDevice
        do {
            try process.run()
        } catch {
            return nil
        }
        process.waitUntilExit()
        guard process.terminationStatus == 0 else { return nil }
        try? output.seek(toOffset: 0)
        guard let data = try? output.readToEnd() else { return nil }
        guard let status = try? JSONDecoder().decode(ExecutableStatus.self, from: data) else {
            return nil
        }
        return HerdrExecutableServerStatus(
            running: status.server.running,
            protocolVersion: status.server.protocolVersion,
            compatible: status.server.compatible
        )
    }
}

struct HerdrExecutableServerStatus: Sendable {
    let running: Bool
    let protocolVersion: UInt?
    let compatible: Bool?
}

private struct ExecutableStatus: Decodable {
    struct Server: Decodable {
        let running: Bool
        let protocolVersion: UInt?
        let compatible: Bool?

        private enum CodingKeys: String, CodingKey {
            case running
            case protocolVersion = "protocol"
            case compatible
        }
    }

    let server: Server
}
