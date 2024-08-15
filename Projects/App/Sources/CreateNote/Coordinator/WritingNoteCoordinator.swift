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
    static let createState = State(
      routes: [
        .root(
          .wineSearch(.init()),
          embedInNavigationView: true
        )
      ]
    )
    
    static let patchState = State(
      routes: [
        .root(
          .setAlcohol(.init()),
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
        CreateNoteManager.shared.initData()
        
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
        
      case .routeAction(_, action: .wineConfirm(._moveNextPage)):
        state.routes.append(.push(.setAlcohol(.init())))
        return .none
        
      case .routeAction(_, action: .setAlcohol(._moveNextPage)):
        state.routes.append(.push(.setVintage(.init())))
        return .none
        
      case .routeAction(_, action: .setVintage(._moveNextPage)):
        state.routes.append(.push(.setColorSmell(.init())))
        return .none
        
      case .routeAction(_, action: .setColorSmell(._moveNextPage)):
        state.routes.append(.push(.setTaste(.init())))
        return .none
        
      case  .routeAction(_, action: .setTaste(._moveNextPage)):
        state.routes.append(.push(.setMemo(.init())))
        return .none
        
      case .routeAction(_, action: .setColorSmell(._moveSmellHelp)):
        state.routes.append(.push(.helpSmell(.init())))
        return .none
        
      case .routeAction(_, action: .setTaste(.tappedHelpButton(let wineId))):
        state.routes.append(.push(.helpTaste(.init(wineId: wineId))))
        return .none
        
      case .routeAction(_, action: .setMemo(._moveNextPage)):
        state.routes.append(.push(.noteDone(.init())))
        return .none
        
      case .routeAction(_, action: .wineConfirm(._moveBackPage)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .setAlcohol(._backToWineSearch)):
        state.routes.popToRoot()
        return .none
        
      case .routeAction(_, action: .setVintage(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .setColorSmell(._moveBackPage)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .helpSmell(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .setTaste(._moveBackPage)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .helpTaste(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .setMemo(._moveBackPage)):
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
