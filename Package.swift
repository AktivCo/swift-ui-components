// swift-tools-version: 5.9
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
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.56.1"),
    ],
    targets: [
        .target(
            name: "RtUiComponents",
            resources: [.process("Resources")],
            plugins: [
                 .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
             ]
        )
    ]
)
