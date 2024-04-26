//
//  RecommendWineCoordinator.swift
//  Winey
//
//  Created by 정도현 on 3/31/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct RecommendWineCoordinator: Reducer {
  
  public struct State: Equatable, IndexedRouterState {
    static func wineDetail(id: Int, data: RecommendWineData) -> State {
      return State(
        routes: [
          .root(
            .wineDetail(.init(windId: id, wineCardData: data)),
            embedInNavigationView: true
          )
        ]
      )
    }
    
    static func cardList(data: IdentifiedArrayOf<WineCard.State>) -> State {
      return State(
        routes: [
          .root(
            .wineScroll(.init(wineCards: data)),
            embedInNavigationView: true
          )
        ]
      )
    }
    
    public var routes: [Route<RecommendWineScreen.State>]
  }
  
  public enum Action: IndexedRouterAction {
    case updateRoutes([Route<RecommendWineScreen.State>])
    case routeAction(Int, action: RecommendWineScreen.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      
        
        
        //      case let .routeAction(
        //        _,
        //        action: .main(
        //          .wineCardScroll(
        //            .wineCard(id: _, action: ._navigateToCardDetail(id, wineData))
        //          )
        //        )
        //      ):
        //        state.routes.append(.push(
        //          .wineDetail(.init(windId: id, wineCardData: wineData))
        //        ))
        //        return .none
        //
        //      case .routeAction(_, action: .wineDetail(.tappedBackButton)):
        //        state.routes.pop()
        //        return .none
        
        
      default:
        return .none
      }
    }
    .forEachRoute {
      RecommendWineScreen()
    }
  }
}
