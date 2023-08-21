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

public struct AppCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<AppScreenState>] // 첫 화면으로는 splash가 할당되어 있음
  
  public init(routes: [Route<AppScreenState>] = [
    .root(
      .splash(.init())
    )
  ]) {
    self.routes = routes
  }
}

public enum AppCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<AppScreenState>])
  case routeAction(Int, action: AppScreenAction)
}

public struct AppCoordinatorEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let userDefaultsService: UserDefaultsService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
  }
}

public let appCoordinatorReducer: Reducer<
  AppCoordinatorState,
  AppCoordinatorAction,
  AppCoordinatorEnvironment
> = appScreenReducer
  .forEachIndexedRoute(
    environment: {
      AppScreenEnvironment(
        mainQueue: $0.mainQueue,
        userDefaultsService: $0.userDefaultsService
      )
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
        
      case .updateRoutes(let newRoutes):
        state.routes = newRoutes
        return .none

      case .routeAction(_, action: .splash(._moveToHome)):
        state.routes = [
          .root(
            .tabBar(.init(main: .init())),
            embedInNavigationView: true
          )
        ]
        return .none
        
      case .routeAction(_, action: .splash(._moveToAuth)):
        state.routes = [
          .root(
            .auth(.init())
          )
        ]
        return .none
        
      case .routeAction(_, action: .auth(.routeAction(_, action: .setWelcomeSignUp(.tappedStartButton)))):
        state.routes = [
          .root(
            .tabBar(.init(main: .init())),
            embedInNavigationView: true
          )
        ]
        return .none
        
      default: return .none
      }
    }
    .debug("🍷AppCoordinator Reducer")
  )
