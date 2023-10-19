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
    public var noteCardList: NoteCardScroll.State = NoteCardScroll.State()
    public init() {
      
    }
  }

  public enum Action {
    // MARK: - User Action
    case tappedAnalysisButton
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case noteCardScroll(NoteCardScroll.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      default:
        return .none
      }
    }
    
    Scope(state: \.noteCardList, action: /Note.Action.noteCardScroll) {
      NoteCardScroll()
    }
  }
}
