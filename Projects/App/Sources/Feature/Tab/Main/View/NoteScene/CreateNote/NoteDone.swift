//
//  NoteDone.swift
//  Winey
//
//  Created by 정도현 on 12/12/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct NoteDone: Reducer {
  public struct State: Equatable {
    
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedButton
  
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
