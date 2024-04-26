//
//  UserSettingCoordinator.swift
//  Winey
//
//  Created by 정도현 on 4/2/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct UserSettingCoordinator: Reducer {
  
  public struct State: Equatable, IndexedRouterState {
    static func userSetting(userId: Int) -> State {
      return State(
        routes: [
          .root(
            .settingMain(.init(userId: userId)),
            embedInNavigationView: true
          )
        ]
      )
    }
    
    public var routes: [Route<UserSettingScreen.State>]
  }
  
  public enum Action: IndexedRouterAction {
    case updateRoutes([Route<UserSettingScreen.State>])
    case routeAction(Int, action: UserSettingScreen.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
        
      case .routeAction(_, action: .settingMain(.tappedChangeNickname)):
        state.routes.append(.push( .changeNickname(.init()) ))
        return .none
        
      case .routeAction(_, action: .settingMain(.tappedSignOut(let userId))):
        state.routes.append(.push( .signOut(.init(userId: userId)) ))
        return .none
        
      case let .routeAction(_, action: .signOut(.tappedNextButton(userId: userId, selectedOption: option, userReason: reason))):
        state.routes.append(.push( .signOutConfirm(.init(userId: userId, selectedSignOutOption: option, userReason: reason))))
        return .none
        
      case .routeAction(_, action: .changeNickname(._backToSetting)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .signOut(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .signOutConfirm(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      default:
        return .none
      }
    }
    .forEachRoute {
      UserSettingScreen()
    }
  }
}
