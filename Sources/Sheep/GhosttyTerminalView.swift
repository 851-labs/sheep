import AppKit
import GhosttyKit
import SheepDomain

@MainActor
final class GhosttyTerminalView: NSView, @preconcurrency NSTextInputClient {
    nonisolated(unsafe) private(set) var surface: ghostty_surface_t?
    private var markedText = NSMutableAttributedString()
    private var keyText: [String]?
    private let focusPane: () -> Void
    private var tracking: NSTrackingArea?
    private var cursorHidden = false

    init?(
        runtime: GhosttyRuntime,
        herdrExecutable: URL,
        pane: Pane,
        focusPane: @escaping () -> Void
    ) {
        guard let app = runtime.app else { return nil }
        self.focusPane = focusPane
        super.init(frame: NSRect(x: 0, y: 0, width: 800, height: 600))
        wantsLayer = true
        updateAdaptiveAppearance()

        let command = [
            Self.shellQuote(herdrExecutable.path),
            "terminal", "attach",
            Self.shellQuote(pane.terminalID.rawValue),
            "--takeover",
        ].joined(separator: " ")
        var configuration = ghostty_surface_config_new()
        configuration.platform_tag = GHOSTTY_PLATFORM_MACOS
        configuration.platform.macos.nsview = Unmanaged.passUnretained(self).toOpaque()
        configuration.userdata = Unmanaged.passUnretained(self).toOpaque()
        configuration.scale_factor = Double(NSScreen.main?.backingScaleFactor ?? 2)
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
        updateSurfaceGeometry()
        updateTrackingAreas()
        setAccessibilityLabel("Terminal \(pane.displayTitle)")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    deinit {
        if cursorHidden { NSCursor.unhide() }
        if let surface { ghostty_surface_free(surface) }
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
        updateSurfaceGeometry()
    }

    override func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        updateSurfaceGeometry()
    }

    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        updateAdaptiveAppearance()
        updateGhosttyColorScheme()
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        updateSurfaceGeometry()
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

    @objc func copy(_ sender: Any?) {
        guard let surface else { return }
        var text = ghostty_text_s()
        guard ghostty_surface_read_selection(surface, &text) else { return }
        defer { ghostty_surface_free_text(surface, &text) }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(String(cString: text.text), forType: .string)
    }

    @objc func paste(_ sender: Any?) {
        guard let surface,
              let text = NSPasteboard.general.string(forType: .string) else { return }
        text.withCString { ghostty_surface_text(surface, $0, UInt(text.utf8.count)) }
    }

    func insertText(_ string: Any, replacementRange: NSRange) {
        let value = (string as? NSAttributedString)?.string ?? (string as? String) ?? ""
        unmarkText()
        if keyText != nil {
            keyText?.append(value)
        } else if let surface {
            value.withCString { ghostty_surface_text(surface, $0, UInt(value.utf8.count)) }
        }
    }

    func setMarkedText(
        _ string: Any,
        selectedRange: NSRange,
        replacementRange: NSRange
    ) {
        markedText = NSMutableAttributedString(
            attributedString: (string as? NSAttributedString)
                ?? NSAttributedString(string: (string as? String) ?? "")
        )
        syncPreedit()
    }

    func unmarkText() {
        markedText = NSMutableAttributedString()
        syncPreedit()
    }

    func selectedRange() -> NSRange { NSRange(location: NSNotFound, length: 0) }
    func markedRange() -> NSRange {
        markedText.length == 0
            ? NSRange(location: NSNotFound, length: 0)
            : NSRange(location: 0, length: markedText.length)
    }
    func hasMarkedText() -> Bool { markedText.length > 0 }
    func attributedSubstring(forProposedRange range: NSRange, actualRange: NSRangePointer?) -> NSAttributedString? { nil }
    func validAttributesForMarkedText() -> [NSAttributedString.Key] { [] }
    func characterIndex(for point: NSPoint) -> Int { 0 }
    func firstRect(forCharacterRange range: NSRange, actualRange: NSRangePointer?) -> NSRect {
        guard let surface else { return window?.frame ?? .zero }
        var x = 0.0, y = 0.0, width = 0.0, height = 0.0
        ghostty_surface_ime_point(surface, &x, &y, &width, &height)
        let local = NSRect(x: x, y: bounds.height - y, width: width, height: max(height, 1))
        guard let window else { return local }
        return window.convertToScreen(convert(local, to: nil))
    }

