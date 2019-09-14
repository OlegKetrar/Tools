// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "ToolsUIKit",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(
            name: "ToolsUIKit",
            type: .dynamic,
            targets: ["ToolsUIKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/OlegKetrar/ToolsFoundation", .branch("master")),
    ],
    targets: [
        .target(
            name: "ToolsUIKit",
            dependencies: ["ToolsFoundation"],
            path: "Sources"),
    ],
    swiftLanguageVersions: [.v5]
)
