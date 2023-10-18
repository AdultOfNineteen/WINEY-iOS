//
//  MainCoordinator.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct MainCoordinator: Reducer {
  
  public struct State: Equatable, IndexedRouterState {
    public var routes: [Route<MainScreen.State>]
    
    public init(
      routes: [Route<MainScreen.State>] = [
        .root(
          .main(.init(tooltipState: true)),
          embedInNavigationView: true
        )
      ]
    ){
      self.routes = routes
    }
  }
  
  public enum Action: IndexedRouterAction {
    case updateRoutes([Route<MainScreen.State>])
    case routeAction(Int, action: MainScreen.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .routeAction(
        _,
        action: .main(
          .wineCardScroll(
            .wineCard(id: _, action: ._navigateToCardDetail(id, wineData))
          )
        )
      ):
        state.routes.append(.push(
          .wineDetail(.init(windId: id, wineCardData: wineData))
        ))
        return .none
        
      case .routeAction(_, action: .wineDetail(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .main(._navigateToTipCard)):
        state.routes.append(.push(.tipCard(.init())))
        return .none
        
      case .routeAction(_, action: .tipCard(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      default:
        return .none
      }
    }
    .forEachRoute {
      MainScreen()
    }
  }
}
