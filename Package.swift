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
    ],
    targets: [
        .executableTarget(name: "FindU", dependencies: ["FindUKit", "CommandLineKit"]),
        .target(name: "FindUKit", dependencies: ["PathKit", "Rainbow"]),
        .testTarget(name: "FindUTests", dependencies: ["FindU"]),
    ]
)
