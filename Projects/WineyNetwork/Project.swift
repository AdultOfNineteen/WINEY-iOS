//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 박혜운 on 2023/09/12.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "WineyNetwork",
  targets: [
    .make(
      name: "WineyNetwork",
      product: .framework,
      bundleId: "com.winey.wineyNetwork",
      sources: ["Sources/**"],
      dependencies: [
        .project(target: "Utils", path: "../Utils")
      ]
    )
  ]
)
