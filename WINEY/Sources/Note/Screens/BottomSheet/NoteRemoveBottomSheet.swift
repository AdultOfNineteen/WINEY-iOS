//
//  NoteRemoveBottomSheet.swift
//  Winey
//
//  Created by 정도현 on 5/25/24.
//  Copyright © 2024 Winey. All rights reserved.
//


import ComposableArchitecture

@Reducer
public struct NoteRemoveBottomSheet {
  
  @ObservableState
  public struct State: Equatable {
    
    public var noteDetail: NoteDetail.State
    
    public init(noteDetail: NoteDetail.State) {
      self.noteDetail = noteDetail
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedYesButton
    case tappedNoButton
    
    // MARK: - Inner Business Action
    case _dismissScreen
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case noteDetail(NoteDetail.Action)
  }

  public var body: some ReducerOf<Self> {
    
    Scope(state: \.noteDetail, action: \.noteDetail) {
      NoteDetail()
    }
    
    Reduce { state, action in
      switch action {
        
      case .tappedYesButton:
        return .send(.noteDetail(.tappedNoteDelete(state.noteDetail.noteId)))
        
      case .tappedNoButton:
        return .send(._dismissScreen)
        
      default:
        return .none
      }
    }
  }
}
