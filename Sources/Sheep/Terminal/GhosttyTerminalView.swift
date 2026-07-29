import AppKit
import GhosttyKit
import HerdrSDK
import HerdrSDKLocal

@MainActor
final class GhosttyTerminalView: NSView, @preconcurrency NSTextInputClient {
    nonisolated(unsafe) private(set) var surface: ghostty_surface_t?
    var markedText = NSMutableAttributedString()
    var keyText: [String]?
    private let focusPane: () -> Void
    private var tracking: NSTrackingArea?
    var cursorHidden = false
    private var geometry = GhosttySurfaceGeometryState()

    init?(
        runtime: GhosttyRuntime,
        attachment: HerdrTerminalAttachment,
        pane: Pane,
        focusPane: @escaping () -> Void
    ) {
        guard let app = runtime.app else { return nil }
        self.focusPane = focusPane
        super.init(frame: NSRect(x: 0, y: 0, width: 800, height: 600))
        wantsLayer = true
        updateAdaptiveAppearance()

        let initialScale = Double(NSScreen.main?.backingScaleFactor ?? 2)
        geometry.recordContentScale(x: initialScale, y: initialScale)
        layer?.contentsScale = initialScale

        let command = (
            [attachment.executableURL.path] + attachment.arguments
        ).map(Self.shellQuote).joined(separator: " ")
        var configuration = ghostty_surface_config_new()
        configuration.platform_tag = GHOSTTY_PLATFORM_MACOS
        configuration.platform.macos.nsview = Unmanaged.passUnretained(self).toOpaque()
        configuration.userdata = Unmanaged.passUnretained(self).toOpaque()
        configuration.scale_factor = initialScale
        configuration.context = GHOSTTY_SURFACE_CONTEXT_SPLIT

        surface = command.withCString { commandPointer in
            configuration.command = commandPointer
            if let cwd = pane.foregroundCWD ?? pane.cwd {
                return cwd.withCString { cwdPointer in
                    configuration.working_directory = cwdPointer
                    return ghostty_surface_new(app, &configuration)
                }
            }
            return ghostty_surface_new(app, &configuration)
        }
        guard surface != nil else { return nil }
        updateGhosttyColorScheme()
        updateSurfaceSize()
        updateTrackingAreas()
        setAccessibilityLabel("Terminal \(pane.displayTitle)")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    deinit {
        if cursorHidden { NSCursor.unhide() }
        if let surface { ghostty_surface_free(surface) }
        NotificationCenter.default.removeObserver(self)
    }

    override var acceptsFirstResponder: Bool { true }

    override func becomeFirstResponder() -> Bool {
        guard super.becomeFirstResponder() else { return false }
        if let surface { ghostty_surface_set_focus(surface, true) }
        focusPane()
        return true
    }

    override func resignFirstResponder() -> Bool {
        guard super.resignFirstResponder() else { return false }
        if let surface { ghostty_surface_set_focus(surface, false) }
        return true
    }

    override func layout() {
        super.layout()
        // Divider and window drags continuously relayout this view. Ghostty only
        // needs the framebuffer size here; scale and display changes have their
        // own AppKit notifications.
        updateSurfaceSize()
    }

    override func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        updateSurfaceEnvironment()
    }

    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        updateAdaptiveAppearance()
        updateGhosttyColorScheme()
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        NotificationCenter.default.removeObserver(
            self,
            name: NSWindow.didChangeScreenNotification,
            object: nil
        )
        guard let window else { return }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidChangeScreen(_:)),
            name: NSWindow.didChangeScreenNotification,
            object: window
        )
        updateSurfaceEnvironment()
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if let tracking { removeTrackingArea(tracking) }
        let area = NSTrackingArea(
            rect: bounds,
            options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited, .mouseMoved],
            owner: self
        )
        addTrackingArea(area)
        tracking = area
    }

    override func mouseDown(with event: NSEvent) {
        window?.makeFirstResponder(self)
        sendMouseButton(event, state: GHOSTTY_MOUSE_PRESS, button: GHOSTTY_MOUSE_LEFT)
    }

    override func mouseUp(with event: NSEvent) {
        sendMouseButton(event, state: GHOSTTY_MOUSE_RELEASE, button: GHOSTTY_MOUSE_LEFT)
    }

    override func rightMouseDown(with event: NSEvent) {
        sendMouseButton(event, state: GHOSTTY_MOUSE_PRESS, button: GHOSTTY_MOUSE_RIGHT)
    }

    override func rightMouseUp(with event: NSEvent) {
        sendMouseButton(event, state: GHOSTTY_MOUSE_RELEASE, button: GHOSTTY_MOUSE_RIGHT)
    }

    override func otherMouseDown(with event: NSEvent) {
        sendMouseButton(event, state: GHOSTTY_MOUSE_PRESS, button: GHOSTTY_MOUSE_MIDDLE)
    }

    override func otherMouseUp(with event: NSEvent) {
        sendMouseButton(event, state: GHOSTTY_MOUSE_RELEASE, button: GHOSTTY_MOUSE_MIDDLE)
    }

    override func mouseMoved(with event: NSEvent) {
        guard let surface else { return }
        let point = convert(event.locationInWindow, from: nil)
        ghostty_surface_mouse_pos(
            surface,
            point.x,
            bounds.height - point.y,
            Self.modifiers(event.modifierFlags)
        )
    }

    override func mouseDragged(with event: NSEvent) {
        mouseMoved(with: event)
    }

    override func mouseExited(with event: NSEvent) {
        guard let surface else { return }
        ghostty_surface_mouse_pos(surface, -1, -1, Self.modifiers(event.modifierFlags))
    }

    override func scrollWheel(with event: NSEvent) {
        guard let surface else { return }
        let multiplier = event.hasPreciseScrollingDeltas ? 2.0 : 1.0
        var scrollMods: Int32 = event.hasPreciseScrollingDeltas ? 1 : 0
        scrollMods |= Self.momentum(event.momentumPhase) << 1
        ghostty_surface_mouse_scroll(
            surface,
            event.scrollingDeltaX * multiplier,
            event.scrollingDeltaY * multiplier,
            scrollMods
        )
    }

    override func keyDown(with event: NSEvent) {
        keyText = []
        interpretKeyEvents([event])
        let texts = keyText ?? []
        keyText = nil
        if texts.isEmpty {
            sendKey(event, action: event.isARepeat ? GHOSTTY_ACTION_REPEAT : GHOSTTY_ACTION_PRESS)
        } else {
            for text in texts {
                sendKey(
                    event,
                    action: event.isARepeat ? GHOSTTY_ACTION_REPEAT : GHOSTTY_ACTION_PRESS,
                    text: text
                )
            }
        }
    }

    override func keyUp(with event: NSEvent) {
        sendKey(event, action: GHOSTTY_ACTION_RELEASE)
    }

    override func flagsChanged(with event: NSEvent) {
        let flag: NSEvent.ModifierFlags
        switch event.keyCode {
        case 0x39: flag = .capsLock
        case 0x38, 0x3C: flag = .shift
        case 0x3B, 0x3E: flag = .control
        case 0x3A, 0x3D: flag = .option
        case 0x37, 0x36: flag = .command
        default: return
        }
        sendKey(
            event,
            action: event.modifierFlags.contains(flag)
                ? GHOSTTY_ACTION_PRESS
                : GHOSTTY_ACTION_RELEASE
        )
    }

    override func pressureChange(with event: NSEvent) {
        guard let surface else { return }
        ghostty_surface_mouse_pressure(surface, UInt32(event.stage), Double(event.pressure))
    }

    @objc private func windowDidChangeScreen(_ notification: Notification) {
        updateSurfaceEnvironment()
    }

    private func updateSurfaceEnvironment() {
        guard let surface, let window else { return }
        let scale = Double(window.backingScaleFactor)
        if geometry.recordContentScale(x: scale, y: scale) {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer?.contentsScale = scale
            CATransaction.commit()
            ghostty_surface_set_content_scale(surface, scale, scale)
        }
        if let number = window.screen?.deviceDescription[
            NSDeviceDescriptionKey("NSScreenNumber")
        ] as? NSNumber, geometry.recordDisplayID(number.uint32Value) {
            ghostty_surface_set_display_id(surface, number.uint32Value)
        }
        updateSurfaceSize()
    }

    private func updateSurfaceSize() {
        guard let surface, bounds.width > 0, bounds.height > 0 else { return }
        let scale = geometry.contentScale
            ?? GhosttySurfaceContentScale(x: 1, y: 1)
        let size = GhosttySurfacePixelSize(
            width: UInt32(max(1, bounds.width * scale.x)),
            height: UInt32(max(1, bounds.height * scale.y))
        )
        guard geometry.recordPixelSize(size) else { return }
        ghostty_surface_set_size(
            surface,
            size.width,
            size.height
        )
    }

    private func updateAdaptiveAppearance() {
        effectiveAppearance.performAsCurrentDrawingAppearance {
            layer?.backgroundColor = Palette.terminal.cgColor
        }
    }

    private func updateGhosttyColorScheme() {
        guard let surface else { return }
        let appearance = effectiveAppearance.bestMatch(from: [.aqua, .darkAqua])
        let scheme = appearance == .darkAqua
            ? GHOSTTY_COLOR_SCHEME_DARK
            : GHOSTTY_COLOR_SCHEME_LIGHT
        ghostty_surface_set_color_scheme(surface, scheme)
    }

    private func sendMouseButton(
        _ event: NSEvent,
        state: ghostty_input_mouse_state_e,
        button: ghostty_input_mouse_button_e
    ) {
        mouseMoved(with: event)
        guard let surface else { return }
        ghostty_surface_mouse_button(surface, state, button, Self.modifiers(event.modifierFlags))
    }

    private func sendKey(
        _ event: NSEvent,
        action: ghostty_input_action_e,
        text: String? = nil
    ) {
        guard let surface else { return }
        var input = ghostty_input_key_s()
        input.action = action
        input.mods = Self.modifiers(event.modifierFlags)
        input.consumed_mods = Self.modifiers(
            event.modifierFlags.subtracting([.control, .command])
        )
        input.keycode = UInt32(event.keyCode)
        input.unshifted_codepoint = event.characters(byApplyingModifiers: [])?
            .unicodeScalars.first?.value ?? 0
        if let text, !text.isEmpty {
            text.withCString {
                input.text = $0
                ghostty_surface_key(surface, input)
            }
        } else {
            ghostty_surface_key(surface, input)
        }
    }

    private static func modifiers(_ flags: NSEvent.ModifierFlags) -> ghostty_input_mods_e {
        var value = GHOSTTY_MODS_NONE.rawValue
        if flags.contains(.shift) { value |= GHOSTTY_MODS_SHIFT.rawValue }
        if flags.contains(.control) { value |= GHOSTTY_MODS_CTRL.rawValue }
        if flags.contains(.option) { value |= GHOSTTY_MODS_ALT.rawValue }
        if flags.contains(.command) { value |= GHOSTTY_MODS_SUPER.rawValue }
        if flags.contains(.capsLock) { value |= GHOSTTY_MODS_CAPS.rawValue }
        return ghostty_input_mods_e(value)
    }

    private static func shellQuote(_ value: String) -> String {
        "'\(value.replacingOccurrences(of: "'", with: "'\\''"))'"
    }

    private nonisolated static func momentum(_ phase: NSEvent.Phase) -> Int32 {
        switch phase {
        case .began: 1
        case .stationary: 2
        case .changed: 3
        case .ended: 4
        case .cancelled: 5
        case .mayBegin: 6
        default: 0
        }
    }

}
