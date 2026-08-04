import AppKit
import HerdrSDK
import HerdrSDKLocal

/// Mirrors Ghostty's macOS tab architecture: every tab is a real AppKit window
/// grouped by `NSWindowTabGroup`, while Herdr remains authoritative for tab state.
@MainActor
final class WorkspaceTabCoordinator: NSObject, NSWindowDelegate {
    private let model: AppModel
    private let ghosttyRuntime: GhosttyRuntime?
    private let terminalAttachments: HerdrTerminalAttachmentFactory?
    private var entries: [TabID: WindowEntry] = [:]
    private var placeholderEntry: WindowEntry?
    private var isSynchronizing = false
    private var shouldShowWindows = true

    init(
        model: AppModel,
        ghosttyRuntime: GhosttyRuntime?,
        terminalAttachments: HerdrTerminalAttachmentFactory?
    ) {
        self.model = model
        self.ghosttyRuntime = ghosttyRuntime
        self.terminalAttachments = terminalAttachments
    }

    var selectedMainController: MainSplitViewController? {
        selectedEntry?.mainController ?? placeholderEntry?.mainController
    }

    var selectedWindow: NSWindow? {
        selectedEntry?.window ?? placeholderEntry?.window
    }

    var nativeTabTitles: [String] {
        orderedEntries.map(\.window.title)
    }

    var nativeTabCount: Int { entries.count }

    func start(showWindow: Bool = true) {
        guard placeholderEntry == nil, entries.isEmpty else { return }
        shouldShowWindows = showWindow
        let entry = makeEntry(tabID: nil, matching: nil)
        placeholderEntry = entry

        model.onChange = { [weak self] in
            self?.synchronizeFromModel()
        }
        model.onLayout = { [weak self] result in
            self?.allEntries.forEach { $0.mainController.displayLayout(result) }
        }

        entry.mainController.refresh()
        if showWindow {
            entry.windowController.showWindow(nil)
            entry.window.makeKeyAndOrderFront(nil)
        }
        model.start()
        synchronizeFromModel()
    }

    func shutdown() {
        model.onChange = nil
        model.onLayout = nil
        for entry in allEntries {
            entry.window.delegate = nil
            entry.window.orderOut(nil)
            entry.window.close()
        }
        entries.removeAll()
        placeholderEntry = nil
    }

    func createTab() {
        model.createTab()
    }

    func createWorkspace() {
        model.createWorkspace()
    }

    func toggleSidebar() {
        selectedMainController?.toggleSidebar(nil)
    }

    func windowDidBecomeKey(_ notification: Notification) {
        guard !isSynchronizing,
              let window = notification.object as? WorkspaceTabWindow,
              let tabID = window.herdrTabID else { return }
        updatePresentation(selectedTabID: tabID)
        if model.session?.focusedTabID != tabID {
            model.focusTab(tabID)
        }
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        guard let tabID = (sender as? WorkspaceTabWindow)?.herdrTabID else {
            return true
        }
        model.closeTab(tabID)
        return false
    }

    private func synchronizeFromModel() {
        isSynchronizing = true
        defer { isSynchronizing = false }

        allEntries.forEach { $0.mainController.refresh() }
        guard let session = model.session,
              let workspace = session.focusedWorkspace else {
            showPlaceholderWindow()
            return
        }
        let tabs = session.tabs(in: workspace.id)
        guard !tabs.isEmpty else {
            showPlaceholderWindow()
            return
        }

        let desiredIDs = Set(tabs.map(\.id))
        let focusedID = session.focusedTabID.flatMap { desiredIDs.contains($0) ? $0 : nil }
            ?? tabs.first!.id

        if entries[focusedID] == nil {
            let reusable = placeholderEntry ?? selectedEntry ?? entries.values.first
            if let reusable {
                repurpose(reusable, as: focusedID)
            }
        }
        for tab in tabs where entries[tab.id] == nil {
            let entry = makeEntry(tabID: tab.id, matching: selectedWindow)
            if shouldShowWindows {
                // AppKit does not fully realize a tab's titlebar until its window
                // has been shown once. Ghostty does the same before grouping.
                entry.window.alphaValue = 0
                entry.windowController.showWindow(nil)
            }
            entries[tab.id] = entry
        }

        let obsolete = entries.keys.filter { !desiredIDs.contains($0) }
        for tabID in obsolete {
            removeEntry(for: tabID)
        }

        for tab in tabs {
            guard let entry = entries[tab.id] else { continue }
            configure(entry, for: tab, workspaceID: workspace.id)
            entry.mainController.refresh()
        }

        rebuildNativeOrder(tabs.compactMap { entries[$0.id] })
        entries.values.forEach { $0.window.alphaValue = 1 }
        updatePresentation(selectedTabID: focusedID)
        if let focused = entries[focusedID], focused.window !== NSApp.keyWindow {
            if shouldShowWindows {
                focused.window.makeKeyAndOrderFront(nil)
            } else {
                focused.window.tabGroup?.selectedWindow = focused.window
            }
        }
    }

