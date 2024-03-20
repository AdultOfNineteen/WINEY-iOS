//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 박혜운 on 2023/07/31.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "WineyKit",
  targets: [
    .make(
      name: "WineyKit",
      product: .framework,
      bundleId: "com.winey.wineyKit",
      infoPlist: InfoPlist.basicWiney(),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
//        .project(target: "Utils", path: "../Utils")
      ]
    )
  ]
)
