// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserFeature",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UserInfoData",
            targets: ["UserInfoData"]
        ),
        .library(
            name: "UserInfoPresentation",
            targets: ["UserInfoPresentation"]
        )
    ],
    dependencies: [
      .package(path: "../WineyNetwork"),
      .package(path: "../WineyKit"),
      .package(path: "../ThirdPartyLibs")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
          name: "UserInfoData",
          dependencies: [
            .product(name: "WineyNetwork", package: "WineyNetwork"),
            .product(name: "ThirdPartyLibs", package: "ThirdPartyLibs")
          ]
        ),
        
          .target(
            name: "UserInfoPresentation",
            dependencies: [
              "UserInfoData",
              .product(name: "WineyNetwork", package: "WineyNetwork"),
              .product(name: "ThirdPartyLibs", package: "ThirdPartyLibs"),
              .product(name: "WineyKit", package: "WineyKit"),
            ]
          ),

        
        .testTarget(
            name: "UserFeatureTests",
            dependencies: ["UserInfoData"]),
    ]
)
