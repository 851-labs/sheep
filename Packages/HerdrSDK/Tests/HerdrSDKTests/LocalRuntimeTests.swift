import Foundation
@testable import HerdrSDK
@testable import HerdrSDKLocal
import Testing

@Suite(.serialized)
struct LocalRuntimeTests {
    @Test
    func executableDiscoveryHonorsOverrideAndPath() throws {
        let directory = try temporaryDirectory()
        defer { try? FileManager.default.removeItem(at: directory) }
        let override = try executable(at: directory.appending(path: "override"))
        let pathExecutable = try executable(at: directory.appending(path: "herdr"))

        #expect(
            try HerdrExecutableLocator(
                environment: [
                    "HERDR_BIN_PATH": override.path,
                    "PATH": directory.path,
                ],
                standardPaths: []
            ).locate() == override
        )
        #expect(
            try HerdrExecutableLocator(
                environment: [
                    "HERDR_BIN_PATH": directory.appending(path: "missing").path,
                    "PATH": directory.path,
                ],
                standardPaths: []
            ).locate() == pathExecutable
        )
    }

    @Test
    func executableDiscoveryReportsMissingBinary() {
        do {
            #expect(
                try HerdrExecutableLocator(
                environment: [:],
                standardPaths: ["/bin/echo"]
                ).locate() == URL(fileURLWithPath: "/bin/echo")
            )
        } catch {
            Issue.record(error)
        }
        #expect(throws: HerdrLocalError.executableNotFound) {
            try HerdrExecutableLocator(
                environment: ["PATH": "/no/such/path"],
                standardPaths: []
            ).locate()
        }
    }

    @Test
    func localErrorsHaveActionableDescriptions() {
        #expect(HerdrLocalError.executableNotFound.errorDescription?.contains("not installed") == true)
        #expect(HerdrLocalError.startupTimedOut.errorDescription?.contains("timeout") == true)
        #expect(
            HerdrLocalError.launchFailed("boom").errorDescription
                == "Herdr could not be started: boom"
        )
    }

    @Test
    func terminalAttachmentsSupportTakeoverAndOrdinaryAttach() async throws {
        let factory = try HerdrTerminalAttachmentFactory(
            executableURL: URL(fileURLWithPath: "/bin/echo")
        )
        #expect(
            factory.attachment(terminalID: TerminalID(rawValue: "term"), takeover: false)
                == HerdrTerminalAttachment(
                    executableURL: URL(fileURLWithPath: "/bin/echo"),
                    arguments: ["terminal", "attach", "term"]
                )
        )
        #expect(throws: HerdrLocalError.executableNotFound) {
            try HerdrTerminalAttachmentFactory(
                executableURL: URL(fileURLWithPath: "/missing/herdr")
            )
        }

        let server = HerdrLocalServer(
            configuration: .init(executableURL: URL(fileURLWithPath: "/bin/echo"))
        )
        #expect(
            try await server.terminalAttachment(
                terminalID: TerminalID(rawValue: "term"),
                takeover: false
            ).arguments == ["terminal", "attach", "term"]
        )
    }

    @Test
    func explicitExecutableMustBeExecutable() async {
        let server = HerdrLocalServer(
            configuration: .init(
                executableURL: URL(fileURLWithPath: "/missing/herdr")
            )
        )
        do {
            _ = try await server.executableURL()
            Issue.record("Expected missing executable failure")
        } catch let error as HerdrLocalError {
            #expect(error == .executableNotFound)
        } catch {
            Issue.record(error)
        }
    }

    @Test
    func executableCanBeResolvedByLocatorAndSocketDefaults() async throws {
        let server = HerdrLocalServer(
            configuration: .init(
                environment: ["HERDR_BIN_PATH": "/bin/echo"]
            )
        )
        #expect(try await server.executableURL() == URL(fileURLWithPath: "/bin/echo"))
        #expect(
            await server.resolvedSocketURL
                == FileManager.default.homeDirectoryForCurrentUser
                    .appending(path: ".config/herdr/herdr.sock")
        )
    }

    @Test
    func existingServerIsReusedForExplicitAndEnvironmentSockets() async throws {
        let fake = try FakeHerdrServer { descriptor, request in
            FakeHerdrServer.sendJSON([
                "id": request["id"] ?? "",
                "result": ["version": "0.7.5", "protocol": 17],
            ], to: descriptor)
        }
        defer { fake.stop() }

        let explicit = HerdrLocalServer(
            configuration: .init(
                executableURL: URL(fileURLWithPath: "/missing/herdr"),
                socketURL: fake.socketURL
            )
        )
        #expect(try await explicit.ensureRunning() == fake.socketURL)
        #expect(try await explicit.socketURL() == fake.socketURL)

        let environment = HerdrLocalServer(
            configuration: .init(
                executableURL: URL(fileURLWithPath: "/missing/herdr"),
                environment: ["HERDR_SOCKET_PATH": fake.socketURL.path]
            )
        )
        #expect(try await environment.ensureRunning() == fake.socketURL)
    }

    @Test
    func startupTimeoutLaunchesServerAndRoutesLogs() async throws {
        let directory = try temporaryDirectory()
        defer { try? FileManager.default.removeItem(at: directory) }
        let script = try executable(
            at: directory.appending(path: "herdr"),
            contents: "#!/bin/sh\necho launched\n"
        )
        let log = directory.appending(path: "logs/herdr.log")
        let server = HerdrLocalServer(
            configuration: .init(
                executableURL: script,
                socketURL: directory.appending(path: "missing.sock"),
                logURL: log,
                startupTimeout: .milliseconds(1)
            )
        )

        do {
            _ = try await server.ensureRunning()
            Issue.record("Expected startup timeout")
        } catch let error as HerdrLocalError {
            #expect(error == .startupTimedOut)
        }
        #expect(
            await eventuallyLocal {
                guard let data = try? Data(contentsOf: log) else { return false }
                return String(decoding: data, as: UTF8.self).contains("launched")
            }
        )
    }

    @Test
    func serverBecomingReadyAfterLaunchReturnsItsSocket() async throws {
        let directory = try temporaryDirectory()
        defer { try? FileManager.default.removeItem(at: directory) }
        let script = try executable(at: directory.appending(path: "herdr"))
        let socket = directory.appending(path: "herdr.sock")
        let probes = LockedCounter()
        let server = HerdrLocalServer(
            configuration: .init(
                executableURL: script,
                socketURL: socket,
                logURL: directory.appending(path: "herdr.log"),
                startupTimeout: .seconds(1)
            ),
            readinessProbe: { _ in probes.increment() > 1 }
        )
        #expect(try await server.ensureRunning() == socket)
    }

    @Test
    func launchFailuresAreTyped() async throws {
        let directory = try temporaryDirectory()
        defer { try? FileManager.default.removeItem(at: directory) }
        let invalid = directory.appending(path: "herdr")
        try Data("not an executable format".utf8).write(to: invalid)
        try FileManager.default.setAttributes(
            [.posixPermissions: 0o755],
            ofItemAtPath: invalid.path
        )
        let server = HerdrLocalServer(
            configuration: .init(
                executableURL: invalid,
                socketURL: directory.appending(path: "missing.sock"),
                startupTimeout: .milliseconds(1)
            )
        )
        do {
            _ = try await server.ensureRunning()
            Issue.record("Expected launch failure")
        } catch let error as HerdrLocalError {
            guard case .launchFailed = error else {
                Issue.record("Expected launchFailed, got \(error)")
                return
            }
        }
    }

    @Test
    func runtimeAndLocalClientComposeAgainstEndpointProvider() async {
        let configuration = HerdrLocalConfiguration(
            executableURL: URL(fileURLWithPath: "/bin/echo"),
            socketURL: URL(fileURLWithPath: "/tmp/herdr.sock"),
            logURL: URL(fileURLWithPath: "/tmp/herdr.log"),
            environment: [:],
            startupTimeout: .seconds(2)
        )
        let runtime = HerdrLocalRuntime(configuration: configuration)
        #expect(await runtime.server.configuration.socketURL == configuration.socketURL)
        _ = runtime.client
        _ = HerdrClient.local(configuration: configuration)
    }
}

private func temporaryDirectory() throws -> URL {
    let url = FileManager.default.temporaryDirectory
        .appending(path: "herdr-sdk-tests-\(UUID().uuidString)")
    try FileManager.default.createDirectory(
        at: url,
        withIntermediateDirectories: true
    )
    return url
}

@discardableResult
private func executable(
    at url: URL,
    contents: String = "#!/bin/sh\nexit 0\n"
) throws -> URL {
    try Data(contents.utf8).write(to: url)
    try FileManager.default.setAttributes(
        [.posixPermissions: 0o755],
        ofItemAtPath: url.path
    )
    return url
}

private func eventuallyLocal(
    timeout: Duration = .seconds(1),
    condition: @escaping @Sendable () -> Bool
) async -> Bool {
    let clock = ContinuousClock()
    let deadline = clock.now.advanced(by: timeout)
    while clock.now < deadline {
        if condition() { return true }
        try? await Task.sleep(for: .milliseconds(5))
    }
    return condition()
}

private final class LockedCounter: @unchecked Sendable {
    private let lock = NSLock()
    private var value = 0

    func increment() -> Int {
        lock.withLock {
            value += 1
            return value
        }
    }
}
