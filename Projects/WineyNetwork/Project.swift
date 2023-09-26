//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 박혜운 on 2023/09/12.
//

import Foundation
import ProjectDescription

let wineyNetworkTargets: [Target] = [
  .init(
    name: "WineyNetwork",
    platform: .iOS,
    product: .framework,
    bundleId: "com.adultOfNineteen.wineyNetwork",
    deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
    sources: ["Sources/**"],
    scripts: [
      .pre(
        script: """
              ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
              
              ${ROOT_DIR}/swiftlint --config ${ROOT_DIR}/.swiftlint.yml
              
              """,
        name: "SwiftLint",
        basedOnDependencyAnalysis: false
      )
    ],
    dependencies: [
      .project(target: "Utils", path: "../Utils")
    ]
  )
]

let wineyNetworkProject = Project.init(
  name: "WineyNetwork",
  organizationName: "com.adultOfNineteen",
  targets: wineyNetworkTargets
)
