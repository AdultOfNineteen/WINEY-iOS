//
//  WritingNoteCoordinator.swift
//  Winey
//
//  Created by 정도현 on 11/30/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct WritingNoteCoordinator: Reducer {
  public struct State: Equatable, IndexedRouterState {
    static let initialState = State(
      routes: [
        .root(
          .wineSearch(.init()),
          embedInNavigationView: true
        )
      ]
    )
    
    public var routes: [Route<WritingNoteScreen.State>]
  }
  
  public enum Action: IndexedRouterAction {
    case routeAction(Int, action: WritingNoteScreen.Action)
    case updateRoutes([Route<WritingNoteScreen.State>])
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case .routeAction(_, action: .wineSearch(.noteCard(id: _, action: ._navigateToCardDetail(_, _)))):
        state.routes.append(
          .push(
            .wineConfirm(
              .init(
                wineData: WineDTO(
                  wineId: 1,
                  type: "PORT",
                  name: "mock1",
                  country: "mock1",
                  varietal: "랄라라",
                  sweetness: 3,
                  acidity: 2,
                  body: 3,
                  tannins: 4,
                  wineSummary: WineSummary(
                    avgPrice: 1.0,
                    avgSweetness: 2,
                    avgAcidity: 3,
                    avgBody: 2,
                    avgTannins: 1
                  )
                )
              )
            )
          )
        )
        return .none
        
      case .routeAction(_, action: .wineConfirm(.tappedWritingButton)):
        state.routes.append(.push(.setAlcohol(.init())))
        return .none
        
      case .routeAction(_, action: .setAlcohol(.tappedNextButton)):
        state.routes.append(.push(.setVintage(.init())))
        return .none
        
      case .routeAction(_, action: .setVintage(.tappedNextButton)):
        state.routes.append(.push(.setColorSmell(.init())))
        return .none
        
      case .routeAction(_, action: .setColorSmell(.tappedNextButton)):
        state.routes.append(.push(.setTaste(.init())))
        return .none
        
      case .routeAction(_, action: .setTaste(.tappedNextButton)):
        state.routes.append(.push(.setMemo(.init())))
        return .none
        
      case .routeAction(_, action: .setTaste(.tappedHelpButton)):
        state.routes.append(.push(.helpTaste(.init())))
        return .none
        
      case .routeAction(_, action: .setMemo(.tappedDoneButton)):
        state.routes.append(.push(.noteDone(.init())))
        return .none
        
      case .routeAction(_, action: .wineConfirm(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .setAlcohol(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .setVintage(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .setColorSmell(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .setTaste(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .helpTaste(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      default:
        return .none
      }
    }
    .forEachRoute {
      WritingNoteScreen()
    }
  }
}
