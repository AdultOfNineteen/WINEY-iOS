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
  private let store: Store<AppCoordinatorState, AppCoordinatorAction>
  
  public init(store: Store<AppCoordinatorState, AppCoordinatorAction>) {
    self.store = store
  }

  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) {
        CaseLet(
          state: /AppScreenState.splash,
          action: AppScreenAction.splash,
          then: SplashView.init
        )
        CaseLet(
          state: /AppScreenState.auth,
          action: AppScreenAction.auth,
          then: AuthCoordinatorView.init
        )
        CaseLet(
          state: /AppScreenState.tabBar,
          action: AppScreenAction.tabBar,
          then: TabBarView.init
        )
      }
    }
  }
}
