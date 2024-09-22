// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ThirdPartyLibs",
  platforms: [
    .iOS(.v17)
  ],
  products: [
    .library(
      name: "ThirdPartyLibs",
      targets: ["ThirdPartyLibs"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.7.0"),
    .package(url: "https://github.com/amplitude/Amplitude-Swift.git", exact: "1.7.0"),
    .package(url: "https://github.com/kakao/kakao-ios-sdk", branch: "master"),
    .package(url: "https://github.com/jaemyeong/NMapsMap.git", .upToNextMajor(from: "3.16.0")),
    
    .package(url: "https://github.com/google/GoogleSignIn-iOS", branch: "main")
  ],
  targets: [
    .target(
      name: "ThirdPartyLibs",
      dependencies: [
        // Link dependencies to this target
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "AmplitudeSwift", package: "Amplitude-Swift"),
        .product(name: "KakaoSDK", package: "kakao-ios-sdk"),
        .product(name: "NMapsMap", package: "NMapsMap"),
        
        .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS")

      ]
    ),
    .testTarget(
      name: "ThirdPartyLibsTests",
      dependencies: ["ThirdPartyLibs"]),
  ]
)
