// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Tools",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(
            name: "Tools",
            type: .dynamic,
            targets: ["Tools"]),

        .library(
            name: "Reusable",
            type: .dynamic,
            targets: ["Reusable"]),

        .library(
            name: "ToolsFoundation",
            type: .dynamic,
            targets: ["ToolsFoundation"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Tools",
            dependencies: [
                .byName(name: "Reusable"),
                .byName(name: "ToolsFoundation"),
            ]),

        .target(name: "Reusable"),
        .target(name: "ToolsFoundation"),
    ],
    swiftLanguageVersions: [.v5]
)
