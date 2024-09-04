//
//  RecommendWineTastingNotesList.swift
//  Winey
//
//  Created by 박혜운 on 9/3/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SwiftUI

enum OtherTastingNoteNavigationDestination: Hashable {
  case allTastingNotesList
  case tastingNoteDetail(noteId: Int)
}


public struct SpecificWineTastingNotes: Reducer {
  public struct State: Equatable {
    var noteDetail: NoteDetail.State?
    private(set) var wineId: Int
    var tastingNoteData: NoteDTO = .init(isLast: false, totalCnt: 0, contents: [])
    
    var selectedNoteId: Int?
    var path = NavigationPath()
    
    public init(wineId: Int) {
      self.wineId = wineId
    }
  }
  
  @Dependency(\.note) var noteService
  
  public enum Action {
    // MARK: - User Action
    case tappedTastingNoteCell(noteId: Int)
    case tappedMoreTastingNote
    case pathChanged(NavigationPath)
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    
    // MARK: - Inner SetState Action
    case _setTastingNoteData(NoteDTO)
    
    // MARK: - Child Action
    case noteDetail(NoteDetail.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case ._viewWillAppear:
        let searchPage = 0
        let searchSize = 10
        let sortState = 0
        let countries: Set<String> = []
        let types: Set<String> = []
        let buyAgain: Int? = nil
        let wineId: Int = state.wineId
        
        return .run { send in
          switch await noteService.notes(searchPage, searchSize, sortState, countries, types, buyAgain, wineId) {
          case let .success(data):
            await send(._setTastingNoteData(data))
            
          case let .failure(error):
            print("데이터 가져오기 실패 \(error.localizedDescription)")
          }
        }
        
      case let ._setTastingNoteData(data):
        state.tastingNoteData = data
        return .none
        
      case let .tappedTastingNoteCell(noteId):
        state.noteDetail = .init(noteId: noteId, country: "", isMine: false)
        state.path.append(OtherTastingNoteNavigationDestination.tastingNoteDetail(noteId: noteId))
        return .none
        
      case .tappedMoreTastingNote:
        state.path.append(OtherTastingNoteNavigationDestination.allTastingNotesList)
        return .none
        
      case .pathChanged:
        state.path.removeLast()
        return .none
        
      case .noteDetail(.tappedBackButton):
        return .send(.pathChanged(.init())) // 임시 경로
        
      default: return .none
        
      }
    }
    .ifLet(\.noteDetail, action: /Action.noteDetail) {
      NoteDetail()
    }
  }
}
