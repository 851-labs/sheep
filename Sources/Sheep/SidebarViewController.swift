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
        spacesTable.style = .sourceList
        spacesTable.selectionHighlightStyle = .sourceList
        spacesTable.rowHeight = 43
        spacesTable.intercellSpacing = .zero
        spacesTable.columnAutoresizingStyle = .lastColumnOnlyAutoresizingStyle
        let spaceColumn = NSTableColumn(identifier: .init("space"))
        spaceColumn.resizingMask = .autoresizingMask
        spacesTable.addTableColumn(spaceColumn)
        spacesTable.dataSource = self
        spacesTable.delegate = self
        spacesTable.setAccessibilityLabel("Spaces")
        let spacesScroll = scrollView(document: spacesTable)

        let agentsHeader = sectionHeader("AGENTS", trailing: "GROUPED")
        agentsOutline.headerView = nil
        agentsOutline.backgroundColor = .clear
        agentsOutline.style = .sourceList
        agentsOutline.selectionHighlightStyle = .sourceList
        agentsOutline.rowHeight = 40
        agentsOutline.indentationPerLevel = 10
        agentsOutline.columnAutoresizingStyle = .lastColumnOnlyAutoresizingStyle
        let agentColumn = NSTableColumn(identifier: .init("agent"))
        agentColumn.resizingMask = .autoresizingMask
        agentsOutline.addTableColumn(agentColumn)
        agentsOutline.outlineTableColumn = agentColumn
        agentsOutline.dataSource = self
        agentsOutline.delegate = self
        agentsOutline.setAccessibilityLabel("Agents grouped by space")
        let agentsScroll = scrollView(document: agentsOutline)

        let sectionDivider = NSBox()
        sectionDivider.boxType = .separator

        [spacesHeader, spacesScroll, sectionDivider, agentsHeader, agentsScroll].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            root.addSubview($0)
        }
        NSLayoutConstraint.activate([
            spacesHeader.topAnchor.constraint(
                equalTo: root.safeAreaLayoutGuide.topAnchor,
                constant: 8
            ),
            spacesHeader.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 12),
            spacesHeader.trailingAnchor.constraint(equalTo: root.trailingAnchor, constant: -12),
            spacesHeader.heightAnchor.constraint(equalToConstant: 22),
            spacesScroll.topAnchor.constraint(equalTo: spacesHeader.bottomAnchor),
            spacesScroll.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            spacesScroll.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            spacesScroll.heightAnchor.constraint(equalTo: root.heightAnchor, multiplier: 0.40),
            sectionDivider.topAnchor.constraint(equalTo: spacesScroll.bottomAnchor),
            sectionDivider.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            sectionDivider.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            sectionDivider.heightAnchor.constraint(equalToConstant: 1),
            agentsHeader.topAnchor.constraint(equalTo: sectionDivider.bottomAnchor, constant: 6),
            agentsHeader.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 12),
            agentsHeader.trailingAnchor.constraint(equalTo: root.trailingAnchor, constant: -12),
            agentsHeader.heightAnchor.constraint(equalToConstant: 22),
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
            status: workspace.agentStatus,
            title: workspace.label,
            detail: model.gitSummaries[workspace.id]?.compactDescription ?? "",
            accessibility: "\(workspace.label) space",
            leadingInset: 10
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
        heightOfRowByItem item: Any
    ) -> CGFloat {
        item is AgentGroup ? 24 : 40
    }

    func outlineView(
        _ outlineView: NSOutlineView,
        viewFor tableColumn: NSTableColumn?,
        item: Any
    ) -> NSView? {
        if let group = item as? AgentGroup {
            let container = NSView()
            let label = NSTextField(labelWithString: group.name.uppercased())
            label.font = .systemFont(ofSize: 10, weight: .semibold)
            label.textColor = .tertiaryLabelColor
            label.alignment = .left
            label.lineBreakMode = .byTruncatingTail
            label.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 2),
                label.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor),
                label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            ])
            container.setAccessibilityLabel("\(group.name) agent group")
            return container
        }
        guard let agent = (item as? AgentItem)?.value else { return nil }
        return rowView(
            status: agent.agentStatus,
            title: agent.displayName,
            detail: agent.displayContext,
            accessibility: "\(agent.displayName), \(agent.agentStatus.rawValue)",
            leadingInset: 2
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
        status agentStatus: AgentStatus,
        title: String,
        detail: String,
        accessibility: String,
        leadingInset: CGFloat
    ) -> NSView {
        let status = statusIndicator(for: agentStatus)

        let titleLabel = NSTextField(labelWithString: title)
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .labelColor
        titleLabel.alignment = .left
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.toolTip = title
        let detailLabel = NSTextField(labelWithString: detail)
        detailLabel.font = .systemFont(ofSize: 10, weight: .regular)
        detailLabel.textColor = .secondaryLabelColor
        detailLabel.alignment = .left
        detailLabel.lineBreakMode = .byTruncatingMiddle
        detailLabel.toolTip = detail

        let row = NSView()
        [status, titleLabel, detailLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview($0)
        }
        NSLayoutConstraint.activate([
            status.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: leadingInset),
            status.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            status.widthAnchor.constraint(equalToConstant: 10),
            status.heightAnchor.constraint(equalToConstant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: status.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: row.topAnchor, constant: 5),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            detailLabel.bottomAnchor.constraint(lessThanOrEqualTo: row.bottomAnchor, constant: -4),
        ])
        row.setAccessibilityLabel(accessibility)
        return row
    }

    private func statusIndicator(for status: AgentStatus) -> NSImageView {
        let symbol: String
        switch status {
        case .done:
            symbol = "checkmark"
        case .unknown:
            symbol = "circle"
        default:
            symbol = "circle.fill"
        }
        let image = NSImage(systemSymbolName: symbol, accessibilityDescription: status.rawValue)?
            .withSymbolConfiguration(.init(pointSize: 7, weight: .bold))
        let indicator = NSImageView(image: image ?? NSImage())
        indicator.contentTintColor = color(for: status)
        indicator.imageScaling = .scaleProportionallyDown
        return indicator
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

    private func sectionHeader(_ title: String, trailing: String? = nil) -> NSView {
        let titleLabel = NSTextField(labelWithString: title)
        titleLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        titleLabel.textColor = .tertiaryLabelColor
        titleLabel.alignment = .left

        var views: [NSView] = [titleLabel, NSView()]
        if let trailing {
            let trailingLabel = NSTextField(labelWithString: trailing)
            trailingLabel.font = .systemFont(ofSize: 10, weight: .medium)
            trailingLabel.textColor = .tertiaryLabelColor
            trailingLabel.alignment = .right
            views.append(trailingLabel)
        }
        let header = NSStackView(views: views)
        header.orientation = .horizontal
        header.alignment = .centerY
        header.setAccessibilityLabel(
            trailing.map { "\(title), \($0)" } ?? title
        )
        return header
    }

    private func scrollView(document: NSView) -> NSScrollView {
        let scroll = NSScrollView()
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = true
        scroll.autohidesScrollers = true
        scroll.documentView = document
        return scroll
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
