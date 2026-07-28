# HerdrSDK

`HerdrSDK` is a native Swift client for the Herdr protocol. The package targets
macOS 14 or newer and contains no runtime dependencies.

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
`Scripts/generate-herdr-sdk.mjs` from the Sheep repository root after updating
the pinned Herdr submodule.

## License

Apache-2.0.
