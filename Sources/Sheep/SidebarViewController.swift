import AppKit
import SheepDomain

@MainActor
final class SidebarViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate,
    NSOutlineViewDataSource, NSOutlineViewDelegate {
    private let model: AppModel
    private let spacesTable = NSTableView()
    private let agentsOutline = NSOutlineView()
    private var agentGroups: [AgentGroup] = []
    private var isApplyingSnapshot = false

    init(model: AppModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func loadView() {
        let root = NSVisualEffectView()
        root.material = .sidebar
        root.blendingMode = .behindWindow
        root.state = .followsWindowActiveState

        let spacesHeader = sectionHeader("SPACES")
        spacesTable.headerView = nil
        spacesTable.backgroundColor = .clear
        spacesTable.selectionHighlightStyle = .regular
        spacesTable.rowHeight = 43
        spacesTable.intercellSpacing = .zero
        spacesTable.addTableColumn(NSTableColumn(identifier: .init("space")))
        spacesTable.dataSource = self
        spacesTable.delegate = self
        spacesTable.setAccessibilityLabel("Spaces")
        let spacesScroll = scrollView(document: spacesTable)

        let agentsHeader = sectionHeader("AGENTS")
        agentsOutline.headerView = nil
        agentsOutline.backgroundColor = .clear
        agentsOutline.selectionHighlightStyle = .regular
        agentsOutline.rowHeight = 40
        agentsOutline.indentationPerLevel = 10
        let agentColumn = NSTableColumn(identifier: .init("agent"))
        agentsOutline.addTableColumn(agentColumn)
        agentsOutline.outlineTableColumn = agentColumn
        agentsOutline.dataSource = self
        agentsOutline.delegate = self
        agentsOutline.setAccessibilityLabel("Agents grouped by space")
        let agentsScroll = scrollView(document: agentsOutline)

        let newButton = NSButton(title: "New", target: self, action: #selector(createWorkspace))
        newButton.isBordered = false
        newButton.font = .systemFont(ofSize: 12, weight: .regular)
        newButton.contentTintColor = .secondaryLabelColor
        newButton.setAccessibilityLabel("Create space")

        let menuButton = NSButton(
            image: NSImage(systemSymbolName: "ellipsis.circle", accessibilityDescription: "Menu")!,
            target: self,
            action: #selector(showMenu(_:))
        )
        menuButton.isBordered = false
        menuButton.contentTintColor = .secondaryLabelColor

        let footer = NSStackView(views: [newButton, NSView(), menuButton])
        footer.orientation = .horizontal
        footer.alignment = .centerY
        footer.edgeInsets = NSEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let footerSeparator = NSBox()
        footerSeparator.boxType = .separator

        [spacesHeader, spacesScroll, footerSeparator, footer, agentsHeader, agentsScroll].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            root.addSubview($0)
        }
        NSLayoutConstraint.activate([
            spacesHeader.topAnchor.constraint(equalTo: root.topAnchor, constant: 8),
            spacesHeader.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 10),
            spacesHeader.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            spacesHeader.heightAnchor.constraint(equalToConstant: 24),
            spacesScroll.topAnchor.constraint(equalTo: spacesHeader.bottomAnchor),
            spacesScroll.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            spacesScroll.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            spacesScroll.heightAnchor.constraint(equalTo: root.heightAnchor, multiplier: 0.43),
            footerSeparator.topAnchor.constraint(equalTo: spacesScroll.bottomAnchor),
            footerSeparator.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            footerSeparator.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            footerSeparator.heightAnchor.constraint(equalToConstant: 1),
            footer.topAnchor.constraint(equalTo: footerSeparator.bottomAnchor),
            footer.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            footer.heightAnchor.constraint(equalToConstant: 38),
            agentsHeader.topAnchor.constraint(equalTo: footer.bottomAnchor, constant: 5),
            agentsHeader.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 10),
            agentsHeader.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            agentsHeader.heightAnchor.constraint(equalToConstant: 24),
            agentsScroll.topAnchor.constraint(equalTo: agentsHeader.bottomAnchor),
            agentsScroll.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            agentsScroll.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            agentsScroll.bottomAnchor.constraint(equalTo: root.bottomAnchor),
        ])
        view = root
    }

    func reload() {
        isApplyingSnapshot = true
        defer { isApplyingSnapshot = false }
        agentGroups = groupedAgents()
        spacesTable.reloadData()
        agentsOutline.reloadData()
        agentsOutline.expandItem(nil, expandChildren: true)

        if let session = model.session,
           let index = session.workspaces.firstIndex(where: { $0.id == session.focusedWorkspaceID }) {
            spacesTable.selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
            spacesTable.scrollRowToVisible(index)
        }
        if let paneID = model.session?.focusedPaneID {
            for group in agentGroups {
                if let agent = group.agents.first(where: { $0.value.paneID == paneID }) {
                    agentsOutline.selectRowIndexes(
                        IndexSet(integer: agentsOutline.row(forItem: agent)),
                        byExtendingSelection: false
                    )
                }
            }
        }
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        model.session?.workspaces.count ?? 0
    }

    func tableView(
        _ tableView: NSTableView,
        viewFor tableColumn: NSTableColumn?,
        row: Int
    ) -> NSView? {
        guard let workspace = model.session?.workspaces[row] else { return nil }
        return rowView(
            dot: color(for: workspace.agentStatus),
            title: workspace.label,
            detail: model.gitSummaries[workspace.id]?.compactDescription ?? "",
            accessibility: "\(workspace.label) space"
        )
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard !isApplyingSnapshot,
              notification.object as? NSTableView === spacesTable,
              spacesTable.selectedRow >= 0,
              let workspace = model.session?.workspaces[spacesTable.selectedRow],
              workspace.id != model.session?.focusedWorkspaceID else { return }
        model.focusWorkspace(workspace.id)
    }

    func outlineView(
        _ outlineView: NSOutlineView,
        numberOfChildrenOfItem item: Any?
    ) -> Int {
        if let group = item as? AgentGroup { return group.agents.count }
        return agentGroups.count
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let group = item as? AgentGroup { return group.agents[index] }
        return agentGroups[index]
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        item is AgentGroup
    }

    func outlineView(
        _ outlineView: NSOutlineView,
        viewFor tableColumn: NSTableColumn?,
        item: Any
    ) -> NSView? {
        if let group = item as? AgentGroup {
            let label = NSTextField(labelWithString: group.name.uppercased())
            label.font = .systemFont(ofSize: 10, weight: .semibold)
            label.textColor = .tertiaryLabelColor
            return label
        }
        guard let agent = (item as? AgentItem)?.value else { return nil }
        return rowView(
            dot: color(for: agent.agentStatus),
            title: agent.displayName,
            detail: agent.displayContext,
            accessibility: "\(agent.displayName), \(agent.agentStatus.rawValue)"
        )
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard !isApplyingSnapshot,
              agentsOutline.selectedRow >= 0,
              let agent = (agentsOutline.item(atRow: agentsOutline.selectedRow) as? AgentItem)?.value,
              agent.paneID != model.session?.focusedPaneID else { return }
        model.focusPane(agent.paneID)
    }

    private func groupedAgents() -> [AgentGroup] {
        guard let session = model.session else { return [] }
        return session.workspaces.compactMap { workspace in
            let agents = session.agents
                .filter { $0.workspaceID == workspace.id }
                .map(AgentItem.init)
            return agents.isEmpty ? nil : AgentGroup(name: workspace.label, agents: agents)
        }
    }

    private func rowView(
        dot: NSColor,
        title: String,
        detail: String,
        accessibility: String
    ) -> NSView {
        let status = NSTextField(labelWithString: "●")
        status.font = .systemFont(ofSize: 10)
        status.textColor = dot
        status.setContentHuggingPriority(.required, for: .horizontal)

        let titleLabel = NSTextField(labelWithString: title)
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .labelColor
        titleLabel.lineBreakMode = .byTruncatingTail
        let detailLabel = NSTextField(labelWithString: detail)
        detailLabel.font = .systemFont(ofSize: 10, weight: .regular)
        detailLabel.textColor = .secondaryLabelColor
        detailLabel.lineBreakMode = .byTruncatingMiddle
        let text = NSStackView(views: [titleLabel, detailLabel])
        text.orientation = .vertical
        text.spacing = 1

        let row = NSStackView(views: [status, text])
        row.orientation = .horizontal
        row.alignment = .centerY
        row.spacing = 7
        row.edgeInsets = NSEdgeInsets(top: 3, left: 9, bottom: 3, right: 8)
        row.setAccessibilityLabel(accessibility)
        return row
    }

    private func color(for status: AgentStatus) -> NSColor {
        switch status {
        case .working: Palette.working
        case .blocked: Palette.blocked
        case .done: .systemGreen
        case .idle: Palette.idle
        case .unknown: .tertiaryLabelColor
        }
    }

    private func sectionHeader(_ title: String) -> NSTextField {
        let label = NSTextField(labelWithString: title)
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .tertiaryLabelColor
        return label
    }

    private func scrollView(document: NSView) -> NSScrollView {
        let scroll = NSScrollView()
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = true
        scroll.autohidesScrollers = true
        scroll.documentView = document
        return scroll
    }

    @objc private func createWorkspace() {
        model.createWorkspace()
    }

    @objc private func showMenu(_ sender: NSButton) {
        let menu = NSMenu()
        menu.addItem(withTitle: "New Space…", action: #selector(createWorkspace), keyEquivalent: "")
        menu.addItem(withTitle: "New Tab", action: #selector(createTab), keyEquivalent: "t")
        menu.items.forEach { $0.target = self }
        menu.popUp(positioning: nil, at: NSPoint(x: 0, y: sender.bounds.maxY), in: sender)
    }

    @objc private func createTab() {
        model.createTab()
    }

}

private final class AgentGroup {
    let name: String
    let agents: [AgentItem]

    init(name: String, agents: [AgentItem]) {
        self.name = name
        self.agents = agents
    }
}

private final class AgentItem {
    let value: Agent

    init(_ value: Agent) {
        self.value = value
    }
}
