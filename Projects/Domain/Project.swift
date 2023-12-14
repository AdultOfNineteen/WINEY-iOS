//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 박혜운 on 2023/12/12.
//

import EnvPlugin
import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Domain",
  targets: [
    .domain(
      implements: .User,
      factory: .init(
        dependencies: [
          .project(target: "WineyNetwork", path: "../WineyNetwork")
        ]
      )
    )
  ]
)
