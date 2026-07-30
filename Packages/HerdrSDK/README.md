# HerdrSDK

`HerdrSDK` is a native Swift client for the Herdr protocol. The package targets
macOS 13 or newer and contains no runtime dependencies.

```swift
import HerdrSDK
import HerdrSDKLocal

let client = HerdrClient.local()
let snapshot = try await client.sessions.snapshot()
try await client.workspaces.focus(snapshot.focusedWorkspaceID!)
```

The package has two products:

- `HerdrSDK` contains the protocol models, typed services, Unix-socket
  transport, events, and reconnecting session observation.
- `HerdrSDKLocal` discovers or starts a local Herdr server and produces direct
  terminal attachment commands.

Protocol model source is generated from Herdr's bundled JSON Schema. Run
`Tools/HerdrSDKGenerator/generate.mjs` from the Sheep repository root after updating
the pinned Herdr submodule.

The package uses Swift Testing. Handwritten production source in both products
is held to 100% line coverage; generated protocol models are verified separately
against the pinned schema:

```sh
Scripts/check-herdr-sdk-generation.sh
Scripts/check-herdr-sdk-coverage.sh
```

## License

Apache-2.0.
