# sheep

A native macOS client for [Herdr](https://herdr.dev), built with Swift,
AppKit, and Ghostty.

## Requirements

- macOS 14 or newer
- Xcode
- Herdr 0.7.5 or newer
- Zig 0.15.2 (for the pinned Ghostty dependency)

## Development

Clone the pinned Ghostty 1.3.1 source and build its universal XCFramework:

```sh
git submodule update --init --recursive
Scripts/bootstrap-ghostty.sh
```

The generated `GhosttyKit.xcframework` is cached locally but intentionally not
committed. Generate the Xcode project, build, and test:

```sh
xcodegen generate
xcodebuild \
  -project Sheep.xcodeproj \
  -scheme Sheep \
  -configuration Debug \
  build test
```

Xcode 27 beta's archive tools require 8-byte member alignment while Zig 0.15.2
emits valid 2-byte-aligned Darwin archives. If that beta rejects an archive,
`Scripts/repack-darwin-archive.mjs` can repack it with Apple's `ar`. Stable
Xcode versions do not require this compatibility step.

## License

Apache-2.0. See [LICENSE](LICENSE) and
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
