//
//  WritingNoteScreenCore.swift
//  Winey
//
//  Created by 정도현 on 2023/08/22.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct NoteScreen: Reducer {
  public enum State: Equatable {
    case note(Note.State)
    case noteDetail(NoteDetail.State)
    case filterDetail(FilterDetail.State)
    case creatNote(WritingNoteCoordinator.State)
    case analysis(WineAnalysisCoordinator.State)
  }

  public enum Action {
    case note(Note.Action)
    case noteDetail(NoteDetail.Action)
    case filterDetail(FilterDetail.Action)
    case createNote(WritingNoteCoordinator.Action)
    case analysis(WineAnalysisCoordinator.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(
      state: /State.note,
      action: /Action.note
    ) {
      Note()
    }
    
    Scope(
      state: /State.noteDetail,
      action: /Action.noteDetail
    ) {
      NoteDetail()
    }
    
    Scope(
      state: /State.filterDetail,
      action: /Action.filterDetail
    ) {
      FilterDetail()
    }
    
    Scope(
      state: /State.creatNote,
      action: /Action.createNote
    ) {
      WritingNoteCoordinator()
    }
    
    Scope(state: /State.analysis, action: /Action.analysis) {
      WineAnalysisCoordinator()
    }
  }
}
