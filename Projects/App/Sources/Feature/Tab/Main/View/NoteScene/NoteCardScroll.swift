//
//  NoteCardScroll.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct NoteCardScroll: Reducer {
  public struct State: Equatable {
    public var noteCards: NoteDTO
    
    public init(noteCards: NoteDTO) {
      self.noteCards = noteCards
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedNoteCard(NoteContent)
    
    // MARK: - Inner Business Action
    
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
