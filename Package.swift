// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "rt-ui-components",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "RtUiComponents",
            targets: ["RtUiComponents"])
    ],
    targets: [
        .target(
            name: "RtUiComponents",
            resources: [.process("Resources")]
        )
    ]
)
