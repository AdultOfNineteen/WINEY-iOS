//
//  WineTipCoordinator.swift
//  Winey
//
//  Created by 정도현 on 3/31/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct WineTipCoordinator: Reducer {
  
  public struct State: Equatable, IndexedRouterState {
    static func tipDetail(url: String) -> State {
      return State(
        routes: [
          .root(
            .tipCardDetail(.init(isEnterMainView: true, url: url)),
            embedInNavigationView: true
          )
        ]
      )
    }
    
    static let tipList = State(
      routes: [
        .root(
          .tipCardList(.init()),
          embedInNavigationView: true
        )
      ]
    )
    
    public var routes: [Route<WineTipScreen.State>]
  }
  
  public enum Action: IndexedRouterAction {
    case updateRoutes([Route<WineTipScreen.State>])
    case routeAction(Int, action: WineTipScreen.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      
      case let .routeAction(_, action: .tipCardList(.tappedTipCard(url: url))):
        state.routes.append(.push(.tipCardDetail(.init(url: url))))
        return .none
        
      case .routeAction(_, action: .tipCardDetail(._moveToList)):
        state.routes.pop()
        return .none
        
      default:
        return .none
      }
    }
    .forEachRoute {
      WineTipScreen()
    }
  }
}
