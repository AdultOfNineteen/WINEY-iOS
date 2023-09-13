//
//  AppCoordinator.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct AppCoordinator: Reducer {
  
  init() {
    print("AppCoordinator 생성됌")
  }
  
  public struct State: Equatable, IndexedRouterState {
    static let initialState = State(
      routes: [.root(.splash(.init()))]
    )
    
    public var routes: [Route<AppScreen.State>]
  }
  
  public enum Action: IndexedRouterAction {
    case routeAction(Int, action: AppScreen.Action)
    case updateRoutes([Route<AppScreen.State>])
  }

  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .routeAction(_, action: .splash(._moveToHome)):
        state.routes = [
          .root(
            .tabBar(
              .init(
                main: .init(),
                map: .init(),
                note: .init(),
                userInfo: .init(),
                isTabHidden: false
              )
            ),
            embedInNavigationView: true
          )
        ]
      return .none
        
      case .routeAction(_, action: .splash(._moveToAuth)):
        state.routes = [
          .root(
            .auth(.initialState)
          )
        ]
        return .none
        
      case .routeAction(_, action: .auth(.routeAction(_, action: .setWelcomeSignUp(.tappedStartButton)))):
        state.routes = [
          .root(
            .tabBar(
              .init(
                main: .init(),
                map: .init(),
                note: .init(),
                userInfo: .init(),
                isTabHidden: false
              )
            ),
            embedInNavigationView: true
          )
        ]
        return .none
        
      default: return .none

      }
    }
    .forEachRoute {
      AppScreen()
    }
  }
}
