import AppKit
import Testing
@testable import sheep

@MainActor
@Suite
struct AppearanceTests {
    @Test
    func applicationForcesDarkAppearance() {
        #expect(NSApp.appearance?.name == .darkAqua)
    }

    @Test
    func paletteUsesAdaptiveSystemColors() {
        #expect(Palette.terminal == .textBackgroundColor)
        #expect(Palette.selected == .selectedContentBackgroundColor)
        #expect(Palette.idle == .systemTeal)
        #expect(Palette.working == .systemYellow)
        #expect(Palette.warning == .systemOrange)
        #expect(Palette.blocked == .systemPink)
        #expect(Palette.error == .systemRed)
    }

    @Test
    func ghosttyGeometrySeparatesResizeFromDisplayAndScaleChanges() {
        var geometry = GhosttySurfaceGeometryState()
        let initialSize = GhosttySurfacePixelSize(width: 1_600, height: 1_200)

        var changed = geometry.recordContentScale(x: 2, y: 2)
        #expect(changed)
        changed = geometry.recordDisplayID(42)
        #expect(changed)
        changed = geometry.recordPixelSize(initialSize)
        #expect(changed)

        changed = geometry.recordContentScale(x: 2, y: 2)
        #expect(!changed)
        changed = geometry.recordDisplayID(42)
        #expect(!changed)
        changed = geometry.recordPixelSize(initialSize)
        #expect(!changed)

        changed = geometry.recordPixelSize(
            GhosttySurfacePixelSize(width: 1_500, height: 1_200)
        )
        #expect(changed)
        changed = geometry.recordContentScale(x: 2, y: 2)
        #expect(!changed)
        changed = geometry.recordDisplayID(42)
        #expect(!changed)

        changed = geometry.recordContentScale(x: 1, y: 1)
        #expect(changed)
        changed = geometry.recordDisplayID(7)
        #expect(changed)
        changed = geometry.recordPixelSize(
            GhosttySurfacePixelSize(backingSize: CGSize(width: 800, height: 600))
        )
        #expect(changed)
        #expect(geometry.pixelSize == GhosttySurfacePixelSize(width: 800, height: 600))
    }

    @Test
    func ghosttyBackingSizeAlwaysProducesAValidFramebuffer() {
        #expect(
            GhosttySurfacePixelSize(backingSize: .zero)
                == GhosttySurfacePixelSize(width: 1, height: 1)
        )
        #expect(
            GhosttySurfacePixelSize(backingSize: CGSize(width: 1_600, height: 1_200))
                == GhosttySurfacePixelSize(width: 1_600, height: 1_200)
        )
    }

    @Test
    func applicationMenuProvidesNativeWindowAndApplicationShortcuts() {
        let previousMainMenu = NSApp.mainMenu
        let previousServicesMenu = NSApp.servicesMenu
        let previousWindowsMenu = NSApp.windowsMenu
        defer {
            NSApp.mainMenu = previousMainMenu
            NSApp.servicesMenu = previousServicesMenu
            NSApp.windowsMenu = previousWindowsMenu
        }

        let window = NSWindow()
        AppDelegate().installMainMenu(window: window)

        let appMenu = NSApp.mainMenu?.items.first?.submenu
        let hideItem = appMenu?.items.first {
            $0.action == #selector(NSApplication.hide(_:))
        }
        #expect(hideItem?.keyEquivalent == "h")
        #expect(hideItem?.keyEquivalentModifierMask == .command)

        let minimizeItem = NSApp.windowsMenu?.items.first {
            $0.action == #selector(NSWindow.performMiniaturize(_:))
        }
        #expect(minimizeItem?.keyEquivalent == "m")
        #expect(minimizeItem?.keyEquivalentModifierMask == .command)
        #expect(minimizeItem?.target === window)

        let closeItem = NSApp.mainMenu?.items
            .first(where: { $0.submenu?.title == "File" })?
            .submenu?.items.first {
                $0.action == #selector(NSWindow.performClose(_:))
            }
        #expect(closeItem?.keyEquivalent == "w")
        #expect(closeItem?.target === window)
        #expect(NSApp.servicesMenu?.title == "Services")
    }
}
