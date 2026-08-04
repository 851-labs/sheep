import AppKit
import HerdrSDK
import HerdrSDKLocal

@MainActor
final class MainSplitViewController: NSSplitViewController {
    private let model: AppModel
    private let sidebar: SidebarViewController
    private let terminalArea: TerminalAreaViewController
    private let automaticallyObservesModel: Bool
    private var restoredWidth = false

    init(
        model: AppModel,
        ghosttyRuntime: GhosttyRuntime?,
        terminalAttachments: HerdrTerminalAttachmentFactory?,
        representedTabID: TabID? = nil,
        automaticallyObservesModel: Bool = true
    ) {
        self.model = model
        self.automaticallyObservesModel = automaticallyObservesModel
        sidebar = SidebarViewController(model: model)
        terminalArea = TerminalAreaViewController(
            model: model,
            ghosttyRuntime: ghosttyRuntime,
            terminalAttachments: terminalAttachments,
            representedTabID: representedTabID
        )
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

        if automaticallyObservesModel {
            model.onChange = { [weak self] in
                self?.refresh()
            }
            model.onLayout = { [weak self] result in
                self?.displayLayout(result)
            }
            model.start()
        }
        refresh()
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

    func refresh() {
        sidebar.reload()
        terminalArea.reload()
    }

    func displayLayout(_ result: Result<PaneLayout, Error>) {
        terminalArea.displayLayout(result)
    }

    func setRepresentedTabID(_ tabID: TabID?) {
        terminalArea.setRepresentedTabID(tabID)
    }

    func setWindowPresented(_ presented: Bool) {
        terminalArea.setWindowPresented(presented)
    }
}
