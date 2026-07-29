#!/bin/sh

set -eu

repository_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repository_dir"

npm ci --prefix Tools/HerdrSDKGenerator
node Tools/HerdrSDKGenerator/generate.mjs
git diff --exit-code -- Packages/HerdrSDK/Sources/HerdrSDK/Generated