    private func showPlaceholderWindow() {
        let survivor = placeholderEntry ?? selectedEntry ?? entries.values.first
            ?? makeEntry(tabID: nil, matching: nil)
        for entry in allEntries where entry !== survivor {
            remove(entry)
        }
        entries.removeAll()
        placeholderEntry = survivor
        survivor.tabID = nil
        survivor.window.herdrTabID = nil
        survivor.window.title = "sheep"
        survivor.window.tabbingIdentifier = "com.851labs.sheep"
        survivor.window.tab.accessoryView = nil
        survivor.mainController.setRepresentedTabID(nil)
        survivor.mainController.setWindowPresented(true)
        survivor.mainController.refresh()
        if shouldShowWindows, !survivor.window.isVisible {
            survivor.windowController.showWindow(nil)
        }
    }

    private func repurpose(_ entry: WindowEntry, as tabID: TabID) {
        if let oldID = entry.tabID {
            entries.removeValue(forKey: oldID)
        }
        placeholderEntry = nil
        entry.tabID = tabID
        entry.window.herdrTabID = tabID
        entry.mainController.setRepresentedTabID(tabID)
        entries[tabID] = entry
    }

    private func configure(_ entry: WindowEntry, for tab: Tab, workspaceID: WorkspaceID) {
        entry.window.title = tab.label
        entry.window.tabbingIdentifier = "com.851labs.sheep.workspace.\(workspaceID.rawValue)"
        entry.window.tab.accessoryView = TabAgentStatusView(status: tab.agentStatus)
        entry.window.tab.toolTip = "Herdr tab \(tab.label)"
        entry.window.setAccessibilityLabel("Tab \(tab.label)")
    }

    private func rebuildNativeOrder(_ ordered: [WindowEntry]) {
        guard let first = ordered.first else { return }
        let desiredWindows = ordered.map(\.window)
        if first.window.tabbedWindows == desiredWindows {
            return
        }
        for entry in ordered.dropFirst() {
            entry.window.orderOut(nil)
            entry.window.tabGroup?.removeWindow(entry.window)
        }
        var previous = first.window
        for entry in ordered.dropFirst() {
            previous.addTabbedWindow(entry.window, ordered: .above)
            previous = entry.window
        }
        first.window.tabbingMode = .preferred
        DispatchQueue.main.async { [weak firstWindow = first.window] in
            firstWindow?.tabbingMode = .automatic
        }
    }

    private func updatePresentation(selectedTabID: TabID) {
        for (tabID, entry) in entries {
            entry.mainController.setWindowPresented(tabID == selectedTabID)
        }
    }

