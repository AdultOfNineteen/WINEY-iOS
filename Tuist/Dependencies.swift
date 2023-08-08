//
//  Dependencies.swift
//  Config
//
//  Created by 박혜운 on 2023/08/05.

import ProjectDescription

let spm = SwiftPackageManagerDependencies([
  .remote(url: "https://github.com/CombineCommunity/CombineExt.git", requirement: .exact("1.0.0")),
  .remote(url: "https://github.com/pointfreeco/swift-composable-architecture.git", requirement: .upToNextMajor(from: "0.35.0")),
  .remote(url: "https://github.com/johnpatrickmorgan/TCACoordinators.git", requirement: .upToNextMajor(from: "0.2.0")),
])

let dependencies = Dependencies(
    swiftPackageManager: spm,
    platforms: [.iOS]
)
