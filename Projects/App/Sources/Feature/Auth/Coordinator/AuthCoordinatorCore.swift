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
      .login(.init()),
      embedInNavigationView: true
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
        
      case .routeAction(_, action: .login(._completeSocialNetworking)):
        state.routes.append(.push(.setPhoneSignUp(.init())))
        return .none

      case .routeAction(_, action: .setPhoneSignUp(.tappedBackButton)):
        state.routes.pop()
        return .none

      case .routeAction(_, action: .setPhoneSignUp(._moveCodeSignUpView)):
        state.routes.append( .push( .setCodeSignUP(.init())))
        return .none
        
      case .routeAction(_, action: .setCodeSignUp(._backToFirstView)):
        if let firstView = state.routes.first {
          state.routes = [
            firstView
          ]
        }
        return .none
        
      case .routeAction(_, action: .setCodeSignUp(.tappedBottomAlreadySignUpButton)):
        if let firstView = state.routes.first {
          state.routes = [
            firstView
          ]
        }
        return .none
        
      case .routeAction(_, action: .setCodeSignUp(._moveFlavorSignUpView)):
        state.routes.append( .push( .setFlavorSignUp(.init())))
        return .none
        
      case .routeAction(_, action: .setFlavorSignUp(._backToFirstView)):
        if let firstView = state.routes.first {
          state.routes = [
            firstView
          ]
        }
        return .none
      
      case .routeAction(_, action: .setFlavorSignUp(._moveWelcomeSignUpView)):
        state.routes.append( .push( .setWelcomeSignUp(.init())))
        return .none
        
      default:
        return .none
      }
    }
    .debug("AuthCoordinatorCore")
  )
