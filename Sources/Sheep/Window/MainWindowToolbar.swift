import AppKit

@MainActor
final class MainWindowToolbar: NSObject, NSToolbarDelegate {
    static let sidebarTrackingIdentifier = NSToolbarItem.Identifier(
        "SheepSidebarTrackingSeparator"
    )
    static let itemIdentifiers: [NSToolbarItem.Identifier] = [
        .flexibleSpace,
        .toggleSidebar,
        .space,
        sidebarTrackingIdentifier,
        .flexibleSpace,
    ]

    let toolbar: NSToolbar
    private let splitView: NSSplitView

    init(splitView: NSSplitView) {
        self.splitView = splitView
        toolbar = NSToolbar(identifier: "SheepMainWindow")
        super.init()
        toolbar.delegate = self
        toolbar.displayMode = .iconOnly
        toolbar.allowsUserCustomization = false
        toolbar.autosavesConfiguration = false
        for identifier in Self.itemIdentifiers {
            toolbar.insertItem(withItemIdentifier: identifier, at: toolbar.items.count)
        }
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        Self.itemIdentifiers
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        Self.itemIdentifiers
    }

    func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? {
        guard itemIdentifier == Self.sidebarTrackingIdentifier else { return nil }
        return NSTrackingSeparatorToolbarItem(
            identifier: itemIdentifier,
            splitView: splitView,
            dividerIndex: 0
        )
    }
}
