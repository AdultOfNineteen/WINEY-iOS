//
//  WINEYApp.swift
//  WINEY
//
//  Created by 박혜운 on 9/15/24.
//

import SwiftUI
import WineyKit
import ComposableArchitecture
import UserInfoPresentation
import UserInfoData
import KakaoSDKCommon

@main
struct WINEYApp: App {
  init() {
    AmplitudeProvider.initProvider(apiKey: getAmplitudeAPIKey())
    KakaoSDK.initSDK(appKey: getKakaoAPIKey())
    
    @Dependency(\.userDefaults) var userDefaultsService
    WineyFont.registerAll()
    userDefaultsService.saveFlag(.isPopGestureEnabled, true)
  }
  
  var body: some Scene {
    WindowGroup {
      AppRootView(
        store: .init(
          initialState: .init(),
          reducer: { AppRoot() }
        )
      )
    }
  }
}


func getFakeUserToken() -> String? {
  return Bundle.main.object(forInfoDictionaryKey: "FakeUserToken") as? String
}

func getFakeUserID() -> String? {
  return Bundle.main.object(forInfoDictionaryKey: "FakeUserID") as? String
}

func getBaseURL() -> String? {
  return Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String
}

func getAmplitudeAPIKey() -> String {
  return Bundle.main.object(forInfoDictionaryKey: "AmplitudeAPIKey") as! String
}

func getKakaoAPIKey() -> String {
  return Bundle.main.object(forInfoDictionaryKey: "KakaoAPIKey") as! String
}
