// swift-tools-version:5.1
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
            name: "ToolsFoundation",
            type: .static,
            targets: ["ToolsFoundation"]),

        .library(
            name: "Reusable",
            type: .static,
            targets: ["Reusable"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Tools",
            dependencies: ["ToolsFoundation", "Reusable"]),

        .target(name: "ToolsFoundation"),
        .target(name: "Reusable"),
    ],
    swiftLanguageVersions: [.v5]
)
