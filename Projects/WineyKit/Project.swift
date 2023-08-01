//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 박혜운 on 2023/07/31.
//

import ProjectDescription
import ProjectDescriptionHelpers

let wineyKitTargets: [Target] = [
    .init(name: "WineyKit",
          platform: .iOS,
          product: .framework,
          bundleId: "com.adultOfNineteen.wineyKit",
          deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
          sources: ["Sources/**"],
          dependencies: [
            .project(target: "Utils", path: "../Utils")
          ]
         )
]

let wineyKitProject = Project.init(name: "WineyKit",
                           organizationName: "com.adultOfNineteen",
                           targets: wineyKitTargets)
