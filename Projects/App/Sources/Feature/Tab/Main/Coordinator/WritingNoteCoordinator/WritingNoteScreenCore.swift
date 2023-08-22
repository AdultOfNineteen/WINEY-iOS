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

public enum WritingNoteScreenState: Equatable {
  case writingNote(WritingNoteState)
}

public enum WritingNoteScreenAction {
  case writingNote(WritingNoteAction)
}

internal struct WritingNoteScreenEnvironment {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  
  internal init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
}

internal let writingNoteScreenReducer =
Reducer<
  WritingNoteScreenState,
  WritingNoteScreenAction,
  WritingNoteScreenEnvironment
>
  .combine([
  writingNoteReducer
    .pullback(
      state: /WritingNoteScreenState.writingNote,
      action: /WritingNoteScreenAction.writingNote,
      environment: { _ in
        WritingNoteEnvironment()
      }
    )
])
