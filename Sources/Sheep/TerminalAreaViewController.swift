import AppKit
import SheepApplication
import SheepDomain

@MainActor
final class TerminalAreaViewController: NSViewController, NSSplitViewDelegate {
    private let model: AppModel
    private let tabStack = NSStackView()
    private let banner = NSTextField(labelWithString: "")
    private let content = NSView()
    private var splitMetadata: [ObjectIdentifier: SplitMetadata] = [:]
    private var ratioTasks: [String: Task<Void, Never>] = [:]
    private var activeTabID: TabID?

    init(model: AppModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func loadView() {
        let root = NSView()
        root.wantsLayer = true
        root.layer?.backgroundColor = Palette.terminal.cgColor

        tabStack.orientation = .horizontal
        tabStack.alignment = .centerY
        tabStack.spacing = 4
        tabStack.edgeInsets = NSEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)
        tabStack.wantsLayer = true
        tabStack.layer?.backgroundColor = Palette.window.cgColor

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
            showEmptyState()
            return
        }
        if activeTabID != tab.id {
            activeTabID = tab.id
            showLoading()
            model.loadLayout(tabID: tab.id)
        }
    }

    func displayLayout(_ result: Result<PaneLayout, Error>) {
        guard let tabID = activeTabID else { return }
        switch result {
        case let .success(layout) where layout.tabID == tabID:
            splitMetadata.removeAll()
            let node = layout.zoomed
                ? PaneLayout.Node.pane(layout.focusedPaneID)
                : layout.root
            replaceContent(with: build(node: node, tabID: tabID, path: []))
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
            button.font = .monospacedSystemFont(ofSize: 11, weight: tab.focused ? .semibold : .regular)
            button.contentTintColor = tab.focused ? .labelColor : .secondaryLabelColor
            button.wantsLayer = true
            button.layer?.cornerRadius = 7
            button.layer?.backgroundColor = tab.focused
                ? NSColor.white.withAlphaComponent(0.1).cgColor
                : NSColor.clear.cgColor
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
            showBanner("Connecting to Herdr…", color: Palette.yellow)
        case let .disconnected(message):
            showBanner("Disconnected — \(message). Retrying…", color: Palette.yellow)
        case let .unavailable(message):
            showBanner(message, color: Palette.pink)
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
            guard let pane = model.session?.panes.first(where: { $0.id == id }) else {
                return stateLabel(title: "Pane unavailable", detail: id.rawValue)
            }
            return TerminalPlaceholderView(pane: pane) { [weak self] in
                self?.model.focusPane(id)
            }
        case let .split(direction, ratio, first, second):
            let split = NSSplitView()
            split.isVertical = direction == .right
            split.dividerStyle = .thin
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

    func splitViewDidResizeSubviews(_ notification: Notification) {
        guard let split = notification.object as? NSSplitView,
              let metadata = splitMetadata[ObjectIdentifier(split)],
              split.subviews.count == 2 else { return }
        let total = split.isVertical ? split.bounds.width : split.bounds.height
        let first = split.isVertical ? split.subviews[0].frame.width : split.subviews[0].frame.height
        guard total > 0, first > 0 else { return }
        let ratio = min(max(first / total, 0.1), 0.9)
        let key = metadata.path.map { $0 ? "1" : "0" }.joined()
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

private struct SplitMetadata {
    let tabID: TabID
    let path: [Bool]
}

@MainActor
private final class ClosureButton: NSButton {
    private let closure: () -> Void

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

    @objc private func invoke() { closure() }
}

@MainActor
private final class TerminalPlaceholderView: NSView {
    private let focus: () -> Void

    init(pane: Pane, focus: @escaping () -> Void) {
        self.focus = focus
        super.init(frame: .zero)
        wantsLayer = true
        layer?.backgroundColor = Palette.terminal.cgColor
        layer?.borderColor = Palette.line.cgColor
        layer?.borderWidth = 0.5

        let icon = NSImageView(image: NSImage(
            systemSymbolName: "terminal",
            accessibilityDescription: "Terminal"
        )!)
        icon.contentTintColor = .tertiaryLabelColor
        let title = NSTextField(labelWithString: pane.displayTitle)
        title.font = .monospacedSystemFont(ofSize: 13, weight: .medium)
        title.textColor = .secondaryLabelColor
        let detail = NSTextField(labelWithString: pane.foregroundCWD ?? pane.cwd ?? pane.terminalID.rawValue)
        detail.font = .monospacedSystemFont(ofSize: 10, weight: .regular)
        detail.textColor = .tertiaryLabelColor
        detail.lineBreakMode = .byTruncatingMiddle
        let stack = NSStackView(views: [icon, title, detail])
        stack.orientation = .vertical
        stack.alignment = .centerX
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -30),
        ])
        setAccessibilityLabel("Terminal \(pane.displayTitle)")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override var acceptsFirstResponder: Bool { true }

    override func mouseDown(with event: NSEvent) {
        window?.makeFirstResponder(self)
        focus()
    }

    override func becomeFirstResponder() -> Bool {
        focus()
        return true
    }
}
