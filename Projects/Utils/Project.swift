import Foundation
import ProjectDescription
import ProjectDescriptionHelpers


let project = Project.make(
  name: "Utils",
  targets: [
    .make(
      name: "Utils",
      product: .framework,
      bundleId: "com.winey.utils",
      sources: ["Sources/**"],
      dependencies: [
        .project(target: "ThirdPartyLibs", path: "../ThirdPartyLibs")
      ]
    )
  ]
)
