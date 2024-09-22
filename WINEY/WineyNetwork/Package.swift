// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WineyNetwork",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "WineyNetwork",
            targets: ["WineyNetwork"]),
    ],
    dependencies: [
//      .package(path: "../ThirdPartyLibs")
    ],
    targets: [
        .target(
            name: "WineyNetwork",
            swiftSettings: [
                // 플래그 정의
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release))
            ]
        ),
        .testTarget(
            name: "WineyNetworkTests",
            dependencies: ["WineyNetwork"]),
    ]
)
