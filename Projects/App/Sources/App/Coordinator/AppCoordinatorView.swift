//
//  AppCoordinatorView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct AppCoordinatorView: View {
  let store: StoreOf<AppCoordinator>
  
  public init(store: StoreOf<AppCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .splash:
          CaseLet(
            /AppScreen.State.splash,
            action: AppScreen.Action.splash,
            then: SplashView.init
          )
          
        case .auth:
          CaseLet(
            /AppScreen.State.auth,
            action: AppScreen.Action.auth,
            then: AuthCoordinatorView.init
          )
          
        case .tabBar:
          CaseLet(
            /AppScreen.State.tabBar,
            action: AppScreen.Action.tabBar,
            then: TabBarView.init
          )
        }
      }
    }
  }
}
