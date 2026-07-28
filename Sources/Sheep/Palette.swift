import AppKit

enum Palette {
    static let window = NSColor.windowBackgroundColor
    static let terminal = NSColor.textBackgroundColor
    static let selected = NSColor.selectedContentBackgroundColor
    static let idle = NSColor.systemTeal
    static let working = NSColor.systemYellow
    static let warning = NSColor.systemOrange
    static let blocked = NSColor.systemPink
    static let error = NSColor.systemRed
}

@MainActor
final class AdaptiveBackgroundView: NSView {
    private let fillColor: NSColor

    init(color: NSColor) {
        fillColor = color
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func draw(_ dirtyRect: NSRect) {
        fillColor.setFill()
        dirtyRect.fill()
    }

    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        needsDisplay = true
    }
}

@MainActor
final class AdaptiveBackgroundStackView: NSStackView {
    private let fillColor: NSColor

    init(color: NSColor) {
        fillColor = color
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func draw(_ dirtyRect: NSRect) {
        fillColor.setFill()
        dirtyRect.fill()
        super.draw(dirtyRect)
    }

    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        needsDisplay = true
    }
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
