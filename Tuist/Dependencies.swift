//
//  Dependencies.swift
//  Config
//
//  Created by 박혜운 on 2023/08/05.

import ProjectDescription
import ConfigPlugin

let spm = SwiftPackageManagerDependencies(
  [
    .remote(
      url: "https://github.com/CombineCommunity/CombineExt.git",
      requirement: .exact("1.8.1")
    ),
    .remote(
      url: "https://github.com/pointfreeco/swift-composable-architecture.git",
      requirement: .range(from: "1.0", to: "2.0")
    ),
    .remote(
      url: "https://github.com/johnpatrickmorgan/TCACoordinators.git",
      requirement: .exact("0.6.0")
    ),
    .remote(
      url: "https://github.com/kakao/kakao-ios-sdk",
      requirement: .branch("master")
    ),
    .remote(url: "https://github.com/jaemyeong/NMapsMap.git", requirement: .upToNextMajor(from: "3.16.0"))
  ],
  baseSettings: .settings(
        configurations: [
          .debug(name: .debug),
          .release(name: .release)
        ]
        )
//  ,
//   baseSettings: .settings(configurations: XCConfig.module)
)

let dependencies = Dependencies(
    swiftPackageManager: spm,
    platforms: [.iOS]
)
