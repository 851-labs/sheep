import AppKit
import HerdrSDK

@MainActor
final class AppModel {
    let repository: any HerdrSessionClient
    private let gitStatus: any GitStatusProvider
    private var observationTask: Task<Void, Never>?
    private var gitTask: Task<Void, Never>?
    private var gitTimerTask: Task<Void, Never>?
    private var layoutTask: Task<Void, Never>?
    private var layoutGeneration = 0

    private(set) var connection: HerdrConnectionState = .connecting
    private(set) var session: HerdrSession?
    private(set) var gitSummaries: [WorkspaceID: GitSummary] = [:]
    var onChange: (() -> Void)?
    var onLayout: ((Result<PaneLayout, Error>) -> Void)?

    init(
        repository: any HerdrSessionClient,
        gitStatus: any GitStatusProvider
    ) {
        self.repository = repository
        self.gitStatus = gitStatus
    }

    deinit {
        observationTask?.cancel()
        gitTask?.cancel()
        gitTimerTask?.cancel()
        layoutTask?.cancel()
    }

    func start() {
        guard observationTask == nil else { return }
        observationTask = Task { [weak self] in
            guard let self else { return }
            let updates = await repository.sessionUpdates()
            for await update in updates {
                guard !Task.isCancelled else { return }
                connection = update.connection
                session = update.session
                onChange?()
                if let tabID = update.session?.focusedTab?.id {
                    loadLayout(tabID: tabID)
                }
                refreshGit()
            }
        }
        gitTimerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(15))
                guard !Task.isCancelled else { return }
                self?.refreshGit()
            }
        }
    }

    func focusWorkspace(_ id: WorkspaceID) {
        perform { try await self.repository.focusWorkspace(id) }
    }

    func focusTab(_ id: TabID) {
        perform { try await self.repository.focusTab(id) }
    }

    func focusPane(_ id: PaneID) {
        perform { try await self.repository.focusPane(id) }
    }

    func createTab() {
        guard let id = session?.focusedWorkspace?.id else { return }
        perform { try await self.repository.createTab(workspaceID: id) }
    }

    func closeTab(_ id: TabID) {
        perform { try await self.repository.closeTab(id) }
    }

    func createWorkspace() {
        let panel = NSOpenPanel()
        panel.title = "Create a Herdr space"
        panel.prompt = "Create Space"
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        guard panel.runModal() == .OK, let url = panel.url else { return }
        perform { try await self.repository.createWorkspace(cwd: url) }
    }

    func loadLayout(tabID: TabID) {
        layoutGeneration += 1
        let generation = layoutGeneration
        layoutTask?.cancel()
        layoutTask = Task {
            do {
                let layout = try await repository.exportLayout(tabID: tabID)
                guard !Task.isCancelled, generation == layoutGeneration else { return }
                onLayout?(.success(layout))
            } catch {
                guard !Task.isCancelled, generation == layoutGeneration else { return }
                onLayout?(.failure(error))
            }
        }
    }

    func setSplitRatio(
        tabID: TabID,
        path: [Bool],
        ratio: Double
    ) async -> Result<PaneLayout, Error>? {
        guard case .connected = connection else { return nil }
        do {
            let layout = try await repository.setSplitRatio(
                tabID: tabID,
                path: path,
                ratio: ratio
            )
            // The mutation response is newer than any export already in flight.
            layoutGeneration += 1
            layoutTask?.cancel()
            return .success(layout)
        } catch is CancellationError {
            return nil
        } catch {
            connection = .disconnected(error.localizedDescription)
            onChange?()
            return .failure(error)
        }
    }

    private func perform(_ operation: @escaping @MainActor () async throws -> Void) {
        guard case .connected = connection else { return }
        Task {
            do {
                try await operation()
            } catch {
                connection = .disconnected(error.localizedDescription)
                onChange?()
            }
        }
    }

    private func refreshGit() {
        gitTask?.cancel()
        guard let session else { return }
        let provider = gitStatus
        gitTask = Task { [weak self] in
            var summaries: [WorkspaceID: GitSummary] = [:]
            for workspace in session.workspaces {
                guard !Task.isCancelled else { return }
                guard let directory = WorkspaceProjection.repositoryDirectory(
                    for: workspace,
                    in: session
                ) else { continue }
                summaries[workspace.id] = await provider.summary(for: directory)
            }
            guard let self, !Task.isCancelled else { return }
            if gitSummaries != summaries {
                gitSummaries = summaries
                onChange?()
            }
        }
    }
}
