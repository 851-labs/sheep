import AppKit

let application = NSApplication.shared
application.appearance = NSAppearance(named: .darkAqua)
let delegate = AppDelegate()
application.delegate = delegate
application.setActivationPolicy(.regular)
application.run()
