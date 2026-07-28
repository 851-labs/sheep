// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "HerdrSDK",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .library(name: "HerdrSDK", type: .dynamic, targets: ["HerdrSDK"]),
        .library(name: "HerdrSDKLocal", type: .dynamic, targets: ["HerdrSDKLocal"]),
    ],
    targets: [
        .target(name: "HerdrSDK"),
        .target(
            name: "HerdrSDKLocal",
            dependencies: ["HerdrSDK"]
        ),
        .testTarget(
            name: "HerdrSDKTests",
            dependencies: ["HerdrSDK", "HerdrSDKLocal"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
