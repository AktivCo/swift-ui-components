// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "rt-ui-components",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "rt-ui-components",
            targets: ["rt-ui-components"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "rt-ui-components"),
        .testTarget(
            name: "rt-ui-componentsTests",
            dependencies: ["rt-ui-components"]),
    ]
)
