// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MetadataVideoFFmpeg",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13),
        .iOS(.v12),
        .watchOS(.v4),
        .tvOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MetadataVideoFFmpeg",
            targets: ["MetadataVideoFFmpeg"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MetadataVideoFFmpeg",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "MetadataVideoFFmpegTests",
            dependencies: ["MetadataVideoFFmpeg"],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
