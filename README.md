# sheep

A native macOS client for [Herdr](https://herdr.dev), built with Swift,
AppKit, and Ghostty.

## Requirements

- macOS 13 or newer
- Xcode
- Herdr 0.7.5 or newer
- Zig 0.15.2 (for the pinned Ghostty dependency)

## Development

Initialize the pinned Herdr 0.7.5 and Ghostty 1.3.1 source trees, then build
Ghostty's universal XCFramework:

```sh
git submodule update --init --recursive
Scripts/bootstrap-ghostty.sh
```

Sheep uses an installed Herdr executable by default. To develop against the
pinned Herdr source instead:

```sh
cargo build --release --manifest-path .repos/herdr/Cargo.toml
HERDR_BIN_PATH="$PWD/.repos/herdr/target/release/herdr" \
  /path/to/sheep.app/Contents/MacOS/sheep
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

## HerdrSDK

Sheep is built on the in-repository `HerdrSDK` Swift package. It provides the
complete Herdr protocol-17 API, typed events, reconnecting session observation,
local server supervision, and direct terminal attachment configuration.

Regenerate its public protocol models after updating the pinned Herdr source:

```sh
npm ci --prefix Tools/HerdrSDKGenerator
node Tools/HerdrSDKGenerator/generate.mjs
Scripts/check-herdr-sdk-generation.sh
Scripts/check-herdr-sdk-coverage.sh
```

Generated Swift sources are committed so applications consuming the package do
not need Node, Rust, or the Herdr source tree. The coverage gate requires 100%
line coverage for handwritten `HerdrSDK` and `HerdrSDKLocal` production code;
generated schema models are covered by the deterministic generation drift check.

Build a release app containing both Apple Silicon and Intel slices with:

```sh
Scripts/build-universal-macos.sh
```

Xcode 27 beta's archive tools require 8-byte member alignment while Zig 0.15.2
emits valid 2-byte-aligned Darwin archives. The Ghostty bootstrap automatically
uses `Scripts/repack-darwin-archive.mjs` while aggregating its static libraries.
Stable Xcode versions do not require this compatibility step.

## License

Apache-2.0. See [LICENSE](LICENSE).
