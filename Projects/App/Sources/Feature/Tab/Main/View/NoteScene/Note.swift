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
    public init() { }
  }

  public enum Action {
    // MARK: - User Action
    case noteTapTapped
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action

  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}
