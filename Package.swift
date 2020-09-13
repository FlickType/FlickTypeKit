// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FlickTypeKit",
    platforms: [
        .watchOS(.v4),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FlickTypeKit",
            targets: ["FlickTypeKit"])
    ],
    targets: [
        .binaryTarget(
            name: "FlickTypeKit",
            path: "FlickTypeKit/FlickTypeKit.xcframework"
        )
    ]
)
