// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "CodableStoreKit",
    platforms: [.macOS(.v10_15),
                .iOS(.v10),
                .tvOS(.v10),
                .watchOS(.v3)],
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
            dependencies: []
        ),
        .testTarget(
            name: "CodableStoreKitTests",
            dependencies: ["CodableStoreKit"]
        ),
    ]
)
