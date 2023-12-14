//
//  File.swift
//  ProjectDescriptionHelpers
//
//  Created by 박혜운 on 2023/11/14.
//
import EnvPlugin
import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "MyPageFeature",
  targets: [
    .feature(interface: .MyPage, factory: .init()),
    
    .feature(
      implements: .MyPage,
      factory: .init(
        dependencies: [
          .project(target: "UserDomain", path: "../../Domain"),
          .project(target: "WineyKit", path: "../../WineyKit"),
        ]
      )
    ),
    
    .feature(
      demo: .MyPage,
      factory: .init(
        dependencies: [
          .project(target: "MyPageFeatureInterface", path: "../../Feature/MyPageFeature"),
          .project(target: "MyPageFeature", path: "../../Feature/MyPageFeature")
        ] 
      )
    )
  ]
)
