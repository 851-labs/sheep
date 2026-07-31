#!/bin/zsh

set -euo pipefail

REPOSITORY_ROOT=${0:A:h:h}
GHOSTTY_ROOT="$REPOSITORY_ROOT/.repos/ghostty"
FRAMEWORK_PATH="$GHOSTTY_ROOT/macos/GhosttyKit.xcframework"
MACOS_LIBRARY="$FRAMEWORK_PATH/macos-arm64_x86_64/ghostty-internal.a"
REVISION_PATH="$FRAMEWORK_PATH/.sheep-source-revision"
GHOSTTY_REVISION=$(git -C "$GHOSTTY_ROOT" rev-parse HEAD)
ZIG_BIN=${SHEEP_ZIG_BIN:-}

if [[ -z "$ZIG_BIN" ]]; then
  for candidate in \
    /opt/homebrew/opt/zig@0.16/bin/zig \
    /usr/local/opt/zig@0.16/bin/zig \
    "$(command -v zig || true)"; do
    if [[ -x "$candidate" && "$("$candidate" version)" == "0.16.0" ]]; then
      ZIG_BIN="$candidate"
      break
    fi
  done
fi

if [[ ! -f "$GHOSTTY_ROOT/build.zig" ]]; then
  print -u2 "Ghostty is not initialized. Run: git submodule update --init --recursive"
  exit 1
fi

if [[ -z "$ZIG_BIN" ]]; then
  print -u2 "Zig 0.16.0 is required but was not found."
  exit 1
fi

ZIG_VERSION=$("$ZIG_BIN" version)
if [[ "$ZIG_VERSION" != "0.16.0" ]]; then
  print -u2 "Zig 0.16.0 is required; found $ZIG_VERSION at $ZIG_BIN."
  exit 1
fi

if [[ -f "$MACOS_LIBRARY" ]] \
  && [[ -f "$REVISION_PATH" ]] \
  && [[ "$(<"$REVISION_PATH")" == "$GHOSTTY_REVISION" ]] \
  && lipo "$MACOS_LIBRARY" -verify_arch arm64 \
  && lipo "$MACOS_LIBRARY" -verify_arch x86_64 \
  && nm -gU "$MACOS_LIBRARY" 2>/dev/null \
    | awk '$3 == "_ghostty_init" { found = 1 } END { exit !found }'; then
  print "GhosttyKit.xcframework is already universal."
  exit 0
fi

cd "$GHOSTTY_ROOT"
rm -rf "$FRAMEWORK_PATH"
PIXEL_FORMAT_SOURCE="$GHOSTTY_ROOT/pkg/macos/video/pixel_format.zig"
BUILD_SOURCE="$GHOSTTY_ROOT/build.zig"
PATCH_BACKUP_DIRECTORY=$(mktemp -d)
PATCH_BACKUP_SOURCE="$PATCH_BACKUP_DIRECTORY/pixel_format.zig"
PATCH_BACKUP_BUILD="$PATCH_BACKUP_DIRECTORY/build.zig"

cp "$PIXEL_FORMAT_SOURCE" "$PATCH_BACKUP_SOURCE"
cp "$BUILD_SOURCE" "$PATCH_BACKUP_BUILD"
restore_ghostty_source() {
  cp "$PATCH_BACKUP_SOURCE" "$PIXEL_FORMAT_SOURCE"
  cp "$PATCH_BACKUP_BUILD" "$BUILD_SOURCE"
  rm "$PATCH_BACKUP_SOURCE"
  rm "$PATCH_BACKUP_BUILD"
  rmdir "$PATCH_BACKUP_DIRECTORY"
}
trap restore_ghostty_source EXIT

# Ghostty names this CoreVideo FourCC through an SDK symbol that was
# introduced after the macOS 14 runner SDK. The value itself is stable and
# public (`r210`), so compile the pin against older SDKs using that value.
perl -0pi -e \
  's/@"30RGB_r210" = c\.kCVPixelFormatType_30RGB_r210,/@"30RGB_r210" = 0x72323130,/' \
  "$PIXEL_FORMAT_SOURCE"

# The default Ghostty install step also emits standalone libghostty-vt
# products. Sheep only consumes GhosttyKit, so skip that unrelated block.
perl -0pi -e \
  's#    // libghostty-vt\n#    if (config.emit_lib_vt) {\n    // libghostty-vt\n#; s#    // Helpgen\n#    }\n\n    // Helpgen\n#' \
  "$BUILD_SOURCE"

# Xcode 27's libtool discards Zig archive members that are not 8-byte aligned.
# On that toolchain, repack each archive before Ghostty aggregates it.
BUILD_PATH="$PATH"
XCODE_MAJOR_VERSION=$(xcodebuild -version \
  | awk 'NR == 1 { split($2, version, "."); print version[1] }')
if (( XCODE_MAJOR_VERSION >= 27 )); then
  BUILD_PATH="$REPOSITORY_ROOT/Scripts/toolchain:$BUILD_PATH"
fi

PATH="$BUILD_PATH" "$ZIG_BIN" build \
  -Demit-xcframework=true \
  -Demit-macos-app=false \
  -Dapp-runtime=none \
  -Dxcframework-target=universal \
  -Doptimize=ReleaseFast

print -r -- "$GHOSTTY_REVISION" > "$REVISION_PATH"
print "Built $FRAMEWORK_PATH"
