import CoreGraphics

struct GhosttySurfaceContentScale: Equatable {
    let x: CGFloat
    let y: CGFloat

    init(x: Double, y: Double) {
        self.x = CGFloat(x)
        self.y = CGFloat(y)
    }
}

struct GhosttySurfacePixelSize: Equatable {
    let width: UInt32
    let height: UInt32
}

struct GhosttySurfaceGeometryState {
    private(set) var contentScale: GhosttySurfaceContentScale?
    private(set) var displayID: UInt32?
    private(set) var pixelSize: GhosttySurfacePixelSize?

    @discardableResult
    mutating func recordContentScale(x: Double, y: Double) -> Bool {
        let next = GhosttySurfaceContentScale(x: x, y: y)
        guard contentScale != next else { return false }
        contentScale = next
        return true
    }

    @discardableResult
    mutating func recordDisplayID(_ next: UInt32) -> Bool {
        guard displayID != next else { return false }
        displayID = next
        return true
    }

    @discardableResult
    mutating func recordPixelSize(_ next: GhosttySurfacePixelSize) -> Bool {
        guard pixelSize != next else { return false }
        pixelSize = next
        return true
    }
}
