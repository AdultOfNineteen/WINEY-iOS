//
//  WritingNoteCore.swift
//  Winey
//
//  Created by 정도현 on 2023/08/21.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation

public struct Note: Reducer {
  public struct State: Equatable {
    public var tooltipState: Bool = false
    public var noteCardList: NoteCardScroll.State?
    public var noteFilterScroll: NoteFilterScroll.State = NoteFilterScroll.State()
    
    public init() {
      
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedAnalysisButton
    case tappedNoteWriteButton
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _navigateToAnalysis
    
    // MARK: - Inner SetState Action
    case _setNotes(data: NoteDTO)
    case _failureSocialNetworking(Error)  // 추후 경고 처리
    
    // MARK: - Child Action
    case noteCardScroll(NoteCardScroll.Action)
    case noteFilterScroll(NoteFilterScroll.Action)
  }
  
  @Dependency(\.note) var noteService
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.noteFilterScroll, action: /Note.Action.noteFilterScroll) {
      NoteFilterScroll()
    }
    
    Reduce<State, Action> { state, action in
      switch action {
      
      case ._viewWillAppear:
        return .run { send in
          switch await noteService.notes(0, 10, 0, ["프랑스"], [""], 0) {
          case let .success(data):
            await send(._setNotes(data: data))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        }
        
      case let ._setNotes(data):
        state.noteCardList = NoteCardScroll.State.init(noteCards: data)
        return .none
        
      case .tappedAnalysisButton:
        return .send(._navigateToAnalysis)
        
      default:
        return .none
      }
    }
    .ifLet(\.noteCardList, action: /Note.Action.noteCardScroll) {
      NoteCardScroll()
    }
  }
}
