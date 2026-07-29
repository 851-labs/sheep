import AppKit
import HerdrSDK

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

        let spacesHeader = SidebarSectionHeaderView(title: "SPACES")
        spacesTable.headerView = nil
        spacesTable.backgroundColor = .clear
        spacesTable.style = .sourceList
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

        let agentsHeader = SidebarSectionHeaderView(title: "AGENTS", trailing: "GROUPED")
        agentsOutline.headerView = nil
        agentsOutline.backgroundColor = .clear
        agentsOutline.style = .sourceList
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
        return SidebarRowView(
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
        return SidebarRowView(
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

    private func scrollView(document: NSView) -> NSScrollView {
        let scroll = NSScrollView()
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = true
        scroll.autohidesScrollers = true
        scroll.documentView = document
        return scroll
    }
}
