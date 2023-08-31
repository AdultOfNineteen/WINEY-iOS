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

public enum NoteScreenState: Equatable {
  case note(NoteState)
}

public enum NoteScreenAction {
  case note(NoteAction)
}

internal struct NoteScreenEnvironment {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  
  internal init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
}

internal let noteScreenReducer =
Reducer<
  NoteScreenState,
  NoteScreenAction,
  NoteScreenEnvironment
>
  .combine([
  noteReducer
    .pullback(
      state: /NoteScreenState.note,
      action: /NoteScreenAction.note,
      environment: { _ in
        NoteEnvironment()
      }
    )
])
