//
//  MapCoordinator.swift
//  Winey
//
//  Created by 정도현 on 2023/09/13.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct MapCoordinator: Reducer {
  public struct State: Equatable, IndexedRouterState {
    public var routes: [Route<MapScreen.State>]
    
    public init(
      routes: [Route<MapScreen.State>] = [
        .root(
          .map(.init()),
          embedInNavigationView: true
        )
      ]
    ){
      self.routes = routes
    }
  }

  public enum Action: IndexedRouterAction {
    case updateRoutes([Route<MapScreen.State>])
    case routeAction(Int, action: MapScreen.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      return .none
    }
    .forEachRoute { // 🔥 없으면 연결 안됌
      MapScreen()
    }
  }
}
