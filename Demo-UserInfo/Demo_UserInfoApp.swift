//
//  Demo_UserInfoApp.swift
//  Demo-UserInfo
//
//  Created by 박혜운 on 9/17/24.
//

import SwiftUI
import ComposableArchitecture
import UserInfoPresentation
import WineyKit

@main
struct Demo_UserInfoApp: App {
  @Bindable var store: StoreOf<UserInfoAppReducer>
  
  init() {
    @Dependency(\.userDefaults) var userDefaultsService
    WineyFont.registerAll()
    store = .init(initialState: .init(), reducer: { UserInfoAppReducer() })
    guard let token = getFakeUserToken() else { print("Fake User Token 실패"); return }
    guard let userID = getFakeUserID() else { print("Fake User ID: 실패"); return }
    
    userDefaultsService.saveValue(.accessToken, token)
    userDefaultsService.saveValue(.userID, userID)
    userDefaultsService.saveFlag(.isPopGestureEnabled, true)
  }
  
  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
        UserInfoView(store: store.scope(state: \.userInfo, action: \.userInfo))
      } destination: { store in
        switch store.state {
        case .userSetting:
          if let store = store.scope(state: \.userSetting, action: \.userSetting) {
            UserSettingView(store: store)
          }
        case .changeNickname:
          if let store = store.scope(state: \.changeNickname, action: \.changeNickname) {
            ChangeNicknameView(store: store)
          }
        case .signOut:
          if let store = store.scope(state: \.signOut, action: \.signOut) {
            SignOutView(store: store)
          }
          
        case .signOutConfirm:
          if let store = store.scope(state: \.signOutConfirm, action: \.signOutConfirm) {
            SignOutConfirmView(store: store)
          }
        }
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
