//
//  UserInfoCoordinator.swift
//  Winey
//
//  Created by 정도현 on 2023/09/13.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct UserInfoCoordinator: Reducer {
  public struct State: Equatable, IndexedRouterState {
    public var routes: [Route<UserInfoScreen.State>]
    
    public init(
      routes: [Route<UserInfoScreen.State>] = [
        .root(
          .userInfo(.init()),
          embedInNavigationView: true
        )
      ]
    ){
      self.routes = routes
    }
  }
  
  public init() {}

  public enum Action: IndexedRouterAction {
    case updateRoutes([Route<UserInfoScreen.State>])
    case routeAction(Int, action: UserInfoScreen.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .routeAction(_, action: .userInfo(._moveToBadgeTap(let userId))):
        state.routes.append(.push( .userBadge(.init(userId: userId) )))
        return .none
        
      case .routeAction(_, action: .userInfo(._moveToUserInfo(let userId))):
        state.routes.append(.push( .userSetting(.init(userId: userId)) ))
        return .none
        
      case .routeAction(_, action: .userInfo(.tappedPersonalInfoPolicy)):
        state.routes.append(.push( .personalPolicy(.init()) ))
        return .none
        
      case .routeAction(_, action: .userSetting(.tappedChangeNickname)):
        state.routes.append(.push( .nickname(.init()) ))
        return .none
        
      case .routeAction(_, action: .userSetting(.tappedSignOut(let userId))):
        state.routes.append(.push( .signOut(.init(userId: userId)) ))
        return .none
        
      case let .routeAction(_, action: .signOut(.tappedNextButton(userId: userId, selectedOption: option, userReason: reason))):
        state.routes.append(.push( .signOutConfirm(.init(userId: userId, selectedSignOutOption: option, userReason: reason))))
        return .none
        
      case .routeAction(_, action: .userBadge(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .userSetting(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .personalPolicy(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .nickname(._backToSetting)):
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
      UserInfoScreen()
    }
  }
}
