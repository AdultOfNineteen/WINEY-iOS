//
//  NoteCardScroll.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct TastingNotes {
  
  @ObservableState
  public struct State: Equatable {
    public var noteListInfo: NoteDTO
    
    public init(noteCards: NoteDTO) {
      self.noteListInfo = noteCards
    }
    
    public init() {
      self.noteListInfo = .init(isLast: true, totalCnt: 0, contents: [])
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedNoteCard(noteId: Int)
    
    // MARK: - Inner Business Action
    case _fetchNextNotePage
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
