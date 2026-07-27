import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var windowController: NSWindowController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let content = PlaceholderViewController()
        let window = NSWindow(contentViewController: content)
        window.title = "sheep"
        window.setContentSize(NSSize(width: 1_120, height: 760))
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView]
        window.titlebarAppearsTransparent = true
        window.center()

        let controller = NSWindowController(window: window)
        windowController = controller
        controller.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

@MainActor
private final class PlaceholderViewController: NSViewController {
    override func loadView() {
        let container = NSVisualEffectView()
        container.material = .underWindowBackground
        container.blendingMode = .behindWindow
        container.state = .active

        let label = NSTextField(labelWithString: "sheep")
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textColor = .secondaryLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])

        view = container
    }
}

