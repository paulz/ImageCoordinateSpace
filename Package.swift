// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImageCoordinateSpace",
    products: [
        .library(
            name: "ImageCoordinateSpace",
            targets: ["ImageCoordinateSpace"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from:"1.2.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "7.0.3")),
    ],
    targets: [
        .target(
            name: "ImageCoordinateSpace",
            path: "ImageCoordinateSpace"),
        .testTarget(
            name: "Unit Tests",
            dependencies: ["ImageCoordinateSpace", "Nimble", "Quick"],
            path: "Unit Tests"),
    ],
    swiftLanguageVersions: [4]
)
