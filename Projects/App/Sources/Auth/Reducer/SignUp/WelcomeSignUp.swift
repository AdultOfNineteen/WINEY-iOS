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

public struct WelcomeSignUp: Reducer {  
  public struct State: Equatable { }
  
  public enum Action: Equatable {
    // MARK: - User Action
    case tappedStartButton
    
    // MARK: - Inner Business Action

    // MARK: - Inner SetState Action
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    default:
      return .none
    }
  }
}
