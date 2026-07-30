#!/bin/zsh

set -euo pipefail

REPOSITORY_ROOT=${0:A:h:h}
DERIVED_DATA_PATH=${SHEEP_UNIVERSAL_DERIVED_DATA_PATH:-"$REPOSITORY_ROOT/DerivedData-Universal"}
APP_PATH="$DERIVED_DATA_PATH/Build/Products/Release/sheep.app"
APP_BINARY="$APP_PATH/Contents/MacOS/sheep"

cd "$REPOSITORY_ROOT"

Scripts/bootstrap-ghostty.sh
xcodegen generate

xcodebuild \
  -project Sheep.xcodeproj \
  -scheme Sheep \
  -configuration Release \
  -destination 'generic/platform=macOS' \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  ARCHS='arm64 x86_64' \
  ONLY_ACTIVE_ARCH=NO \
  CODE_SIGNING_ALLOWED=NO \
  build

if ! lipo "$APP_BINARY" -verify_arch arm64 \
  || ! lipo "$APP_BINARY" -verify_arch x86_64; then
  print -u2 "Expected a universal sheep binary at $APP_BINARY."
  exit 1
fi

minimum_versions=("${(@f)$(xcrun vtool -show-build "$APP_BINARY" \
  | awk '$1 == "minos" { print $2 }')}")
if (( ${#minimum_versions} != 2 )) \
  || [[ "${minimum_versions[1]}" != "13.0" ]] \
  || [[ "${minimum_versions[2]}" != "13.0" ]]; then
  print -u2 "Expected both sheep slices to target macOS 13.0."
  exit 1
fi

if [[ "$(/usr/libexec/PlistBuddy \
  -c 'Print :LSMinimumSystemVersion' \
  "$APP_PATH/Contents/Info.plist")" != "13.0" ]]; then
  print -u2 "Expected sheep.app to require macOS 13.0."
  exit 1
fi

print "Built universal sheep app:"
print "  $APP_PATH"
print "Architectures:"
lipo -archs "$APP_BINARY"
