//
//  Demo_UserInfoApp.swift
//  Demo-UserInfo
//
//  Created by 박혜운 on 9/17/24.
//

import SwiftUI
import UserInfoPresentation
import WineyKit
import ComposableArchitecture

@main
struct Demo_UserInfoApp: App {
  init() {
    @Dependency(\.userDefaults) var userDefaultsService
    WineyFont.registerAll()
    guard let token = getFakeUserToken() else { print("Fake User Token 실패"); return }
    guard let userID = getFakeUserID() else { print("Fake User ID: 실패"); return }

    userDefaultsService.saveValue(.accessToken, token)
    userDefaultsService.saveValue(.userID, userID)
    userDefaultsService.saveFlag(.isPopGestureEnabled, true)
  }
  
  var body: some Scene {
    WindowGroup {
      VStack {
        UserInfoView(
          store: .init(
            initialState: .init(),
            reducer: {
              UserInfo()
            }
          )
        )
      }
    }
  }
  
  func getFakeUserToken() -> String? {
    return Bundle.main.object(forInfoDictionaryKey: "FakeUserToken") as? String
  }
  
  func getFakeUserID() -> String? {
    if let userIDString = Bundle.main.object(forInfoDictionaryKey: "FakeUserID") as? String {
      return userIDString
    }
    return nil
  }
}
