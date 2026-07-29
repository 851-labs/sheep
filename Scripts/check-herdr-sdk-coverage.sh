#!/bin/sh

set -eu

repository_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
package_dir="$repository_dir/Packages/HerdrSDK"

swift test --package-path "$package_dir" --enable-code-coverage

products_dir=$(swift build --package-path "$package_dir" --show-bin-path)
profile="$products_dir/codecov/default.profdata"
test_binary=$(find "$products_dir" \
    -path '*/HerdrSDKTests.xctest/Contents/MacOS/HerdrSDKTests' \
    -type f \
    -print \
    -quit)

if [ -z "$test_binary" ] || [ ! -f "$profile" ]; then
    echo "Unable to locate the HerdrSDK coverage artifacts." >&2
    exit 1
fi

set -- \
    "$package_dir"/Sources/HerdrSDK/*.swift \
    "$package_dir"/Sources/HerdrSDKLocal/*.swift

report=$(xcrun llvm-cov report \
    "$test_binary" \
    -instr-profile "$profile" \
    "$@")
printf '%s\n' "$report"

missed_lines=$(printf '%s\n' "$report" | awk '$1 == "TOTAL" { print $9 }')
if [ "$missed_lines" != "0" ]; then
    echo "HerdrSDK handwritten source coverage must remain at 100%." >&2
    exit 1
fi
