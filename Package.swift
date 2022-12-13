// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FindU",
    products: [
        .executable(name: "FindU", targets: ["FindU"]),
    ],
    dependencies: [
    ],
    targets: [
        .executableTarget(name: "FindU", dependencies: []),
        .testTarget(name: "FindUTests", dependencies: ["FindU"]),
    ]
)
