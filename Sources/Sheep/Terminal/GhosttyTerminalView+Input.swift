import AppKit
import GhosttyKit

extension GhosttyTerminalView {
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

    func attributedSubstring(
        forProposedRange range: NSRange,
        actualRange: NSRangePointer?
    ) -> NSAttributedString? {
        nil
    }

    func validAttributesForMarkedText() -> [NSAttributedString.Key] { [] }
    func characterIndex(for point: NSPoint) -> Int { 0 }

    func firstRect(
        forCharacterRange range: NSRange,
        actualRange: NSRangePointer?
    ) -> NSRect {
        guard let surface else { return window?.frame ?? .zero }
        var x = 0.0, y = 0.0, width = 0.0, height = 0.0
        ghostty_surface_ime_point(surface, &x, &y, &width, &height)
        let local = NSRect(x: x, y: bounds.height - y, width: width, height: max(height, 1))
        guard let window else { return local }
        return window.convertToScreen(convert(local, to: nil))
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
}
