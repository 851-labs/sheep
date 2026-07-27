import AppKit

enum Palette {
    static let window = NSColor(srgbRed: 0.105, green: 0.115, blue: 0.145, alpha: 1)
    static let sidebar = NSColor(srgbRed: 0.115, green: 0.125, blue: 0.16, alpha: 1)
    static let terminal = NSColor(srgbRed: 0.12, green: 0.135, blue: 0.16, alpha: 1)
    static let selected = NSColor(srgbRed: 0.18, green: 0.17, blue: 0.27, alpha: 1)
    static let line = NSColor.white.withAlphaComponent(0.075)
    static let cyan = NSColor(srgbRed: 0.47, green: 0.9, blue: 0.82, alpha: 1)
    static let yellow = NSColor(srgbRed: 0.97, green: 0.76, blue: 0.42, alpha: 1)
    static let pink = NSColor(srgbRed: 0.9, green: 0.55, blue: 0.7, alpha: 1)
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
