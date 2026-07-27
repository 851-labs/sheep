# sheep

A native macOS client for [Herdr](https://herdr.dev), built with Swift,
AppKit, and Ghostty.

## Requirements

- macOS 14 or newer
- Xcode
- Herdr 0.7.5 or newer
- Zig 0.15.2 (for the pinned Ghostty dependency)

## Development

Generate the Xcode project and build:

```sh
xcodegen generate
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer \
  xcodebuild -project Sheep.xcodeproj -scheme Sheep -configuration Debug build
```

Ghostty bootstrap instructions will be added with the terminal integration.

## License

Apache-2.0. See [LICENSE](LICENSE) and
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

