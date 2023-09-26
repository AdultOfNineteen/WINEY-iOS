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


public struct AppScreen: Reducer {
  public enum State: Equatable {
    case splash(Splash.State)
    case auth(AuthCoordinator.State)
    case tabBar(TabBar.State)
    case analysis(WineAnalysisCoordinator.State)
  }

  public enum Action {
    case splash(Splash.Action)
    case auth(AuthCoordinator.Action)
    case tabBar(TabBar.Action)
    case analysis(WineAnalysisCoordinator.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.splash, action: /Action.splash) {
      Splash()
    }
    Scope(state: /State.auth, action: /Action.auth) {
      AuthCoordinator()
    }
    Scope(state: /State.tabBar, action: /Action.tabBar) {
      TabBar()
    }
    Scope(state: /State.analysis, action: /Action.analysis) {
      WineAnalysisCoordinator()
    }
  }
}
