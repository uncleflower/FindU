// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FindU",
    products: [
        .executable(name: "FindU", targets: ["FindU"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IngmarStein/CommandLineKit", from: "2.3.0"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "3.1.1"),
        .package(url: "https://github.com/kylef/Spectre.git", from: "0.10.1"),
        .package(url: "https://github.com/apple/swift-syntax.git", exact: "0.50700.0"),
    ],
    targets: [
        .executableTarget(
            name: "FindU",
            dependencies: [
                "FindUKit",
                "CommandLineKit"
            ]),
        .target(
            name: "FindUKit",
            dependencies: [
                "PathKit",
                "Rainbow",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
            ]),
        .testTarget(
            name: "FindUKitTests",
            dependencies: [
                "FindUKit",
                "Spectre"
            ]),
    ],
    swiftLanguageVersions: [.v5]
)
