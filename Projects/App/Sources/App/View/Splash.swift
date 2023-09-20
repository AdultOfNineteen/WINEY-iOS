//
//  SplashCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

public struct Splash: Reducer {
  public struct State: Equatable {
    static let initialState = State()

    public init() {}
  }
  
  public enum Action {
    // MARK: - Inner Business Action
    case _onAppear
    case _checkConnectHistory
    case _moveToHome
    case _moveToAuth
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._onAppear:
      return .send(._checkConnectHistory)
      
    case ._checkConnectHistory:
      return .send(._moveToAuth) // 임시

    case ._moveToHome:
      print("_moveToHome")
      return .none
      
    case ._moveToAuth:
      print("_moveToAuth")
      return .none
    }
  }
}
