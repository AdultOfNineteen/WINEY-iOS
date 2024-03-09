//
//  WineAnaylsisCoordinator.swift
//  Winey
//
//  Created by 정도현 on 2023/09/16.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct WineAnalysisCoordinator: Reducer {
  public struct State: Equatable, IndexedRouterState {
    static let initialState = State(
      routes: [
        .root(
          .wineAnalysis(.init(isPresentedBottomSheet: false)),
          embedInNavigationView: true
        )
      ]
    )
    
    public var routes: [Route<WineAnalysisScreen.State>]
  }
  
  public enum Action: IndexedRouterAction {
    case routeAction(Int, action: WineAnalysisScreen.Action)
    case updateRoutes([Route<WineAnalysisScreen.State>])
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .routeAction(_, action: .wineAnaylsis(._navigateLoading)):
        state.routes.append(.push(.loading(.init())))
        return .none
        
      case let .routeAction(_, action: .loading(._completeAnalysis(data))):
        state.routes.pop()
        state.routes.append(.push(.result(.init(data: data))))
        return .none
      
      case .routeAction(_, action: .loading(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .result(.tappedBackButton)):
        state.routes.popToRoot()
        return .none
        
      default:
        return .none
      }
    }
    .forEachRoute {
      WineAnalysisScreen()
    }
  }
}
