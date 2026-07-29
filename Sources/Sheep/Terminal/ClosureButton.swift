import AppKit

@MainActor
final class ClosureButton: NSButton {
    private let closure: () -> Void
    var showsSelectedBackground = false {
        didSet { needsDisplay = true }
    }

    init(title: String, closure: @escaping () -> Void) {
        self.closure = closure
        super.init(frame: .zero)
        self.title = title
        target = self
        action = #selector(invoke)
    }

    init(image: NSImage, closure: @escaping () -> Void) {
        self.closure = closure
        super.init(frame: .zero)
        self.image = image
        target = self
        action = #selector(invoke)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func draw(_ dirtyRect: NSRect) {
        if showsSelectedBackground {
            Palette.selected.withAlphaComponent(0.18).setFill()
            NSBezierPath(roundedRect: bounds, xRadius: 7, yRadius: 7).fill()
        }
        super.draw(dirtyRect)
    }

    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        needsDisplay = true
    }

    @objc private func invoke() { closure() }
}
