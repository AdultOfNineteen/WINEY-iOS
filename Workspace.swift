import ProjectDescription
import ProjectDescriptionHelpers
import Foundation

let workspace = Workspace(
  name: "Winey",
  projects: [
    "Projects/**"
  ]
//  ,
//  schemes: [
//    Scheme(
//      name: "Prod-Winey",
//      buildAction: .buildAction(targets: [.project(path: "Projects/App", target: "Winey")]),
//      runAction: .runAction(configuration: .release),
//      archiveAction: .archiveAction(configuration: .release),
//      profileAction: .profileAction(configuration: .release),
//      analyzeAction: .analyzeAction(configuration: .release)
//    ),
//    Scheme(
//      name: "Dev-Winey",
//      buildAction: .buildAction(targets: [.project(path: "Projects/App", target: "Winey")]),
//      runAction: .runAction(configuration: .debug),
//      archiveAction: .archiveAction(configuration: .debug),
//      profileAction: .profileAction(configuration: .debug),
//      analyzeAction: .analyzeAction(configuration: .debug)
//    )
//  ]
//  ,
//  additionalFiles: [
//    "./xcconfigs/Winey.shared.xcconfig"
//  ]
)
