import AppKit
import HerdrSDK
import HerdrSDKLocal
import SheepApplication

@MainActor
final class TerminalAreaViewController: NSViewController, NSSplitViewDelegate {
    private static let layoutInset: CGFloat = 10
    private let model: AppModel
    private let ghosttyRuntime: GhosttyRuntime?
    private let terminalAttachments: HerdrTerminalAttachmentFactory?
    private let tabStack = NSStackView()
    private let banner = NSTextField(labelWithString: "")
    private let content = NSView()
    private var splitMetadata: [ObjectIdentifier: SplitMetadata] = [:]
    private var ratioTasks: [String: Task<Void, Never>] = [:]
    private var activeTabID: TabID?
    private var renderedLayout: PaneLayout?

    init(
        model: AppModel,
        ghosttyRuntime: GhosttyRuntime?,
        terminalAttachments: HerdrTerminalAttachmentFactory?
    ) {
        self.model = model
        self.ghosttyRuntime = ghosttyRuntime
        self.terminalAttachments = terminalAttachments
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func loadView() {
        let root = NativeContentBackgroundView()

        tabStack.orientation = .horizontal
        tabStack.alignment = .centerY
        tabStack.spacing = 4
        tabStack.edgeInsets = NSEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)

        banner.font = .systemFont(ofSize: 11, weight: .medium)
        banner.alignment = .center
        banner.maximumNumberOfLines = 2
        banner.isHidden = true

        [tabStack, banner, content].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            root.addSubview($0)
        }
        NSLayoutConstraint.activate([
            tabStack.topAnchor.constraint(equalTo: root.topAnchor),
            tabStack.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            tabStack.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            tabStack.heightAnchor.constraint(equalToConstant: 40),
            banner.topAnchor.constraint(equalTo: tabStack.bottomAnchor),
            banner.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            content.topAnchor.constraint(equalTo: banner.bottomAnchor),
            content.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: root.bottomAnchor),
        ])
        view = root
    }

    func reload() {
        reloadConnectionState()
        reloadTabs()
        guard let tab = model.session?.focusedTab else {
            activeTabID = nil
            renderedLayout = nil
            showEmptyState()
            return
        }
        if activeTabID != tab.id {
            activeTabID = tab.id
            renderedLayout = nil
            showLoading()
        }
    }

    func displayLayout(_ result: Result<PaneLayout, Error>) {
        guard let tabID = activeTabID else { return }
        switch result {
        case let .success(layout) where layout.tabID == tabID:
            let node = layout.visibleRoot
            if let renderedLayout {
                let renderedNode = renderedLayout.visibleRoot
                if renderedLayout.tabID == layout.tabID, renderedNode == node {
                    return
                }
            }
            renderedLayout = layout
            splitMetadata.removeAll()
            replaceContent(with: layoutCanvas(
                containing: build(node: node, tabID: tabID, path: [])
            ))
        case let .failure(error):
            replaceContent(with: stateLabel(
                title: "Unable to load terminal layout",
                detail: error.localizedDescription
            ))
        default:
            break
        }
    }

    private func reloadTabs() {
        tabStack.arrangedSubviews.forEach {
            tabStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        guard let session = model.session,
              let workspace = session.focusedWorkspace else { return }

        for tab in session.tabs(in: workspace.id) {
            let status = tab.agentStatus == .working ? "  ●" : ""
            let button = ClosureButton(title: "\(tab.label)\(status)") { [weak self] in
                self?.model.focusTab(tab.id)
            }
            button.isBordered = false
            button.font = .systemFont(ofSize: 11, weight: tab.focused ? .semibold : .regular)
            button.contentTintColor = tab.focused ? .labelColor : .secondaryLabelColor
            button.showsSelectedBackground = tab.focused
            button.setAccessibilityLabel("Tab \(tab.label)")
            tabStack.addArrangedSubview(button)
        }
        let spacer = NSView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        tabStack.addArrangedSubview(spacer)
        let plus = ClosureButton(
            image: NSImage(systemSymbolName: "plus", accessibilityDescription: "New tab")!
        ) { [weak self] in
            self?.model.createTab()
        }
        plus.isBordered = false
        plus.contentTintColor = .secondaryLabelColor
        plus.setAccessibilityLabel("New tab")
        tabStack.addArrangedSubview(plus)
    }

    private func reloadConnectionState() {
        switch model.connection {
        case .connected:
            banner.isHidden = true
            banner.stringValue = ""
            banner.backgroundColor = .clear
        case .connecting:
            showBanner("Connecting to Herdr…", color: Palette.warning)
        case let .disconnected(message):
            showBanner("Disconnected — \(message). Retrying…", color: Palette.warning)
        case let .unavailable(message):
            showBanner(message, color: Palette.error)
        }
    }

    private func showBanner(_ text: String, color: NSColor) {
        banner.stringValue = text
        banner.textColor = color
        banner.isHidden = false
    }

    private func build(node: PaneLayout.Node, tabID: TabID, path: [Bool]) -> NSView {
        switch node {
        case let .pane(id):
            let paneContent: NSView
            guard let pane = model.session?.panes.first(where: { $0.id == id }) else {
                return terminalCard(
                    containing: stateLabel(title: "Pane unavailable", detail: id.rawValue),
                    paneID: id
                )
            }
            guard let ghosttyRuntime, let terminalAttachments else {
                return terminalCard(containing: stateLabel(
                    title: "Terminal unavailable",
                    detail: ghosttyRuntime == nil
                        ? "Ghostty 1.3.1 could not be initialized."
                        : "The Herdr executable could not be found."
                ), paneID: id)
            }
            let attachment = terminalAttachments.attachment(
                terminalID: pane.terminalID
            )
            paneContent = GhosttyTerminalView(
                runtime: ghosttyRuntime,
                attachment: attachment,
                pane: pane
            ) { [weak self] in
                self?.model.focusPane(id)
            } ?? stateLabel(
                title: "Terminal attach failed",
                detail: "Could not attach \(pane.terminalID.rawValue)."
            )
            return terminalCard(containing: paneContent, paneID: id)
        case let .split(direction, ratio, first, second):
            let split = TerminalCardSplitView()
            split.isVertical = direction == .right
            split.delegate = self
            split.addArrangedSubview(build(node: first, tabID: tabID, path: path + [false]))
            split.addArrangedSubview(build(node: second, tabID: tabID, path: path + [true]))
            splitMetadata[ObjectIdentifier(split)] = .init(tabID: tabID, path: path)
            DispatchQueue.main.async {
                let extent = split.isVertical ? split.bounds.width : split.bounds.height
                guard extent > 0 else { return }
                split.setPosition(extent * ratio, ofDividerAt: 0)
            }
            return split
        }
    }

    private func terminalCard(containing terminal: NSView, paneID: PaneID) -> NSView {
        let card = TerminalCardView()
        card.pinSubview(terminal)
        card.setAccessibilityLabel("Terminal card \(paneID.rawValue)")
        return card
    }

    private func layoutCanvas(containing layout: NSView) -> NSView {
        let canvas = NSView()
        layout.translatesAutoresizingMaskIntoConstraints = false
        canvas.addSubview(layout)
        NSLayoutConstraint.activate([
            layout.leadingAnchor.constraint(
                equalTo: canvas.leadingAnchor,
                constant: Self.layoutInset
            ),
            layout.trailingAnchor.constraint(
                equalTo: canvas.trailingAnchor,
                constant: -Self.layoutInset
            ),
            layout.topAnchor.constraint(
                equalTo: canvas.topAnchor,
                constant: Self.layoutInset
            ),
            layout.bottomAnchor.constraint(
                equalTo: canvas.bottomAnchor,
                constant: -Self.layoutInset
            ),
        ])
        return canvas
    }

    func splitViewDidResizeSubviews(_ notification: Notification) {
        guard let split = notification.object as? NSSplitView,
              let metadata = splitMetadata[ObjectIdentifier(split)],
              split.subviews.count == 2 else { return }
        let total = split.isVertical ? split.bounds.width : split.bounds.height
        let first = split.isVertical ? split.subviews[0].frame.width : split.subviews[0].frame.height
        guard total > 0, first > 0 else { return }
        let ratio = min(max(first / total, 0.1), 0.9)
        let key = "\(metadata.tabID.rawValue):"
            + metadata.path.map { $0 ? "1" : "0" }.joined()
        ratioTasks[key]?.cancel()
        ratioTasks[key] = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(250))
            guard !Task.isCancelled else { return }
            self?.model.setSplitRatio(tabID: metadata.tabID, path: metadata.path, ratio: ratio)
        }
    }

    private func showLoading() {
        replaceContent(with: stateLabel(title: "Loading layout…", detail: ""))
    }

    private func showEmptyState() {
        let button = ClosureButton(title: "Choose a directory…") { [weak self] in
            self?.model.createWorkspace()
        }
        button.bezelStyle = .rounded
        let label = stateLabel(
            title: "No Herdr spaces yet",
            detail: "Create a space to start a terminal session."
        )
        let stack = NSStackView(views: [label, button])
        stack.orientation = .vertical
        stack.alignment = .centerX
        stack.spacing = 14
        let container = NSView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        replaceContent(with: container)
    }

    private func stateLabel(title: String, detail: String) -> NSView {
        let titleLabel = NSTextField(labelWithString: title)
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .secondaryLabelColor
        titleLabel.alignment = .center
        let detailLabel = NSTextField(wrappingLabelWithString: detail)
        detailLabel.font = .systemFont(ofSize: 12)
        detailLabel.textColor = .tertiaryLabelColor
        detailLabel.alignment = .center
        let stack = NSStackView(views: [titleLabel, detailLabel])
        stack.orientation = .vertical
        stack.alignment = .centerX
        stack.spacing = 5
        let container = NSView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stack.widthAnchor.constraint(lessThanOrEqualTo: container.widthAnchor, constant: -40),
        ])
        return container
    }

    private func replaceContent(with newView: NSView) {
        content.subviews.forEach { $0.removeFromSuperview() }
        content.pinSubview(newView)
    }
}

