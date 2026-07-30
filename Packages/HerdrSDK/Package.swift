// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "HerdrSDK",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(name: "HerdrSDK", type: .static, targets: ["HerdrSDK"]),
        .library(name: "HerdrSDKLocal", type: .static, targets: ["HerdrSDKLocal"]),
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
