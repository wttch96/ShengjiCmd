// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShengjiCmd",
    products: [
        // 命令行 SwiftUI 引擎
        .library(name: "TerminalUI", targets: ["TerminalUI"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // TerminalUI 是一个独立的库，提供命令行界面组件和渲染功能
        .target(
            name: "TerminalUI", 
            dependencies: []
        ),

        .executableTarget(
            name: "ShengjiCmd",
            dependencies: ["TerminalUI"]
        ),
        .testTarget(
            name: "ShengjiCmdTests",
            dependencies: ["ShengjiCmd"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
