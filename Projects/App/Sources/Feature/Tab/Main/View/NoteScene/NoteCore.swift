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

public struct NoteState: Equatable {
  public init() { }
}

public enum NoteAction {
  // MARK: - User Action
  case noteTapTapped
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action

}

public struct NoteEnvironment {
  public init() { }
}

public let noteReducer = Reducer.combine([
  Reducer<NoteState, NoteAction, NoteEnvironment> { state, action, env in
    return .none
  }
])
