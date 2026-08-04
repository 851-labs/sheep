import AppKit
import HerdrSDKLocal

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

        let logs = FileManager.default.homeDirectoryForCurrentUser
            .appending(path: "Library/Application Support/Sheep/Logs/herdr-server.log")
        let configuration = HerdrLocalConfiguration(logURL: logs)
        let localRuntime = HerdrLocalRuntime(configuration: configuration)
        let model = AppModel(repository: localRuntime.client, gitStatus: GitStatusService())
        let runtime = GhosttyRuntime()
        ghosttyRuntime = runtime
        let executable = configuration.executableURL
            ?? (try? HerdrExecutableLocator(
                environment: configuration.environment
            ).locate())
        let attachmentFactory = executable.flatMap {
            try? HerdrTerminalAttachmentFactory(executableURL: $0)
        }
        let content = MainSplitViewController(
            model: model,
            ghosttyRuntime: runtime,
            terminalAttachments: attachmentFactory
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

        installMainMenu(window: window)
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

    func installMainMenu(window: NSWindow? = nil) {
        let menu = NSMenu()

        let appItem = NSMenuItem(title: "sheep", action: nil, keyEquivalent: "")
        let appMenu = NSMenu(title: "sheep")
        let aboutItem = appMenu.addItem(
            withTitle: "About sheep",
            action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
            keyEquivalent: ""
        )
        aboutItem.target = NSApp
        appMenu.addItem(.separator())

        let servicesItem = NSMenuItem(title: "Services", action: nil, keyEquivalent: "")
        let servicesMenu = NSMenu(title: "Services")
        servicesItem.submenu = servicesMenu
        appMenu.addItem(servicesItem)
        NSApp.servicesMenu = servicesMenu

        appMenu.addItem(.separator())
        let hideItem = appMenu.addItem(
            withTitle: "Hide sheep",
            action: #selector(NSApplication.hide(_:)),
            keyEquivalent: "h"
        )
        hideItem.target = NSApp
        let hideOthersItem = appMenu.addItem(
            withTitle: "Hide Others",
            action: #selector(NSApplication.hideOtherApplications(_:)),
            keyEquivalent: "h"
        )
        hideOthersItem.keyEquivalentModifierMask = [.command, .option]
        hideOthersItem.target = NSApp
        let showAllItem = appMenu.addItem(
            withTitle: "Show All",
            action: #selector(NSApplication.unhideAllApplications(_:)),
            keyEquivalent: ""
        )
        showAllItem.target = NSApp
        appMenu.addItem(.separator())
        let quitItem = appMenu.addItem(
            withTitle: "Quit sheep",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
        quitItem.target = NSApp
        appItem.submenu = appMenu
        menu.addItem(appItem)

        let fileItem = NSMenuItem(title: "File", action: nil, keyEquivalent: "")
        let fileMenu = NSMenu(title: "File")
        fileMenu.addItem(withTitle: "New Tab", action: #selector(newTab), keyEquivalent: "t").target = self
        fileMenu.addItem(withTitle: "New Space…", action: #selector(newSpace), keyEquivalent: "n").target = self
        fileMenu.addItem(.separator())
        let closeItem = fileMenu.addItem(
            withTitle: "Close Window",
            action: #selector(NSWindow.performClose(_:)),
            keyEquivalent: "w"
        )
        closeItem.target = window
        fileItem.submenu = fileMenu
        menu.addItem(fileItem)

        let editItem = NSMenuItem(title: "Edit", action: nil, keyEquivalent: "")
        let editMenu = NSMenu(title: "Edit")
        editMenu.addItem(withTitle: "Undo", action: Selector(("undo:")), keyEquivalent: "z")
        let redoItem = editMenu.addItem(
            withTitle: "Redo",
            action: Selector(("redo:")),
            keyEquivalent: "z"
        )
        redoItem.keyEquivalentModifierMask = [.command, .shift]
        editMenu.addItem(.separator())
        editMenu.addItem(
            withTitle: "Cut",
            action: #selector(NSText.cut(_:)),
            keyEquivalent: "x"
        )
        editMenu.addItem(
            withTitle: "Copy",
            action: #selector(NSText.copy(_:)),
            keyEquivalent: "c"
        )
        editMenu.addItem(
            withTitle: "Paste",
            action: #selector(NSText.paste(_:)),
            keyEquivalent: "v"
        )
        editMenu.addItem(
            withTitle: "Select All",
            action: #selector(NSText.selectAll(_:)),
            keyEquivalent: "a"
        )
        editItem.submenu = editMenu
        menu.addItem(editItem)

        let viewItem = NSMenuItem(title: "View", action: nil, keyEquivalent: "")
        let viewMenu = NSMenu(title: "View")
        let sidebarItem = viewMenu.addItem(
            withTitle: "Toggle Sidebar",
            action: #selector(toggleSidebar),
            keyEquivalent: "s"
        )
        sidebarItem.keyEquivalentModifierMask = [.command, .control]
        sidebarItem.target = self
        viewMenu.addItem(.separator())
        let fullScreenItem = viewMenu.addItem(
            withTitle: "Enter Full Screen",
            action: #selector(NSWindow.toggleFullScreen(_:)),
            keyEquivalent: "f"
        )
        fullScreenItem.keyEquivalentModifierMask = [.command, .control]
        fullScreenItem.target = window
        viewItem.submenu = viewMenu
        menu.addItem(viewItem)

        let windowItem = NSMenuItem(title: "Window", action: nil, keyEquivalent: "")
        let windowMenu = NSMenu(title: "Window")
        let minimizeItem = windowMenu.addItem(
            withTitle: "Minimize",
            action: #selector(NSWindow.performMiniaturize(_:)),
            keyEquivalent: "m"
        )
        minimizeItem.target = window
        let zoomItem = windowMenu.addItem(
            withTitle: "Zoom",
            action: #selector(NSWindow.performZoom(_:)),
            keyEquivalent: ""
        )
        zoomItem.target = window
        windowMenu.addItem(.separator())
        let frontItem = windowMenu.addItem(
            withTitle: "Bring All to Front",
            action: #selector(NSApplication.arrangeInFront(_:)),
            keyEquivalent: ""
        )
        frontItem.target = NSApp
        windowItem.submenu = windowMenu
        menu.addItem(windowItem)
        NSApp.windowsMenu = windowMenu

        NSApp.mainMenu = menu
    }
}
