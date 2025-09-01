// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var dependencies: [Package.Dependency] = []
var targetPlugins: [Target.PluginUsage] = []

#if os(macOS) || os(iOS)
    dependencies.append(
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.58.2"))
    targetPlugins.append(
        .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"))
#endif

let package = Package(
    name: "DCJam2025",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(name: "raylib", targets: ["raylib"]),
        .library(name: "raygui", targets: ["raygui"]),
        .executable(name: "DCJam2025", targets: ["DCJam2025"]),
    ],
    dependencies: dependencies,
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "DCJam2025",
            dependencies: ["raylib", "Model", "raygui"],
            resources: [
                .process("Resources")
            ],
            cSettings: [
                .define("RLIGHTS_IMPLEMENTATION")
            ],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-validate-tbd-against-ir=none"])
            ],
            // plugins: targetPlugins
        ),
        .target(
            name: "Model"
        ),
        .target(
            name: "raygui"
        ),
        .testTarget(
            name: "DCJam2025Tests",
            dependencies: [
                "DCJam2025", "Model",
            ],
            // plugins: targetPlugins
        ),
        .systemLibrary(
            name: "raylib", pkgConfig: "raylib",
            providers: [
                .brew(["raylib"]),
                .apt(["raylib-dev"]),
            ]
        ),
    ]
)
