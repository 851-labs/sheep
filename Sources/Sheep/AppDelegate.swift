import AppKit
import SheepInfrastructure

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var windowController: NSWindowController?
    private var mainController: MainSplitViewController?
    private var mainToolbar: MainWindowToolbar?
    private var ghosttyRuntime: GhosttyRuntime?

    func applicationDidFinishLaunching(_ notification: Notification) {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            return
        }

        let supervisor = HerdrServerSupervisorAdapter()
        let repository = HerdrSessionRepositoryAdapter(supervisor: supervisor)
        let model = AppModel(repository: repository, gitStatus: GitStatusService())
        let runtime = GhosttyRuntime()
        ghosttyRuntime = runtime
        let content = MainSplitViewController(
            model: model,
            ghosttyRuntime: runtime,
            herdrExecutable: try? HerdrExecutableLocator().locate()
        )
        mainController = content

        let window = NSWindow(contentViewController: content)
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
        let toolbar = MainWindowToolbar(splitView: content.splitView)
        mainToolbar = toolbar
        window.toolbar = toolbar.toolbar
        window.center()

        installMainMenu()
        let controller = NSWindowController(window: window)
        windowController = controller
        controller.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    @objc private func newTab() {
        mainController?.createTab()
    }

    @objc private func newSpace() {
        mainController?.createWorkspace()
    }

    @objc private func toggleSidebar() {
        mainController?.toggleSidebar(nil)
    }

    private func installMainMenu() {
        let menu = NSMenu()

        let appItem = NSMenuItem()
        let appMenu = NSMenu()
        appMenu.addItem(withTitle: "About sheep", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
        appMenu.addItem(.separator())
        appMenu.addItem(withTitle: "Quit sheep", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        appItem.submenu = appMenu
        menu.addItem(appItem)

        let fileItem = NSMenuItem()
        let fileMenu = NSMenu(title: "File")
        fileMenu.addItem(withTitle: "New Tab", action: #selector(newTab), keyEquivalent: "t").target = self
        fileMenu.addItem(withTitle: "New Space…", action: #selector(newSpace), keyEquivalent: "n").target = self
        fileItem.submenu = fileMenu
        menu.addItem(fileItem)

        let viewItem = NSMenuItem()
        let viewMenu = NSMenu(title: "View")
        let sidebarItem = viewMenu.addItem(
            withTitle: "Toggle Sidebar",
            action: #selector(toggleSidebar),
            keyEquivalent: "s"
        )
        sidebarItem.keyEquivalentModifierMask = [.command, .control]
        sidebarItem.target = self
        viewItem.submenu = viewMenu
        menu.addItem(viewItem)

        NSApp.mainMenu = menu
    }
}
