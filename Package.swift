// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SUIRouter",
    platforms: [.iOS(.v15), .macOS(.v11), .watchOS(.v6), .tvOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SUIRouter",
            targets: ["SUIRouter"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SUIRouter"),
        .testTarget(
            name: "SUIRouterTests",
            dependencies: ["SUIRouter"]
        ),
    ]
)
