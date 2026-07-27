#!/bin/zsh

set -euo pipefail

REPOSITORY_ROOT=${0:A:h:h}
GHOSTTY_ROOT="$REPOSITORY_ROOT/Dependencies/ghostty"
FRAMEWORK_PATH="$GHOSTTY_ROOT/macos/GhosttyKit.xcframework"
ZIG_BIN=${SHEEP_ZIG_BIN:-$(command -v zig || true)}

if [[ ! -f "$GHOSTTY_ROOT/build.zig" ]]; then
  print -u2 "Ghostty is not initialized. Run: git submodule update --init --recursive"
  exit 1
fi

if [[ -z "$ZIG_BIN" ]]; then
  print -u2 "Zig 0.15.2 is required but was not found."
  exit 1
fi

ZIG_VERSION=$("$ZIG_BIN" version)
if [[ "$ZIG_VERSION" != "0.15.2" ]]; then
  print -u2 "Zig 0.15.2 is required; found $ZIG_VERSION at $ZIG_BIN."
  exit 1
fi

if [[ -f "$FRAMEWORK_PATH/Info.plist" ]] \
  && /usr/libexec/PlistBuddy -c "Print :AvailableLibraries" "$FRAMEWORK_PATH/Info.plist" \
    | grep -q "arm64" \
  && /usr/libexec/PlistBuddy -c "Print :AvailableLibraries" "$FRAMEWORK_PATH/Info.plist" \
    | grep -q "x86_64"; then
  print "GhosttyKit.xcframework is already universal."
  exit 0
fi

cd "$GHOSTTY_ROOT"
PIXEL_FORMAT_SOURCE="$GHOSTTY_ROOT/pkg/macos/video/pixel_format.zig"
PATCH_BACKUP_DIRECTORY=$(mktemp -d)
PATCH_BACKUP_SOURCE="$PATCH_BACKUP_DIRECTORY/pixel_format.zig"

cp "$PIXEL_FORMAT_SOURCE" "$PATCH_BACKUP_SOURCE"
restore_ghostty_source() {
  cp "$PATCH_BACKUP_SOURCE" "$PIXEL_FORMAT_SOURCE"
  rm "$PATCH_BACKUP_SOURCE"
  rmdir "$PATCH_BACKUP_DIRECTORY"
}
trap restore_ghostty_source EXIT

# Ghostty 1.3.1 names this CoreVideo FourCC through an SDK symbol that was
# introduced after the macOS 14 runner SDK. The value itself is stable and
# public (`r210`), so compile the pin against older SDKs using that value.
perl -0pi -e \
  's/@"30RGB_r210" = c\.kCVPixelFormatType_30RGB_r210,/@"30RGB_r210" = 0x72323130,/' \
  "$PIXEL_FORMAT_SOURCE"

"$ZIG_BIN" build \
  -Demit-xcframework=true \
  -Demit-macos-app=false \
  -Dapp-runtime=none \
  -Dxcframework-target=universal \
  -Doptimize=ReleaseFast

print "Built $FRAMEWORK_PATH"
