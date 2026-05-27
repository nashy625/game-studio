// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "NashyGameStudio",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "GameStudioApp", targets: ["GameStudioApp"]),
        .executable(name: "BrickforgeBreakout", targets: ["BrickforgeBreakout"])
    ],
    targets: [
        .executableTarget(
            name: "GameStudioApp",
            linkerSettings: [
                .linkedFramework("AppKit"),
                .linkedFramework("SpriteKit"),
                .linkedFramework("GameplayKit")
            ]
        ),
        .executableTarget(
            name: "BrickforgeBreakout",
            linkerSettings: [
                .linkedFramework("AppKit"),
                .linkedFramework("SpriteKit")
            ]
        )
    ]
)
