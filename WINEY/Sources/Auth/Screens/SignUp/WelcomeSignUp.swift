//
//  WelcomeSignUpCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/21.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

@Reducer
public struct WelcomeSignUp {
  public struct State: Equatable { }
  
  public enum Action: Equatable {
    // MARK: - User Action
    case tappedStartButton
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
  }
  
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
