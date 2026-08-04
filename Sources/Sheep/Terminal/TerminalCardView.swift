import AppKit

@MainActor
final class TerminalCardView: NSView {
    static let cornerRadius: CGFloat = 12
    static let unfocusedOverlayOpacity: CGFloat = 0.3

    private let dimmingOverlay = TerminalDimmingOverlayView()
    private(set) var isDimmed = false

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.cornerRadius = Self.cornerRadius
        layer?.cornerCurve = .continuous
        layer?.borderWidth = 1
        layer?.masksToBounds = true

        dimmingOverlay.translatesAutoresizingMaskIntoConstraints = false
        dimmingOverlay.alphaValue = Self.unfocusedOverlayOpacity
        dimmingOverlay.isHidden = true
        addSubview(dimmingOverlay)
        NSLayoutConstraint.activate([
            dimmingOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmingOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmingOverlay.topAnchor.constraint(equalTo: topAnchor),
            dimmingOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        updateAdaptiveAppearance()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        updateAdaptiveAppearance()
    }

    func installContent(_ content: NSView) {
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(content, positioned: .below, relativeTo: dimmingOverlay)
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: leadingAnchor),
            content.trailingAnchor.constraint(equalTo: trailingAnchor),
            content.topAnchor.constraint(equalTo: topAnchor),
            content.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func setDimmed(_ dimmed: Bool) {
        guard isDimmed != dimmed else { return }
        isDimmed = dimmed
        dimmingOverlay.isHidden = !dimmed
    }

    private func updateAdaptiveAppearance() {
        effectiveAppearance.performAsCurrentDrawingAppearance {
            layer?.backgroundColor = NSColor.textBackgroundColor.cgColor
            layer?.borderColor = NSColor.separatorColor.cgColor
            dimmingOverlay.layer?.backgroundColor = NSColor.textBackgroundColor.cgColor
        }
    }
}

@MainActor
private final class TerminalDimmingOverlayView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func hitTest(_ point: NSPoint) -> NSView? {
        nil
    }
}

@MainActor
final class TerminalCardSplitView: NSSplitView {
    static let gutter: CGFloat = 10
    var isDraggingDivider = false

    override var dividerThickness: CGFloat { Self.gutter }

    override func drawDivider(in rect: NSRect) {
        // The window background showing through this draggable region is the gutter.
    }
}
