import AppKit

enum Palette {
    static let terminal = NSColor.textBackgroundColor
    static let selected = NSColor.selectedContentBackgroundColor
    static let idle = NSColor.systemTeal
    static let working = NSColor.systemYellow
    static let warning = NSColor.systemOrange
    static let blocked = NSColor.systemPink
    static let error = NSColor.systemRed
}

@MainActor
final class NativeContentBackgroundView: NSVisualEffectView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        material = .contentBackground
        blendingMode = .behindWindow
        state = .followsWindowActiveState
    }

    convenience init() {
        self.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

extension NSView {
    func pinSubview(_ child: NSView) {
        child.translatesAutoresizingMaskIntoConstraints = false
        addSubview(child)
        NSLayoutConstraint.activate([
            child.leadingAnchor.constraint(equalTo: leadingAnchor),
            child.trailingAnchor.constraint(equalTo: trailingAnchor),
            child.topAnchor.constraint(equalTo: topAnchor),
            child.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
