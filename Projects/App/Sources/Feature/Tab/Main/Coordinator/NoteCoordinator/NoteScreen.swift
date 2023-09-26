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
  }

  public enum Action {
    case note(Note.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(
      state: /State.note,
      action: /Action.note
    ) {
      Note()
    }
  }
}
