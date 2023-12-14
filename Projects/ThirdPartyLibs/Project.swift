//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 박혜운 on 2023/12/07.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers
import EnvPlugin

let project = Project.make(
  name: "ThirdPartyLibs",
  targets: [
    .make(
      name: "ThirdPartyLibs",
      product: .framework,
      bundleId: "com.winey.thirdPartyLibs",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
      sources: ["Sources/**"],
      dependencies: [
        .external(name: "ComposableArchitecture"),
        .external(name: "TCACoordinators"),
        .external(name: "CombineExt"),
        .external(name: "KakaoSDK"),
      ],
      useSwiftLint: false
    )
  ]
)
