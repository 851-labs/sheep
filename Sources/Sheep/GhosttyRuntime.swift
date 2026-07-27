import AppKit
import GhosttyKit

private let ghosttyWakeupCallback: @convention(c) (UnsafeMutableRawPointer?) -> Void = {
    guard let pointer = $0 else { return }
    let runtime = Unmanaged<GhosttyRuntime>.fromOpaque(pointer).takeUnretainedValue()
    Task { @MainActor in runtime.tick() }
}

@MainActor
final class GhosttyRuntime {
    private(set) var app: ghostty_app_t?
    private var config: ghostty_config_t?

    init?() {
        guard ghostty_init(UInt(CommandLine.argc), CommandLine.unsafeArgv) == GHOSTTY_SUCCESS else {
            return nil
        }
        guard let config = ghostty_config_new() else { return nil }
        ghostty_config_load_default_files(config)
        ghostty_config_finalize(config)
        self.config = config

        var runtime = ghostty_runtime_config_s(
            userdata: Unmanaged.passUnretained(self).toOpaque(),
            supports_selection_clipboard: false,
            wakeup_cb: ghosttyWakeupCallback,
            action_cb: { _, target, action in
                GhosttyTerminalView.handle(target: target, action: action)
            },
            read_clipboard_cb: { pointer, _, state in
                GhosttyTerminalView.readClipboard(pointer: pointer, state: state)
            },
            confirm_read_clipboard_cb: { pointer, text, state, _ in
                GhosttyTerminalView.confirmClipboard(pointer: pointer, text: text, state: state)
            },
            write_clipboard_cb: { pointer, _, content, count, _ in
                GhosttyTerminalView.writeClipboard(pointer: pointer, content: content, count: count)
            },
            close_surface_cb: { pointer, _ in
                GhosttyTerminalView.didClose(pointer: pointer)
            }
        )
        guard let app = ghostty_app_new(&runtime, config) else { return nil }
        self.app = app
        ghostty_app_set_focus(app, NSApp.isActive)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appBecameActive),
            name: NSApplication.didBecomeActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appResignedActive),
            name: NSApplication.didResignActiveNotification,
            object: nil
        )
    }

    isolated deinit {
        NotificationCenter.default.removeObserver(self)
        if let app { ghostty_app_free(app) }
        if let config { ghostty_config_free(config) }
    }

    func tick() {
        guard let app else { return }
        ghostty_app_tick(app)
    }

    @objc private func appBecameActive() {
        if let app { ghostty_app_set_focus(app, true) }
    }

    @objc private func appResignedActive() {
        if let app { ghostty_app_set_focus(app, false) }
    }
}
