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
        
      case .routeAction(_, action: .wineSearch(.tappedWineCard(let wineCard))):
        state.routes.append(
          .push(
            .wineConfirm(
              .init(
                wineData: wineCard
              )
            )
          )
        )
        return .none
        
      case let .routeAction(_, action: .wineConfirm(._moveNextPage(wineId))):
        state.routes.append(.push(.setAlcohol(.init(wineId: wineId))))
        return .none
        
      case let .routeAction(_, action: .setAlcohol(._moveNextPage(wineId, officialAlcohol))):
        state.routes.append(.push(.setVintage(.init(wineId: wineId, officialAlcohol: officialAlcohol))))
        return .none
        
      case let .routeAction(_, action: .setVintage(._moveNextPage(wineId, officialAlcohol, vintage, price))):
        state.routes.append(.push(.setColorSmell(.init(wineId: wineId, officialAlcohol: officialAlcohol, vintage: vintage, price: price))))
        return .none
        
      case let .routeAction(_, action: .setColorSmell(._moveNextPage(wineId, officialAlcohol, vintage, price, color, smellKeywordList))):
        state.routes.append(
          .push(
            .setTaste(
              .init(
                wineId: wineId,
                officialAlcohol: officialAlcohol,
                vintage: vintage,
                price: price,
                color: color,
                smellKeywordList: smellKeywordList
              )
            )
          )
        )
        return .none
        
      case let .routeAction(
        _,
        action:
            .setTaste(
              ._moveNextPage(
                wineId,
                officialAlcohol,
                vintage,
                price,
                color,
                smellKeywordList,
                sweetness,
                acidity,
                alcohol,
                body,
                tannin,
                finish
              )
            )
      ):
        state.routes.append(
          .push(
            .setMemo(
              .init(
                wineId: wineId,
                officialAlcohol: officialAlcohol,
                vintage: vintage,
                price: price,
                color: color,
                smellKeywordList: smellKeywordList,
                sweetness: sweetness,
                acidity: acidity,
                alcohol: alcohol,
                body: body,
                tannin: tannin,
                finish: finish
              )
            )
          )
        )
        return .none
        
      case .routeAction(_, action: .setColorSmell(.tappedHelpSmellButton)):
        state.routes.append(.push(.helpSmell(.init())))
        return .none
        
      case .routeAction(_, action: .setTaste(.tappedHelpButton(let wineId))):
        state.routes.append(.push(.helpTaste(.init(wineId: wineId))))
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
        
      case .routeAction(_, action: .helpSmell(.tappedBackButton)):
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
