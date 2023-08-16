//
//  AuthCoordinatorCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct AuthCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<AuthScreenState>]
  
  public init(routes: [Route<AuthScreenState>] = [
    .root(
      .auth(.init()),
      embedInNavigationView: false
    )
  ]) {
    self.routes = routes
  }
}

public enum AuthCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<AuthScreenState>])
  case routeAction(Int, action: AuthScreenAction)
}

public struct AuthCoordinatorEnvironment {
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

public let authCoordinatorReducer: Reducer<
  AuthCoordinatorState,
  AuthCoordinatorAction,
  AuthCoordinatorEnvironment
> = authScreenReducer
  .forEachIndexedRoute(
    environment: {
      AuthScreenEnvironment(
        mainQueue: $0.mainQueue
      )
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      case .updateRoutes:
        return .none
        
      case .routeAction(_, action: .auth(.completeSocialNetworking)):
        state.routes = [
          .push(.setSignUp(.init()))
//          .root(
//            .setSignUp(.init()),
//            embedInNavigationView: true
//          )
        ]
        return .none
      case .routeAction(_, action: .setSignUp(.signUpCompleted)):
        return .none
      default: return .none
      }
    }
  )
