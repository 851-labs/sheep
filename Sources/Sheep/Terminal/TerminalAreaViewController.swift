import AppKit
import HerdrSDK
import HerdrSDKLocal

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
    private var ratioTasks: [SplitKey: Task<Void, Never>] = [:]
    private var pendingRatios: [SplitKey: PendingSplitRatio] = [:]
    private var nextRatioGeneration = 0
    private var suppressedDividerCallbacks: Set<ObjectIdentifier> = []
    private var activeTabID: TabID?
    private var visibleTabID: TabID?
    private var renderedTabs: [TabID: RenderedTab] = [:]
    private var terminalViewsByTab: [TabID: [PaneID: GhosttyTerminalView]] = [:]
    private var placeholder: NSView?

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
            visibleTabID = nil
            removeAllRenderedTabs()
            showEmptyState()
            return
        }
        pruneRenderedTabs()
        if activeTabID != tab.id {
            activeTabID = tab.id
            if renderedTabs[tab.id] != nil {
                showRenderedTab(tab.id)
            } else if visibleTabID == nil {
                showLoading()
            } else if let visibleTabID, let visible = renderedTabs[visibleTabID] {
                setPresented(false, in: visible.view)
            }
        }
    }

    func displayLayout(_ result: Result<PaneLayout, Error>) {
        guard let tabID = activeTabID else { return }
        switch result {
        case let .success(layout) where layout.tabID == tabID:
            let effectiveLayout = applyingPendingRatios(to: layout)
            let node = effectiveLayout.visibleRoot
            if var rendered = renderedTabs[tabID],
               rendered.layout.visibleRoot.hasSameTopology(as: node) {
                rendered.layout = effectiveLayout
                renderedTabs[tabID] = rendered
                applySplitRatios(from: node, in: rendered.view, tabID: tabID)
                showRenderedTab(tabID)
                return
            }
            removeRenderedTab(tabID, preservingTerminalViews: true)
            let tabView = layoutCanvas(
                containing: build(node: node, tabID: tabID, path: [])
            )
            renderedTabs[tabID] = RenderedTab(layout: effectiveLayout, view: tabView)
            mountRenderedTab(tabView)
            showRenderedTab(tabID)
        case let .failure(error):
            if visibleTabID == nil {
                showPlaceholder(stateLabel(
                    title: "Unable to load terminal layout",
                    detail: error.localizedDescription
                ))
            }
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
                        ? "Ghostty could not be initialized."
                        : "The Herdr executable could not be found."
                ), paneID: id)
            }
            if let existing = terminalViewsByTab[tabID]?[id] {
                paneContent = existing
            } else {
                let attachment = terminalAttachments.attachment(
                    terminalID: pane.terminalID
                )
                let terminal = GhosttyTerminalView(
                    runtime: ghosttyRuntime,
                    attachment: attachment,
                    pane: pane
                ) { [weak self] in
                    self?.model.focusPane(id)
                }
                if let terminal {
                    terminalViewsByTab[tabID, default: [:]][id] = terminal
                    paneContent = terminal
                } else {
                    paneContent = stateLabel(
                        title: "Terminal attach failed",
                        detail: "Could not attach \(pane.terminalID.rawValue)."
                    )
                }
            }
            return terminalCard(containing: paneContent, paneID: id)
        case let .split(direction, ratio, first, second):
            let split = TerminalCardSplitView()
            split.isVertical = direction == .right
            split.delegate = self
            split.addArrangedSubview(build(node: first, tabID: tabID, path: path + [false]))
            split.addArrangedSubview(build(node: second, tabID: tabID, path: path + [true]))
            splitMetadata[ObjectIdentifier(split)] = .init(tabID: tabID, path: path)
            DispatchQueue.main.async { [weak self, weak split] in
                guard let self, let split else { return }
                self.setSplitPosition(ratio, in: split)
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
        let identifier = ObjectIdentifier(split)
        if suppressedDividerCallbacks.remove(identifier) != nil { return }
        guard (split as? TerminalCardSplitView)?.isDraggingDivider == true else { return }
        let total = split.isVertical ? split.bounds.width : split.bounds.height
        let first = split.isVertical ? split.subviews[0].frame.width : split.subviews[0].frame.height
        guard total > 0, first > 0 else { return }
        let ratio = min(max((first + split.dividerThickness / 2) / total, 0.1), 0.9)
        let key = SplitKey(tabID: metadata.tabID, path: metadata.path)
        nextRatioGeneration += 1
        let generation = nextRatioGeneration
        pendingRatios[key] = PendingSplitRatio(generation: generation, ratio: ratio)
        updateRenderedRatio(ratio, for: key)
        ratioTasks[key]?.cancel()
        ratioTasks[key] = Task { [weak self] in
            do {
                try await Task.sleep(for: .milliseconds(250))
            } catch {
                return
            }
            guard let self,
                  !Task.isCancelled,
                  self.pendingRatios[key]?.generation == generation else { return }
            guard let result = await self.model.setSplitRatio(
                tabID: metadata.tabID,
                path: metadata.path,
                ratio: ratio
            ) else {
                self.cancelPendingRatio(for: key, generation: generation)
                return
            }
            guard self.pendingRatios[key]?.generation == generation else { return }
            switch result {
            case let .success(layout):
                if self.isDraggingDivider(for: key) {
                    self.pendingRatios[key]?.acknowledgedLayout = layout
                } else {
                    self.finishPendingRatio(for: key, generation: generation, layout: layout)
                }
            case .failure:
                self.cancelPendingRatio(for: key, generation: generation)
            }
        }
    }

    func splitView(
        _ splitView: NSSplitView,
        constrainSplitPosition proposedPosition: CGFloat,
        ofSubviewAt dividerIndex: Int
    ) -> CGFloat {
        guard let split = splitView as? TerminalCardSplitView,
              let event = NSApp.currentEvent else {
            return proposedPosition
        }
        guard event.type == .leftMouseDown || event.type == .leftMouseDragged else {
            return proposedPosition
        }
        let pointer = split.convert(event.locationInWindow, from: nil)
        let precedingFrame = split.subviews[dividerIndex].frame
        let dividerRect = split.isVertical
            ? NSRect(
                x: precedingFrame.maxX,
                y: split.bounds.minY,
                width: split.dividerThickness,
                height: split.bounds.height
            )
            : NSRect(
                x: split.bounds.minX,
                y: precedingFrame.maxY,
                width: split.bounds.width,
                height: split.dividerThickness
            )
        let hitArea = dividerRect.insetBy(dx: -4, dy: -4)
        guard split.isDraggingDivider || hitArea.contains(pointer) else {
            return proposedPosition
        }
        split.isDraggingDivider = true
        DispatchQueue.main.async { [weak self, weak split] in
            guard let self, let split else { return }
            split.isDraggingDivider = false
            guard let metadata = self.splitMetadata[ObjectIdentifier(split)] else { return }
            self.dividerDragEnded(for: SplitKey(tabID: metadata.tabID, path: metadata.path))
        }
        return proposedPosition
    }

    private func dividerDragEnded(for key: SplitKey) {
        guard let pending = pendingRatios[key],
              let layout = pending.acknowledgedLayout else { return }
        finishPendingRatio(for: key, generation: pending.generation, layout: layout)
    }

    private func finishPendingRatio(
        for key: SplitKey,
        generation: Int,
        layout: PaneLayout
    ) {
        guard pendingRatios[key]?.generation == generation else { return }
        pendingRatios.removeValue(forKey: key)
        ratioTasks.removeValue(forKey: key)
        displayLayout(.success(layout))
    }

    private func cancelPendingRatio(for key: SplitKey, generation: Int) {
        guard pendingRatios[key]?.generation == generation else { return }
        pendingRatios.removeValue(forKey: key)
        ratioTasks.removeValue(forKey: key)
        if activeTabID == key.tabID {
            model.loadLayout(tabID: key.tabID)
        }
    }

    private func isDraggingDivider(for key: SplitKey) -> Bool {
        guard let rendered = renderedTabs[key.tabID] else { return false }
        return splitViews(in: rendered.view).contains { split in
            splitMetadata[ObjectIdentifier(split)]
                == SplitMetadata(tabID: key.tabID, path: key.path)
                && split.isDraggingDivider
        }
    }

    private func applyingPendingRatios(to layout: PaneLayout) -> PaneLayout {
        var root = layout.root
        for (key, pending) in pendingRatios where key.tabID == layout.tabID {
            root = root.replacingRatio(at: key.path, with: pending.ratio) ?? root
        }
        return layout.replacingRoot(root)
    }

    private func updateRenderedRatio(_ ratio: Double, for key: SplitKey) {
        guard var rendered = renderedTabs[key.tabID],
              let root = rendered.layout.root.replacingRatio(at: key.path, with: ratio) else {
            return
        }
        rendered.layout = rendered.layout.replacingRoot(root)
        renderedTabs[key.tabID] = rendered
    }

    private func applySplitRatios(
        from node: PaneLayout.Node,
        in rootView: NSView,
        tabID: TabID
    ) {
        for split in splitViews(in: rootView) {
            guard let metadata = splitMetadata[ObjectIdentifier(split)],
                  metadata.tabID == tabID,
                  let ratio = node.splitRatio(at: metadata.path) else { continue }
            setSplitPosition(ratio, in: split)
        }
    }

    private func setSplitPosition(_ ratio: Double, in split: TerminalCardSplitView) {
        let extent = split.isVertical ? split.bounds.width : split.bounds.height
        guard extent > 0, split.subviews.count == 2 else { return }
        let firstExtent = split.isVertical
            ? split.subviews[0].frame.width
            : split.subviews[0].frame.height
        let currentCenter = firstExtent + split.dividerThickness / 2
        let targetCenter = extent * min(max(ratio, 0.1), 0.9)
        guard abs(currentCenter - targetCenter) >= 0.5 else { return }

        let identifier = ObjectIdentifier(split)
        suppressedDividerCallbacks.insert(identifier)
        split.setPosition(targetCenter - split.dividerThickness / 2, ofDividerAt: 0)
        DispatchQueue.main.async { [weak self, weak split] in
            guard let self, let split else { return }
            self.suppressedDividerCallbacks.remove(ObjectIdentifier(split))
        }
    }

    private func showLoading() {
        showPlaceholder(stateLabel(title: "Loading layout…", detail: ""))
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
        showPlaceholder(container)
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

    private func mountRenderedTab(_ tabView: NSView) {
        tabView.isHidden = true
        content.pinSubview(tabView)
    }

    private func showRenderedTab(_ tabID: TabID) {
        guard activeTabID == tabID, let selected = renderedTabs[tabID] else { return }
        placeholder?.removeFromSuperview()
        placeholder = nil
        for (candidateID, rendered) in renderedTabs {
            let isSelected = candidateID == tabID
            rendered.view.isHidden = !isSelected
            setPresented(isSelected, in: rendered.view)
        }
        visibleTabID = tabID
        let focusedPaneID = selected.layout.focusedPaneID
        DispatchQueue.main.async { [weak self, weak selectedView = selected.view] in
            guard let self, self.activeTabID == tabID, let selectedView else { return }
            self.terminalViews(in: selectedView)
                .first(where: { $0.paneID == focusedPaneID })?
                .restoreFirstResponder()
        }
    }

    private func showPlaceholder(_ newView: NSView) {
        placeholder?.removeFromSuperview()
        newView.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(newView, positioned: .above, relativeTo: nil)
        NSLayoutConstraint.activate([
            newView.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            newView.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            newView.topAnchor.constraint(equalTo: content.topAnchor),
            newView.bottomAnchor.constraint(equalTo: content.bottomAnchor),
        ])
        placeholder = newView
    }

    private func pruneRenderedTabs() {
        guard let session = model.session else { return }
        let validTabIDs = Set(session.tabs.map(\.id))
        for tabID in Array(renderedTabs.keys) where !validTabIDs.contains(tabID) {
            removeRenderedTab(tabID)
        }
        let validPaneIDs = Set(session.panes.map(\.id))
        for tabID in Array(terminalViewsByTab.keys) {
            terminalViewsByTab[tabID] = terminalViewsByTab[tabID]?.filter {
                validPaneIDs.contains($0.key)
            }
            if terminalViewsByTab[tabID]?.isEmpty == true {
                terminalViewsByTab.removeValue(forKey: tabID)
            }
        }
    }

    private func removeAllRenderedTabs() {
        for tabID in Set(renderedTabs.keys).union(terminalViewsByTab.keys) {
            removeRenderedTab(tabID)
        }
    }

    private func removeRenderedTab(
        _ tabID: TabID,
        preservingTerminalViews: Bool = false
    ) {
        for key in Array(ratioTasks.keys) where key.tabID == tabID {
            ratioTasks.removeValue(forKey: key)?.cancel()
            pendingRatios.removeValue(forKey: key)
        }
        if let rendered = renderedTabs.removeValue(forKey: tabID) {
            setPresented(false, in: rendered.view)
            let removedSplitIDs = Set(splitViews(in: rendered.view).map(ObjectIdentifier.init))
            splitMetadata = splitMetadata.filter { !removedSplitIDs.contains($0.key) }
            rendered.view.removeFromSuperview()
        }
        if !preservingTerminalViews {
            terminalViewsByTab.removeValue(forKey: tabID)
        }
        if visibleTabID == tabID { visibleTabID = nil }
    }

    private func setPresented(_ presented: Bool, in root: NSView) {
        terminalViews(in: root).forEach { $0.setPresented(presented) }
    }

    private func terminalViews(in root: NSView) -> [GhosttyTerminalView] {
        descendants(of: GhosttyTerminalView.self, in: root)
    }

    private func splitViews(in root: NSView) -> [TerminalCardSplitView] {
        descendants(of: TerminalCardSplitView.self, in: root)
    }

    private func descendants<View: NSView>(of type: View.Type, in root: NSView) -> [View] {
        var result: [View] = []
        if let root = root as? View { result.append(root) }
        for subview in root.subviews {
            result.append(contentsOf: descendants(of: type, in: subview))
        }
        return result
    }
}

