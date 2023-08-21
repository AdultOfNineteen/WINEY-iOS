//
//  AppScreenCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public enum AppScreenState: Equatable {
  case splash(SplashState)
  case auth(AuthCoordinatorState)
  case tabBar(TabBarState)
}

public enum AppScreenAction {
  case splash(SplashAction)
  case auth(AuthCoordinatorAction)
  case tabBar(TabBarAction)
}

internal struct AppScreenEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let userDefaultsService: UserDefaultsService
  
  internal init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
  }
}

internal let appScreenReducer =
Reducer<
  AppScreenState,
  AppScreenAction,
  AppScreenEnvironment>
  .combine([
  splashReducer
    .pullback(
      state: /AppScreenState.splash,
      action: /AppScreenAction.splash,
      environment: {
        SplashEnvironment(
          userDefaultsService: $0.userDefaultsService
        )
      }
    ),
  
  authCoordinatorReducer
    .pullback(
      state: /AppScreenState.auth,
      action: /AppScreenAction.auth,
      environment: {
        AuthCoordinatorEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: $0.userDefaultsService
        )
      }
    )
    .debug("🍷🍷🍷🍷🍷authCoordinatorReducer Reducer")
  ,
  
  tabBarReducer
    .pullback(
      state: /AppScreenState.tabBar,
      action: /AppScreenAction.tabBar,
      environment: {
        TabBarEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: $0.userDefaultsService
        )
      }
    )
  ])
