import AppKit

@MainActor
final class TerminalCardView: NSView {
    static let cornerRadius: CGFloat = 12
    static let unfocusedOverlayOpacity: CGFloat = 0.3
    static let resizeIndicatorDuration = Duration.milliseconds(750)
    static let resizeIndicatorReadinessDelay = Duration.milliseconds(500)

    private let dimmingOverlay = TerminalDimmingOverlayView()
    private let resizeIndicator = TerminalResizeIndicatorView()
    private var resizeIndicatorTask: Task<Void, Never>?
    private var resizeIndicatorReady = false
    private(set) var isDimmed = false
    private(set) var contentView: NSView?
    var isResizeIndicatorVisible: Bool { !resizeIndicator.isHidden }
    var resizeIndicatorText: String { resizeIndicator.stringValue }
    var resizeIndicatorUsesLiquidGlass: Bool { resizeIndicator.usesLiquidGlass }
    var resizeIndicatorCornerRadius: CGFloat { resizeIndicator.pillCornerRadius }

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

        resizeIndicator.translatesAutoresizingMaskIntoConstraints = false
        resizeIndicator.isHidden = true
        addSubview(resizeIndicator, positioned: .below, relativeTo: dimmingOverlay)
        NSLayoutConstraint.activate([
            resizeIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            resizeIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        Task { [weak self] in
            try? await Task.sleep(for: Self.resizeIndicatorReadinessDelay)
            guard !Task.isCancelled else { return }
            self?.resizeIndicatorReady = true
        }
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
        contentView = content
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(content, positioned: .below, relativeTo: resizeIndicator)
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: leadingAnchor),
            content.trailingAnchor.constraint(equalTo: trailingAnchor),
            content.topAnchor.constraint(equalTo: topAnchor),
            content.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        if let terminal = content as? GhosttyTerminalView {
            terminal.gridSizeDidChange = { [weak self] size in
                self?.terminalGridSizeDidChange(size)
            }
        }
    }

    func setDimmed(_ dimmed: Bool) {
        guard isDimmed != dimmed else { return }
        isDimmed = dimmed
        dimmingOverlay.isHidden = !dimmed
    }

    func showResizeIndicator(columns: UInt16, rows: UInt16) {
        resizeIndicator.stringValue = "\(columns) ⨯ \(rows)"
        resizeIndicator.isHidden = false
        resizeIndicatorTask?.cancel()
        resizeIndicatorTask = Task { [weak self] in
            try? await Task.sleep(for: Self.resizeIndicatorDuration)
            guard !Task.isCancelled else { return }
            self?.resizeIndicator.isHidden = true
        }
    }

    private func terminalGridSizeDidChange(_ size: GhosttyTerminalGridSize) {
        guard resizeIndicatorReady,
              window != nil,
              !isHiddenOrHasHiddenAncestor else { return }
        showResizeIndicator(columns: size.columns, rows: size.rows)
    }

    private func updateAdaptiveAppearance() {
        effectiveAppearance.performAsCurrentDrawingAppearance {
            layer?.backgroundColor = NSColor.textBackgroundColor.cgColor
            layer?.borderColor = NSColor.separatorColor.cgColor
            dimmingOverlay.layer?.backgroundColor = NSColor.textBackgroundColor.cgColor
        }
    }
}

private extension NSView {
    var isHiddenOrHasHiddenAncestor: Bool {
        if isHidden { return true }
        return superview?.isHiddenOrHasHiddenAncestor ?? false
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
private final class TerminalResizeIndicatorView: NSView {
    private let label = NSTextField(labelWithString: "")
    private let backgroundView: NSView

    let usesLiquidGlass: Bool
    private(set) var pillCornerRadius: CGFloat = 0

    var stringValue: String {
        get { label.stringValue }
        set { label.stringValue = newValue }
    }

    override init(frame frameRect: NSRect) {
        if #available(macOS 26.0, *) {
            let glass = NSGlassEffectView()
            glass.style = .regular
            backgroundView = glass
            usesLiquidGlass = true
        } else {
            let material = NSVisualEffectView()
            material.material = .hudWindow
            material.blendingMode = .withinWindow
            material.state = .active
            backgroundView = material
            usesLiquidGlass = false
        }
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.shadowColor = NSColor.black.cgColor
        layer?.shadowOpacity = 0.3
        layer?.shadowRadius = 5
        layer?.shadowOffset = NSSize(width: 0, height: -1)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .labelColor
        label.alignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label, positioned: .above, relativeTo: backgroundView)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func hitTest(_ point: NSPoint) -> NSView? {
        nil
    }

    override func layout() {
        super.layout()
        pillCornerRadius = bounds.height / 2
        if #available(macOS 26.0, *), let glass = backgroundView as? NSGlassEffectView {
            glass.cornerRadius = pillCornerRadius
        } else {
            backgroundView.wantsLayer = true
            backgroundView.layer?.cornerRadius = pillCornerRadius
            backgroundView.layer?.cornerCurve = .continuous
            backgroundView.layer?.masksToBounds = true
        }
        layer?.shadowPath = CGPath(
            roundedRect: bounds,
            cornerWidth: pillCornerRadius,
            cornerHeight: pillCornerRadius,
            transform: nil
        )
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
