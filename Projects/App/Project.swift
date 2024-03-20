import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project

// let settings: ProjectDescription.Settings = .settings(
//  configurations: [
//    .debug(name: .debug, xcconfig: "./xcconfigs/Winey.debug.xcconfig"),
//    .release(name: .release, xcconfig: "./xcconfigs/Winey.release.xcconfig")
//  ]
//)

let project = Project.make(
  name: "App",
  targets: [
    .make(
      name: "Winey",
      product: .app,
      bundleId: "com.winey.app",
      infoPlist: InfoPlist.appWiney(),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: "WineyNetwork", path: "../WineyNetwork"),
        .project(target: "WineyKit", path: "../WineyKit"),
//        .project(target: "MyPageFeatureInterface", path: "../Feature/MyPageFeature"),
//        .project(target: "MyPageFeature", path: "../Feature/MyPageFeature"),
//        .project(target: "MapFeature", path: "../Feature/MapFeature"),
        
        .package(product: "GoogleSignIn")
      ]
//      ,
//      settings: settings
    )
  ],
  packages: [
    .remote(
      url: "https://github.com/google/GoogleSignIn-iOS",
      requirement: .branch("main")
    )
  ]
//  ,
//  additionalFiles: [
//    "./xcconfigs/Winey.shared.xcconfig"
//  ]
)
