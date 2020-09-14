// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FlickTypeKit",
    platforms: [
        .watchOS(.v4),
    ],
    products: [
        .library(
            name: "FlickTypeKit",
            targets: ["FlickTypeKit"]
        )
    ],
    targets: [
        .target(
            name: "FlickTypeKit"
        )
    ]
)
