//
//  Dependencies.swift
//  Config
//
//  Created by 박혜운 on 2023/08/05.

import ProjectDescription

let spm = SwiftPackageManagerDependencies([
  .remote(
    url: "https://github.com/CombineCommunity/CombineExt.git", requirement: .exact("1.8.1")
  ),
  .remote(url: "https://github.com/pointfreeco/swift-composable-architecture.git", requirement: .exact("0.40.2")),
  .remote(url: "https://github.com/johnpatrickmorgan/TCACoordinators.git", requirement: .exact("0.2.0")),
])

let dependencies = Dependencies(
    swiftPackageManager: spm,
    platforms: [.iOS]
)