    private func makeEntry(tabID: TabID?, matching referenceWindow: NSWindow?) -> WindowEntry {
        let mainController = MainSplitViewController(
            model: model,
            ghosttyRuntime: ghosttyRuntime,
            terminalAttachments: terminalAttachments,
            representedTabID: tabID,
            automaticallyObservesModel: false
        )
        let window = WorkspaceTabWindow(contentViewController: mainController)
        window.herdrTabID = tabID
        window.tabCoordinator = self
        configureWindow(window, matching: referenceWindow)
        window.delegate = self
        let toolbar = MainWindowToolbar(splitView: mainController.splitView)
        window.toolbar = toolbar.toolbar
        let controller = NSWindowController(window: window)
        return WindowEntry(
            tabID: tabID,
            window: window,
            windowController: controller,
            mainController: mainController,
            toolbar: toolbar
        )
    }

    private func configureWindow(_ window: NSWindow, matching referenceWindow: NSWindow?) {
        window.title = "sheep"
        window.setContentSize(NSSize(width: 1_120, height: 760))
        window.minSize = NSSize(width: 720, height: 480)
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView]
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.toolbarStyle = .unified
        window.isOpaque = false
        window.backgroundColor = .clear
        window.isMovableByWindowBackground = true
        window.tabbingMode = .preferred
        window.isReleasedWhenClosed = false
        if let referenceWindow {
            window.setFrame(referenceWindow.frame, display: false)
        } else {
            window.center()
        }
    }

    private func removeEntry(for tabID: TabID) {
        guard let entry = entries.removeValue(forKey: tabID) else { return }
        remove(entry)
    }

    private func remove(_ entry: WindowEntry) {
        entry.window.orderOut(nil)
        entry.window.tabGroup?.removeWindow(entry.window)
        entry.window.delegate = nil
        entry.window.close()
    }

    private var selectedEntry: WindowEntry? {
        entries.values.first(where: { $0.window.isKeyWindow })
            ?? entries.values.first(where: { $0.window.tabGroup?.selectedWindow === $0.window })
            ?? model.session?.focusedTabID.flatMap { entries[$0] }
    }

    private var orderedEntries: [WindowEntry] {
        guard let first = entries.values.first,
              let tabbed = first.window.tabbedWindows else {
            return Array(entries.values)
        }
        let byWindow = Dictionary(uniqueKeysWithValues: entries.values.map {
            (ObjectIdentifier($0.window), $0)
        })
        return tabbed.compactMap { byWindow[ObjectIdentifier($0)] }
    }

    private var allEntries: [WindowEntry] {
        var result = Array(entries.values)
        if let placeholderEntry, !result.contains(where: { $0 === placeholderEntry }) {
            result.append(placeholderEntry)
        }
        return result
    }
}

@MainActor
final class WorkspaceTabWindow: NSWindow {
    weak var tabCoordinator: WorkspaceTabCoordinator?
    var herdrTabID: TabID?

    override func newWindowForTab(_ sender: Any?) {
        tabCoordinator?.createTab()
    }
}

@MainActor
private final class WindowEntry {
    var tabID: TabID?
    let window: WorkspaceTabWindow
    let windowController: NSWindowController
    let mainController: MainSplitViewController
    let toolbar: MainWindowToolbar

    init(
        tabID: TabID?,
        window: WorkspaceTabWindow,
        windowController: NSWindowController,
        mainController: MainSplitViewController,
        toolbar: MainWindowToolbar
    ) {
        self.tabID = tabID
        self.window = window
        self.windowController = windowController
        self.mainController = mainController
        self.toolbar = toolbar
    }
}

@MainActor
private final class TabAgentStatusView: NSImageView {
    init(status: AgentStatus) {
        let symbol = status == .done ? "checkmark" : "circle.fill"
        let image = NSImage(systemSymbolName: symbol, accessibilityDescription: status.rawValue)?
            .withSymbolConfiguration(.init(pointSize: 6, weight: .bold))
        super.init(frame: NSRect(x: 0, y: 0, width: 12, height: 12))
        self.image = image
        imageScaling = .scaleProportionallyDown
        contentTintColor = switch status {
        case .working: Palette.working
        case .blocked: Palette.blocked
        case .done: .systemGreen
        case .idle: Palette.idle
        case .unknown: .tertiaryLabelColor
        }
        frame.size = NSSize(width: 12, height: 12)
        setAccessibilityLabel("\(status.rawValue) agent status")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
