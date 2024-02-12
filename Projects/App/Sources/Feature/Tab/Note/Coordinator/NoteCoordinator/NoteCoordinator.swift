//
//  WritingNoteCoordinatorCore.swift
//  Winey
//
//  Created by 정도현 on 2023/08/22.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct NoteCoordinator: Reducer {
  public struct State: Equatable, IndexedRouterState {
    public var routes: [Route<NoteScreen.State>]
    
    public init(
      routes: [Route<NoteScreen.State>] = [
        .root(
          .note(.init()),
          embedInNavigationView: true
        )
      ]
    ){
      self.routes = routes
    }
  }
  
  public enum Action: IndexedRouterAction {
    case updateRoutes([Route<NoteScreen.State>])
    case routeAction(Int, action: NoteScreen.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .routeAction(_, action: .note(.filteredNote(.noteCardScroll(.tappedNoteCard(let noteId))))):
        state.routes.append(.push(.noteDetail(.init(noteId: noteId))))
        return .none
        
      case .routeAction(_, action: .note(.filteredNote(.tappedFilterButton))):
        state.routes.append(.push(.filterDetail(.init())))
        return .none
        
      case .routeAction(_, action: .note(.tappedNoteWriteButton)):
        state.routes.append(.push(.creatNote(.createState)))
        return .none
        
      case .routeAction(_, action: .createNote(.routeAction(_, action: .wineSearch(.tappedBackButton)))):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .createNote(.routeAction(_, action: .setAlcohol(._backToNoteDtail)))):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .createNote(.routeAction(_, action: .noteDone(.tappedButton)))):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .createNote(.routeAction(_, action: .setMemo(._backToFirstView)))):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .noteDetail(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case let .routeAction(_, action: .noteDetail(._patchNote(noteId: noteId))):
        state.routes.append(.push(.creatNote(.patchState)))
        return .none
        
      case .routeAction(_, action: .filterDetail(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .note(._navigateToAnalysis)):
        state.routes.append(.push(.analysis(.initialState)))
        return .none
        
      case .routeAction(_, action: .analysis(.routeAction(_, action: .wineAnaylsis(.tappedBackButton)))):
        state.routes.pop()
        return .none
        
      default:
        return .none
      }
    }
    .forEachRoute {
      NoteScreen()
    }
  }
}