private struct RenderedTab {
    var layout: PaneLayout
    let view: NSView
}

private struct SplitMetadata: Equatable {
    let tabID: TabID
    let path: [Bool]
}

private struct SplitKey: Hashable {
    let tabID: TabID
    let path: [Bool]
}

private struct PendingSplitRatio {
    let generation: Int
    let ratio: Double
    var acknowledgedLayout: PaneLayout? = nil
}

private extension PaneLayout {
    func replacingRoot(_ root: Node) -> Self {
        Self(
            workspaceID: workspaceID,
            tabID: tabID,
            zoomed: zoomed,
            focusedPaneID: focusedPaneID,
            root: root
        )
    }
}

private extension PaneLayout.Node {
    func hasSameTopology(as other: Self) -> Bool {
        switch (self, other) {
        case let (.pane(lhs), .pane(rhs)):
            lhs == rhs
        case let (
            .split(lhsDirection, _, lhsFirst, lhsSecond),
            .split(rhsDirection, _, rhsFirst, rhsSecond)
        ):
            lhsDirection == rhsDirection
                && lhsFirst.hasSameTopology(as: rhsFirst)
                && lhsSecond.hasSameTopology(as: rhsSecond)
        default:
            false
        }
    }

    func splitRatio(at path: [Bool]) -> Double? {
        guard case let .split(_, ratio, first, second) = self else { return nil }
        guard let step = path.first else { return ratio }
        return (step ? second : first).splitRatio(at: Array(path.dropFirst()))
    }

    func replacingRatio(at path: [Bool], with ratio: Double) -> Self? {
        guard case let .split(direction, existingRatio, first, second) = self else {
            return nil
        }
        guard let step = path.first else {
            return .split(direction: direction, ratio: ratio, first: first, second: second)
        }
        let remaining = Array(path.dropFirst())
        if step {
            guard let replacement = second.replacingRatio(at: remaining, with: ratio) else {
                return nil
            }
            return .split(
                direction: direction,
                ratio: existingRatio,
                first: first,
                second: replacement
            )
        }
        guard let replacement = first.replacingRatio(at: remaining, with: ratio) else {
            return nil
        }
        return .split(
            direction: direction,
            ratio: existingRatio,
            first: replacement,
            second: second
        )
    }
}
