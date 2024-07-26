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

public struct AuthCoordinator: Reducer {
  public struct State: Equatable, IndexedRouterState {
    static let initialState = State(
      routes: [
        .root(
          .login(.init()),
          embedInNavigationView: true
        )
      ]
    )
    
    public var routes: [Route<AuthScreen.State>]
  }
  
  public enum Action: IndexedRouterAction {
    case routeAction(Int, action: AuthScreen.Action)
    case updateRoutes([Route<AuthScreen.State>])
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .routeAction(_, action: .login(._moveUserStatusPage(page))):
        switch page {
        case .done:
          return .none
        case .code:
          state.routes.append(.push(.setPhoneSignUp(.init())))
        case .flavor:
          state.routes.append(.push(.setFlavorSignUp(.init())))
        }
        return .none

      case .routeAction(_, action: .setPhoneSignUp(.tappedBackButton)):
        state.routes.pop()
        return .none

      case .routeAction(_, action: .setPhoneSignUp(._moveCodeSignUpView(let phone))):
        state.routes.append( .push( .setCodeSignUP(.init(phoneNumber: phone))))
        return .none
        
      case .routeAction(_, action: .setCodeSignUp(._backToFirstView)):
        if let firstView = state.routes.first {
          state.routes = [
            firstView
          ]
        }
        return .none

      case .routeAction(_, action: .setCodeSignUp(._movePhoneNumberView)):
        state.routes.pop()
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
      
      // MARK: - 큐시즘 쇼케이스 코드
      case .routeAction(_, action: .setFlavorSignUp(._moveWelcomeSignUpView)):
        state.routes.append( .push( .setWelcomeSignUp(.init())))
        return .none
        
      default:
        return .none
      }
    }
    .forEachRoute {
      AuthScreen()
    }
  }
}
