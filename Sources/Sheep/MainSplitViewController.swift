import AppKit

@MainActor
final class MainSplitViewController: NSSplitViewController {
    private let model: AppModel
    private let sidebar: SidebarViewController
    private let terminalArea: TerminalAreaViewController
    private var restoredWidth = false

    init(model: AppModel) {
        self.model = model
        sidebar = SidebarViewController(model: model)
        terminalArea = TerminalAreaViewController(model: model)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        splitView.isVertical = true
        splitView.dividerStyle = .thin

        let sidebarItem = NSSplitViewItem(sidebarWithViewController: sidebar)
        sidebarItem.minimumThickness = 200
        sidebarItem.maximumThickness = 360
        sidebarItem.canCollapse = true
        addSplitViewItem(sidebarItem)
        addSplitViewItem(NSSplitViewItem(viewController: terminalArea))

        model.onChange = { [weak self] in
            self?.sidebar.reload()
            self?.terminalArea.reload()
        }
        model.onLayout = { [weak self] result in
            self?.terminalArea.displayLayout(result)
        }
        model.start()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        guard !restoredWidth else { return }
        restoredWidth = true
        let width = UserDefaults.standard.object(forKey: "sidebarWidth") as? Double ?? 240
        splitView.setPosition(min(max(width, 200), 360), ofDividerAt: 0)
    }

    override func splitViewDidResizeSubviews(_ notification: Notification) {
        super.splitViewDidResizeSubviews(notification)
        guard restoredWidth, let sidebarView = splitView.subviews.first else { return }
        let width = sidebarView.frame.width
        if width >= 200, width <= 360 {
            UserDefaults.standard.set(width, forKey: "sidebarWidth")
        }
    }

    func createTab() {
        model.createTab()
    }

    func createWorkspace() {
        model.createWorkspace()
    }

    func toggleSidebar() {
        guard let item = splitViewItems.first else { return }
        item.animator().isCollapsed = !item.isCollapsed
    }
}
