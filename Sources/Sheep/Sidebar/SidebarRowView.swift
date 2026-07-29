import AppKit
import HerdrSDK

@MainActor
final class SidebarRowView: NSView {
    init(
        status agentStatus: AgentStatus,
        title: String,
        detail: String,
        accessibility: String,
        leadingInset: CGFloat
    ) {
        super.init(frame: .zero)
        let status = Self.statusIndicator(for: agentStatus)
        let titleLabel = NSTextField(labelWithString: title)
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .labelColor
        titleLabel.alignment = .left
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.toolTip = title

        let detailLabel = NSTextField(labelWithString: detail)
        detailLabel.font = .systemFont(ofSize: 10)
        detailLabel.textColor = .secondaryLabelColor
        detailLabel.alignment = .left
        detailLabel.lineBreakMode = .byTruncatingMiddle
        detailLabel.toolTip = detail

        [status, titleLabel, detailLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        NSLayoutConstraint.activate([
            status.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingInset),
            status.centerYAnchor.constraint(equalTo: centerYAnchor),
            status.widthAnchor.constraint(equalToConstant: 10),
            status.heightAnchor.constraint(equalToConstant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: status.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            detailLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -4),
        ])
        setAccessibilityLabel(accessibility)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private static func statusIndicator(for status: AgentStatus) -> NSImageView {
        let symbol = switch status {
        case .done: "checkmark"
        case .unknown: "circle"
        default: "circle.fill"
        }
        let image = NSImage(systemSymbolName: symbol, accessibilityDescription: status.rawValue)?
            .withSymbolConfiguration(.init(pointSize: 7, weight: .bold))
        let indicator = NSImageView(image: image ?? NSImage())
        indicator.contentTintColor = color(for: status)
        indicator.imageScaling = .scaleProportionallyDown
        return indicator
    }

    private static func color(for status: AgentStatus) -> NSColor {
        switch status {
        case .working: Palette.working
        case .blocked: Palette.blocked
        case .done: .systemGreen
        case .idle: Palette.idle
        case .unknown: .tertiaryLabelColor
        }
    }
}

@MainActor
final class SidebarSectionHeaderView: NSStackView {
    init(title: String, trailing: String? = nil) {
        let titleLabel = NSTextField(labelWithString: title)
        titleLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        titleLabel.textColor = .tertiaryLabelColor
        titleLabel.alignment = .left

        var views: [NSView] = [titleLabel, NSView()]
        if let trailing {
            let trailingLabel = NSTextField(labelWithString: trailing)
            trailingLabel.font = .systemFont(ofSize: 10, weight: .medium)
            trailingLabel.textColor = .tertiaryLabelColor
            trailingLabel.alignment = .right
            views.append(trailingLabel)
        }
        super.init(frame: .zero)
        views.forEach(addArrangedSubview)
        orientation = .horizontal
        alignment = .centerY
        setAccessibilityLabel(trailing.map { "\(title), \($0)" } ?? title)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
