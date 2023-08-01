import ProjectDescription
import ProjectDescriptionHelpers

let infoPlist: [String: InfoPlist.Value] = [
  "CFBundleShortVersionString": "1.0",
  "CFBundleVersion": "1",
  "CFBundleDevelopmentRegion": "ko_KR",
  "UIUserInterfaceStyle": "Dark",
  "UIAppFonts": [
    "Item 0": "Pretendard-Medium.otf",
    "Item 1": "Pretendard-Bold.otf"
  ]
]


let utilsTargets: [Target] = [
    .init(name: "Utils",
          platform: .iOS,
          product: .framework,
          bundleId: "com.adultOfNineteen.utils",
          deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
          infoPlist: .extendingDefault(with: infoPlist),
          sources: ["Sources/**"],
          resources: ["Resources/**"],
          dependencies: [
          ]
         )
]

let utilsProject = Project.init(name: "Utils",
                           organizationName: "com.adultOfNineteen",
                           targets: utilsTargets)
