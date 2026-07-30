#!/bin/zsh

set -euo pipefail

REPOSITORY_ROOT=${0:A:h:h}
GHOSTTY_ROOT="$REPOSITORY_ROOT/.repos/ghostty"
FRAMEWORK_PATH="$GHOSTTY_ROOT/macos/GhosttyKit.xcframework"
MACOS_LIBRARY="$FRAMEWORK_PATH/macos-arm64_x86_64/libghostty.a"
ZIG_BIN=${SHEEP_ZIG_BIN:-}

if [[ -z "$ZIG_BIN" ]]; then
  for candidate in \
    /opt/homebrew/opt/zig@0.15/bin/zig \
    /usr/local/opt/zig@0.15/bin/zig \
    "$(command -v zig || true)"; do
    if [[ -x "$candidate" && "$("$candidate" version)" == "0.15.2" ]]; then
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
  print -u2 "Zig 0.15.2 is required but was not found."
  exit 1
fi

ZIG_VERSION=$("$ZIG_BIN" version)
if [[ "$ZIG_VERSION" != "0.15.2" ]]; then
  print -u2 "Zig 0.15.2 is required; found $ZIG_VERSION at $ZIG_BIN."
  exit 1
fi

if [[ -f "$MACOS_LIBRARY" ]] \
  && lipo "$MACOS_LIBRARY" -verify_arch arm64 \
  && lipo "$MACOS_LIBRARY" -verify_arch x86_64 \
  && nm -gU "$MACOS_LIBRARY" 2>/dev/null \
    | awk '$3 == "_ghostty_init" { found = 1 } END { exit !found }'; then
  print "GhosttyKit.xcframework is already universal."
  exit 0
fi

cd "$GHOSTTY_ROOT"
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

# Ghostty 1.3.1 names this CoreVideo FourCC through an SDK symbol that was
# introduced after the macOS 14 runner SDK. The value itself is stable and
# public (`r210`), so compile the pin against older SDKs using that value.
perl -0pi -e \
  's/@"30RGB_r210" = c\.kCVPixelFormatType_30RGB_r210,/@"30RGB_r210" = 0x72323130,/' \
  "$PIXEL_FORMAT_SOURCE"

# The default Ghostty install step also emits the standalone libghostty-vt
# dylib. Sheep only consumes GhosttyKit, and that unrelated target currently
# fails when Zig 0.15.2's libc++ is compiled against the Xcode 27 beta SDK.
perl -0pi -e \
  's#libghostty_vt_shared\.install\(b\.getInstallStep\(\)\);#// Sheep builds only GhosttyKit.#' \
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

print "Built $FRAMEWORK_PATH"
