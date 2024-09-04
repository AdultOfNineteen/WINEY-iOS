//
//  InfoPlist + Template.swift
//  ProjectDescriptionHelpers
//
//  Created by 박혜운 on 2023/11/15.
//

import ProjectDescription
import EnvPlugin
import Foundation

public extension InfoPlist {
  private static let basic: [String: Plist.Value] = [
    "CFBundleShortVersionString": "1.05",
    "CFBundleDevelopmentRegion": "ko_KR",
    "UIAppFonts": [
      "Item 0": "Pretendard-Medium.otf",
      "Item 1": "Pretendard-Bold.otf"
    ]
  ]
  
  private static let app: [String: Plist.Value] = [
    "NSAppTransportSecurity": [
      "NSAllowsArbitraryLoads": true,
      "NSExceptionDomains": [
        "example.com": [
          "NSExceptionAllowsInsecureHTTPLoads": true,
          "NSIncludesSubdomains": true
        ]
      ]
    ],
    "CFBundleVersion": .string(dynamicBuildNumber()),
    "UIUserInterfaceStyle": "Dark",
    "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
    "UISupportedInterfaceOrientations~ipad": ["UIInterfaceOrientationPortrait"],
    "UILaunchStoryboardName":"LaunchScreen",
    "LSApplicationQueriesSchemes": [
      "kakaokompassauth",
      "kakaolink"
    ],
    "CFBundleDisplayName": .string("WINEY"),
    "CFBundleName": .string("WINEY"),
    "ITSAppUsesNonExemptEncryption": false, // 수출 규정
    "NSLocationWhenInUseUsageDescription" : .string("사용자의 위치 기반으로 와인 상점 정보를 제공하기 위해 사용자의 위치 정보가 필요합니다."),
    "NSPhotoLibraryUsageDescription": .string("와인 후기를 남기기 위해 사용자의 사진을 선택할 수 있도록 사진 갤러리에 접근 권한이 필요합니다."),
    "NSCameraUsageDescription" : .string("와인 후기를 남기기 위한 용도의 촬영을 위해 앱에서 사용자의 카메라에 접근할 수 있도록 접근 권한이 필요합니다."),
    "GIDClientID":
        .string(APIKeys.GOOGLE_API_KEY),
    "com.apple.developer.applesignin": ["Default"],
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
    ],
    "NMFClientId": .string(APIKeys.NAVER_CLIENT_ID)
  ]
  
  static func basicWiney() -> Self {
    return .extendingDefault(with: Self.basic)
  }
  
  static func appWiney() -> Self {
    return .extendingBasicWiney(info: Self.app)
  }
  
  static func extendingBasicWiney(info PList: [String: Plist.Value]) -> Self {
    let infoPlist = Self.basic.merging(PList) { (_, new) in
      return new
    }
    
    return .extendingDefault(with: infoPlist)
  }
  
  static func dynamicBuildNumber() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    let dateStr = dateFormatter.string(from: date)
    return dateStr
  }
}
