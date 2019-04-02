// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "CodableStoreKit",
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
