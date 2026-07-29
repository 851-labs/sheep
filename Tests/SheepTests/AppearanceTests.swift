import AppKit
import XCTest
@testable import sheep

@MainActor
final class AppearanceTests: XCTestCase {
    func testApplicationForcesDarkAppearance() {
        XCTAssertEqual(NSApp.appearance?.name, .darkAqua)
    }

    func testPaletteUsesAdaptiveSystemColors() {
        XCTAssertEqual(Palette.terminal, .textBackgroundColor)
        XCTAssertEqual(Palette.selected, .selectedContentBackgroundColor)
        XCTAssertEqual(Palette.idle, .systemTeal)
        XCTAssertEqual(Palette.working, .systemYellow)
        XCTAssertEqual(Palette.warning, .systemOrange)
        XCTAssertEqual(Palette.blocked, .systemPink)
        XCTAssertEqual(Palette.error, .systemRed)
    }

    func testGhosttyGeometrySeparatesResizeFromDisplayAndScaleChanges() {
        var geometry = GhosttySurfaceGeometryState()
        let initialSize = GhosttySurfacePixelSize(width: 1_600, height: 1_200)

        XCTAssertTrue(geometry.recordContentScale(x: 2, y: 2))
        XCTAssertTrue(geometry.recordDisplayID(42))
        XCTAssertTrue(geometry.recordPixelSize(initialSize))

        XCTAssertFalse(geometry.recordContentScale(x: 2, y: 2))
        XCTAssertFalse(geometry.recordDisplayID(42))
        XCTAssertFalse(geometry.recordPixelSize(initialSize))

        XCTAssertTrue(
            geometry.recordPixelSize(
                GhosttySurfacePixelSize(width: 1_500, height: 1_200)
            )
        )
        XCTAssertFalse(geometry.recordContentScale(x: 2, y: 2))
        XCTAssertFalse(geometry.recordDisplayID(42))

        XCTAssertTrue(geometry.recordContentScale(x: 1, y: 1))
        XCTAssertTrue(geometry.recordDisplayID(7))
    }
}
