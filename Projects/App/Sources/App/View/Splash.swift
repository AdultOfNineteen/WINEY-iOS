//
//  Splash.swift
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
    
    case _setLoginState
  }
  
  @Dependency(\.userDefaults) var userDefaultsService
  @Dependency(\.continuousClock) var clock
  @Dependency(\.userDefaults) var userDefaults
  @Dependency(\.user) var userService
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._onAppear:
      return .run { send in
        switch await userService.info() {
        case .success:
          await send(._checkConnectHistory)
        case .failure:
          break // 실패 시 자동 처리
        }
      }
      
    case ._checkConnectHistory:
      if let hasLaunched = userDefaults.loadFalg(.hasLaunched),
      hasLaunched {
        return .send(._moveToHome)
      } else {
        return .send(._moveToAuth)
      }
    default: return .none
    }
  }
}
