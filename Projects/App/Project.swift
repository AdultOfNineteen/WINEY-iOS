import Foundation
import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

// MARK: - Project

// Local plugin loaded
//let localHelper = LocalHelper(name: "MyPlugin") //플러그인 미사용


let infoPlist: [String: Plist.Value] = [
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
  ],
  "GIDClientID":
      .string(APIKeys.GOOGLE_API_KEY)
  ,
  "com.apple.developer.applesignin": [
    "Default"
  ],
  "CFBundleURLTypes": [
    [
      "CFBundleTypeRole": "Editor",
      "CFBundleURLSchemes": [
        .string(APIKeys.KAKAO_URL_KEY)
      ]
    ],
    [
      "CFBundleTypeRole": "Editor",
      "CFBundleURLSchemes": [
        .string(APIKeys.GOOGLE_URL_KEY)
      ]
    ]
  ]
]

let appTargets: [Target] = [
  .init(name: "Winey",
        platform: .iOS,
        product: .app,
        bundleId: "com.winey.app",
        deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
        infoPlist: .extendingDefault(with: infoPlist),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        entitlements: "../../Tuist/Winey.entitlements",
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
          .external(name: "KakaoSDK"),
          .package(product: "GoogleSignIn") 
        ]
        )
]

let appproject = Project.init(name: "Winey",
                              organizationName: "com.winey",
                              packages: [
                                .remote(
                                  url: "https://github.com/google/GoogleSignIn-iOS",
                                  requirement: .branch("main")
                                )
                              ],
                              targets: appTargets)
