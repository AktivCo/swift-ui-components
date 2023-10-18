// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "rt-ui-components",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "rt-ui-components",
            targets: ["rt-ui-components"]),
    ],
    targets: [
        .target(
            name: "rt-ui-components"),
    ]
)
