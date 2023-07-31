import ProjectDescription
import ProjectDescriptionHelpers


let utilsTargets: [Target] = [
    .init(name: "Utils",
          platform: .iOS,
          product: .framework,
          bundleId: "com.adultOfNineteen.utils",
          deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
          sources: ["Sources/**"],
          dependencies: [
          ]
         )
]

let utilsProject = Project.init(name: "Utils",
                           organizationName: "com.adultOfNineteen",
                           targets: utilsTargets)
