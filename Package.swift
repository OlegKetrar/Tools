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
            targets: ["Tools"]),

        .library(
            name: "Reusable",
            targets: ["Reusable"]),

        .library(
            name: "ToolsFoundation",
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