    nonisolated static func handle(target: ghostty_target_s, action: ghostty_action_s) -> Bool {
        guard target.tag == GHOSTTY_TARGET_SURFACE,
              let surface = target.target.surface,
              let pointer = ghostty_surface_userdata(surface) else { return false }
        let view = Unmanaged<GhosttyTerminalView>.fromOpaque(pointer).takeUnretainedValue()
        switch action.tag {
        case GHOSTTY_ACTION_MOUSE_SHAPE:
            Task { @MainActor in view.applyCursor(action.action.mouse_shape) }
            return true
        case GHOSTTY_ACTION_MOUSE_VISIBILITY:
            Task { @MainActor in
                view.applyCursorVisibility(action.action.mouse_visibility)
            }
            return true
        case GHOSTTY_ACTION_MOUSE_OVER_LINK:
            let link = Self.string(
                action.action.mouse_over_link.url,
                length: action.action.mouse_over_link.len
            )
            Task { @MainActor in view.toolTip = link.isEmpty ? nil : link }
            return true
        case GHOSTTY_ACTION_OPEN_URL:
            let link = Self.string(
                action.action.open_url.url,
                length: Int(action.action.open_url.len)
            )
            Task { @MainActor in
                guard let url = URL(string: link) else { return }
                NSWorkspace.shared.open(url)
            }
            return true
        default:
            return false
        }
    }

    nonisolated static func readClipboard(pointer: UnsafeMutableRawPointer?, state: UnsafeMutableRawPointer?) -> Bool {
        guard let pointer else { return false }
        let view = Unmanaged<GhosttyTerminalView>.fromOpaque(pointer).takeUnretainedValue()
        guard let surface = view.surface,
              let text = NSPasteboard.general.string(forType: .string) else { return false }
        text.withCString {
            ghostty_surface_complete_clipboard_request(surface, $0, state, false)
        }
        return true
    }

    nonisolated static func confirmClipboard(
        pointer: UnsafeMutableRawPointer?,
        text: UnsafePointer<CChar>?,
        state: UnsafeMutableRawPointer?
    ) {
        guard let pointer, let text else { return }
        let view = Unmanaged<GhosttyTerminalView>.fromOpaque(pointer).takeUnretainedValue()
        guard let surface = view.surface else { return }
        ghostty_surface_complete_clipboard_request(surface, text, state, true)
    }

    nonisolated static func writeClipboard(
        pointer: UnsafeMutableRawPointer?,
        content: UnsafePointer<ghostty_clipboard_content_s>?,
        count: Int
    ) {
        guard let content, count > 0 else { return }
        for index in 0..<count where String(cString: content[index].mime) == "text/plain" {
            let value = String(cString: content[index].data)
            Task { @MainActor in
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(value, forType: .string)
            }
        }
    }

    nonisolated static func didClose(pointer: UnsafeMutableRawPointer?) {
        guard let pointer else { return }
        let view = Unmanaged<GhosttyTerminalView>.fromOpaque(pointer).takeUnretainedValue()
        Task { @MainActor in view.needsDisplay = true }
    }

    private func updateSurfaceGeometry() {
        guard let surface, bounds.width > 0, bounds.height > 0 else { return }
        let scale = window?.backingScaleFactor ?? 2
        layer?.contentsScale = scale
        ghostty_surface_set_content_scale(surface, scale, scale)
        if let number = window?.screen?.deviceDescription[
            NSDeviceDescriptionKey("NSScreenNumber")
        ] as? NSNumber {
            ghostty_surface_set_display_id(surface, number.uint32Value)
        }
        ghostty_surface_set_size(
            surface,
            UInt32(max(1, bounds.width * scale)),
            UInt32(max(1, bounds.height * scale))
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

    private func syncPreedit() {
        guard let surface else { return }
        let text = markedText.string
        if text.isEmpty {
            ghostty_surface_preedit(surface, nil, 0)
        } else {
            text.withCString { ghostty_surface_preedit(surface, $0, UInt(text.utf8.count)) }
        }
    }

    private func applyCursor(_ shape: ghostty_action_mouse_shape_e) {
        switch shape {
        case GHOSTTY_MOUSE_SHAPE_POINTER:
            NSCursor.pointingHand.set()
        case GHOSTTY_MOUSE_SHAPE_TEXT:
            NSCursor.iBeam.set()
        case GHOSTTY_MOUSE_SHAPE_CROSSHAIR:
            NSCursor.crosshair.set()
        default:
            NSCursor.arrow.set()
        }
    }

    private func applyCursorVisibility(_ visibility: ghostty_action_mouse_visibility_e) {
        switch visibility {
        case GHOSTTY_MOUSE_HIDDEN where !cursorHidden:
            NSCursor.hide()
            cursorHidden = true
        case GHOSTTY_MOUSE_VISIBLE where cursorHidden:
            NSCursor.unhide()
            cursorHidden = false
        default:
            break
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

    private nonisolated static func string(
        _ pointer: UnsafePointer<CChar>?,
        length: Int
    ) -> String {
        guard let pointer, length > 0 else { return "" }
        return String(
            data: Data(bytes: pointer, count: length),
            encoding: .utf8
        ) ?? ""
    }
}
