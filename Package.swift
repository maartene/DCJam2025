// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DCJam2025",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(name: "raylib", targets: ["raylib"]),
        .executable(name: "DCJam2025", targets: ["DCJam2025"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/suzannaratcliff/swift-testing.git",
            branch: "suzannaratcliff/enable-severity")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "DCJam2025",
            dependencies: ["raylib", "Model"],
            resources: [
                .process("Resources")
            ],
            cSettings: [
                .define("RAYGUI_IMPLEMENTATION")
            ],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-validate-tbd-against-ir=none"])
            ]
        ),
        .target(
            name: "Model"
        ),
        .testTarget(
            name: "DCJam2025Tests",
            dependencies: [
                "DCJam2025", "Model",
            ]),
        .systemLibrary(
            name: "raylib", pkgConfig: "raylib",
            providers: [
                .brew(["raylib"]),
                .apt(["raylib-dev"]),
            ]
        ),
    ]
)
