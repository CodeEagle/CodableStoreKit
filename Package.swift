// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "CodableStoreKit",
    platforms: [
        .iOS(.v8),
        .tvOS(.v9),
        .watchOS(.v2),
        .macOS(.v10_10)
    ],
    products: [
        .library(
            name: "CodableStoreKit",
            targets: ["CodableStoreKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CodableStoreKit",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "CodableStoreKitTests",
            dependencies: ["CodableStoreKit"],
            path: "Tests"
        ),
    ]
)
