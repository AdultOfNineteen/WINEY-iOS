import Foundation
import ProjectDescription
import ProjectDescriptionHelpers
//import MyPlugin

// MARK: - Project

// Local plugin loaded
//let localHelper = LocalHelper(name: "MyPlugin") //플러그인 미사용


let infoPlist: [String: InfoPlist.Value] = [
  "NSAppTransportSecurity": [
    "NSAllowsArbitraryLoads": true,
    "NSExceptionDomains": [
      "example.com": [
        "NSExceptionAllowsInsecureHTTPLoads": true,
        "NSIncludesSubdomains": true
      ]
    ]
  ],
  "CFBundleShortVersionString": "1.0",
  "CFBundleVersion": "1",
  "CFBundleDevelopmentRegion": "ko_KR",
  "UIUserInterfaceStyle": "Dark",
  "UILaunchStoryboardName":"LaunchScreen",
  "UIAppFonts": [
    "Item 0": "Pretendard-Medium.otf",
    "Item 1": "Pretendard-Bold.otf"
  ],
  "LSApplicationQueriesSchemes": [
    "kakaokompassauth",
    "kakaolink"
  ]
]

let appTargets: [Target] = [
  .init(name: "Winey",
        platform: .iOS,
        product: .app,
        bundleId: "com.adultOfNineteen.app",
        deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
        infoPlist: .extendingDefault(with: infoPlist),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
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
          .project(target: "WineyKit", path: "../WineyKit"),
          .project(target: "WineyNetwork", path: "../WineyNetwork"),
          .external(name: "ComposableArchitecture"),
          .external(name: "TCACoordinators"),
          .external(name: "CombineExt"),
          .external(name: "KakaoSDK")
        ])
]

let appproject = Project.init(name: "Winey",
                              organizationName: "com.adultOfNineteen",
                              targets: appTargets)
