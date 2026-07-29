import AppKit
import GhosttyKit

extension GhosttyTerminalView {
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

    nonisolated static func readClipboard(
        pointer: UnsafeMutableRawPointer?,
        state: UnsafeMutableRawPointer?
    ) -> Bool {
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
