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
    
    public var noteId: Int
    
    public init(noteId: Int) {
      self.noteId = noteId
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedYesButton(noteId: Int)
    case tappedNoButton
    
    // MARK: - Inner Business Action
    case _dismissScreen
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }

  public var body: some ReducerOf<Self> {
    
    Reduce { state, action in
      switch action {
        
      default:
        return .none
      }
    }
  }
}
