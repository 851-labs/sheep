import Foundation
import SheepApplication
import SheepDomain

public actor GitStatusService: GitStatusProvider {
    public init() {}

    public func summary(for directory: URL) async -> GitSummary? {
        let branch = run(["-C", directory.path, "symbolic-ref", "--short", "HEAD"])
            ?? run(["-C", directory.path, "rev-parse", "--short", "HEAD"])
        guard let branch, !branch.isEmpty else { return nil }

        let counts = run([
            "-C", directory.path,
            "rev-list", "--left-right", "--count", "HEAD...@{upstream}",
        ])?
            .split(whereSeparator: \.isWhitespace)
            .compactMap { Int($0) }

        return GitSummary(
            branch: branch,
            ahead: counts?.first ?? 0,
            behind: counts?.dropFirst().first ?? 0
        )
    }

    private func run(_ arguments: [String]) -> String? {
        let process = Process()
        let output = Pipe()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.arguments = arguments
        process.standardOutput = output
        process.standardError = FileHandle.nullDevice

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            return nil
        }
        guard process.terminationStatus == 0 else { return nil }
        let data = output.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

