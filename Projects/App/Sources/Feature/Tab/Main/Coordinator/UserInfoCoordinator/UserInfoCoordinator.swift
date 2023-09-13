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

  public enum Action: IndexedRouterAction {
    case updateRoutes([Route<UserInfoScreen.State>])
    case routeAction(Int, action: UserInfoScreen.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      return .none
    }
  }
}
