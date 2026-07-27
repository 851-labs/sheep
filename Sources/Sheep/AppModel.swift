import AppKit
import SheepApplication
import SheepDomain

@MainActor
final class AppModel {
    let repository: any HerdrSessionRepository
    private let gitStatus: any GitStatusProvider
    private var observationTask: Task<Void, Never>?
    private var gitTask: Task<Void, Never>?

    private(set) var connection: ConnectionState = .connecting
    private(set) var session: HerdrSession?
    private(set) var gitSummaries: [WorkspaceID: GitSummary] = [:]
    var onChange: (() -> Void)?
    var onLayout: ((Result<PaneLayout, Error>) -> Void)?

    init(
        repository: any HerdrSessionRepository,
        gitStatus: any GitStatusProvider
    ) {
        self.repository = repository
        self.gitStatus = gitStatus
    }

    deinit {
        observationTask?.cancel()
        gitTask?.cancel()
    }

    func start() {
        guard observationTask == nil else { return }
        observationTask = Task { [weak self] in
            guard let self else { return }
            let updates = await repository.observeSession()
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
        Task {
            do {
                onLayout?(.success(try await repository.exportLayout(tabID: tabID)))
            } catch {
                onLayout?(.failure(error))
            }
        }
    }

    func setSplitRatio(tabID: TabID, path: [Bool], ratio: Double) {
        perform {
            try await self.repository.setSplitRatio(tabID: tabID, path: path, ratio: ratio)
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
            gitSummaries = summaries
            onChange?()
        }
    }
}
