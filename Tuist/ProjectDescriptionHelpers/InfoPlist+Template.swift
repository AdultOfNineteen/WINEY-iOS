//
//  InfoPlist + Template.swift
//  ProjectDescriptionHelpers
//
//  Created by 박혜운 on 2023/11/15.
//

import ProjectDescription
import EnvPlugin

public extension InfoPlist {
  private static let basic: [String: Plist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "CFBundleDevelopmentRegion": "ko_KR",
    "UIUserInterfaceStyle": "Dark",
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
    "NSLocationWhenInUseUsageDescription" : [.string("앱이 위치 기반 기능을 제공하기 위해 사용자의 위치 정보가 필요합니다.")],
    "NSPhotoLibraryUsageDescription": .string("앱에서 사용자의 사진을 선택할 수 있도록 사진 갤러리에 접근 권한이 필요합니다."),
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
}
