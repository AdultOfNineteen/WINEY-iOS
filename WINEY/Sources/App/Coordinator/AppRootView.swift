//
//  AppRootView.swift
//  WINEY
//
//  Created by 박혜운 on 9/17/24.
//

import ComposableArchitecture
import SwiftUI

struct AppRootView: View {
  let store: StoreOf<AppRoot>
  
  var body: some View {
    VStack(alignment: .center) {
      switch store.destination {
      case .splash:
        if let store = store.scope(state: \.destination?.splash, action: \.destination.splash) {
          SplashView(store: store)
        }
      case .auth:
        if let store = store.scope(state: \.destination?.auth, action: \.destination.auth) {
          AuthView(store: store)
        }
      case .tabBar:
        if let store = store.scope(state: \.destination?.tabBar, action: \.destination.tabBar) {
          TabBarView(store: store)
        }
      case .none:
        if let store = store.scope(state: \.destination?.splash, action: \.destination.splash) {
          SplashView(store: store)
        }
      }
    }
    .task {
      for await _ in NotificationCenter.default.notifications(named: .userDidLogin) {
        // TODO: - 토큰 만료 잘 동작하는 지 확인하기
        print("토큰 만료 포착")
        store.send(._moveToAuth)
      }
    }     
    .onOpenURL { url in
      store.send(.handleDeepLink(url))
    }
  }
}
