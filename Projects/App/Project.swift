import ProjectDescription
import ProjectDescriptionHelpers
//import MyPlugin

// MARK: - Project

// Local plugin loaded
//let localHelper = LocalHelper(name: "MyPlugin") //플러그인 미사용


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

let appTargets: [Target] = [
    .init(name: "Winey",
          platform: .iOS,
          product: .app,
          bundleId: "com.adultOfNineteen.app",
          deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
          infoPlist: .extendingDefault(with: infoPlist),
          sources: ["Sources/**"],
          resources: ["Resources/**"],
          dependencies: [
            .project(target: "WineyKit", path: "../WineyKit"),
            .external(name: "ComposableArchitecture"),
            .external(name: "TCACoordinators"),
            .external(name: "CombineExt"),
          ])
]

let appproject = Project.init(name: "Winey",
                           organizationName: "com.adultOfNineteen",
                           targets: appTargets)
