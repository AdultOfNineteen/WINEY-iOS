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
import FirebaseCore
import KakaoSDKCommon

@main
struct WINEYApp: App {
  init() {
    AmplitudeProvider.initProvider(apiKey: Config.getPropertyValue(.amplitudeKey))
    KakaoSDK.initSDK(appKey: Config.getPropertyValue(.kakaoAPIKey))
    FirebaseApp.configure()
    
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
