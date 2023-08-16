import Foundation
import ProjectDescription
import ProjectDescriptionHelpers


let utilsTargets: [Target] = [
    .init(name: "Utils",
          platform: .iOS,
          product: .framework,
          bundleId: "com.adultOfNineteen.utils",
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
          ]
         )
]

let utilsProject = Project.init(name: "Utils",
                           organizationName: "com.adultOfNineteen",
                           targets: utilsTargets)
