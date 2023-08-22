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

public struct WritingNoteState: Equatable {
  public init() { }
}

public enum WritingNoteAction {
  // MARK: - User Action
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action

}

public struct WritingNoteEnvironment {
  public init() { }
}

public let writingNoteReducer = Reducer.combine([
  Reducer<WritingNoteState, WritingNoteAction, WritingNoteEnvironment> { state, action, env in
    return .none
  }
])
