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
    
    public var filteredNote: FilteredNote.State = FilteredNote.State()

    public init() { }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedAnalysisButton
    case tappedNoteWriteButton
    
    // MARK: - Inner Business Action
    case _navigateToAnalysis
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case filteredNote(FilteredNote.Action)
  }
  
  @Dependency(\.note) var noteService
  
  public var body: some ReducerOf<Self> {
    
    Scope(state: \.filteredNote, action: /Note.Action.filteredNote) {
      FilteredNote()
    }
    
    Reduce<State, Action> { state, action in
      switch action {
      case .tappedAnalysisButton:
        return .send(._navigateToAnalysis)
      default:
        return .none
      }
    }
  }
}
