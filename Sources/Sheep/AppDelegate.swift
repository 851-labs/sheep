import AppKit
import SheepInfrastructure

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var windowController: NSWindowController?
    private var mainController: MainSplitViewController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.appearance = NSAppearance(named: .darkAqua)

        let supervisor = HerdrServerSupervisorAdapter()
        let repository = HerdrSessionRepositoryAdapter(supervisor: supervisor)
        let model = AppModel(repository: repository, gitStatus: GitStatusService())
        let content = MainSplitViewController(model: model)
        mainController = content

        let window = NSWindow(contentViewController: content)
        window.title = "sheep"
        window.setContentSize(NSSize(width: 1_120, height: 760))
        window.minSize = NSSize(width: 720, height: 480)
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView]
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.backgroundColor = Palette.window
        window.isMovableByWindowBackground = true
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
        mainController?.toggleSidebar()
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