@MainActor
final class TerminalCardView: NSView {
    static let cornerRadius: CGFloat = 12

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.cornerRadius = Self.cornerRadius
        layer?.cornerCurve = .continuous
        layer?.borderWidth = 1
        layer?.masksToBounds = true
        updateAdaptiveAppearance()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        updateAdaptiveAppearance()
    }

    private func updateAdaptiveAppearance() {
        effectiveAppearance.performAsCurrentDrawingAppearance {
            layer?.backgroundColor = NSColor.textBackgroundColor.cgColor
            layer?.borderColor = NSColor.separatorColor.cgColor
        }
    }
}

@MainActor
final class TerminalCardSplitView: NSSplitView {
    static let gutter: CGFloat = 10

    override var dividerThickness: CGFloat { Self.gutter }

    override func drawDivider(in rect: NSRect) {
        // The window background showing through this draggable region is the gutter.
    }
}

private struct SplitMetadata {
    let tabID: TabID
    let path: [Bool]
}

@MainActor
private final class ClosureButton: NSButton {
    private let closure: () -> Void
    var showsSelectedBackground = false {
        didSet { needsDisplay = true }
    }

    init(title: String, closure: @escaping () -> Void) {
        self.closure = closure
        super.init(frame: .zero)
        self.title = title
        target = self
        action = #selector(invoke)
    }

    init(image: NSImage, closure: @escaping () -> Void) {
        self.closure = closure
        super.init(frame: .zero)
        self.image = image
        target = self
        action = #selector(invoke)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func draw(_ dirtyRect: NSRect) {
        if showsSelectedBackground {
            Palette.selected.withAlphaComponent(0.18).setFill()
            NSBezierPath(roundedRect: bounds, xRadius: 7, yRadius: 7).fill()
        }
        super.draw(dirtyRect)
    }

    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        needsDisplay = true
    }

    @objc private func invoke() { closure() }
}
