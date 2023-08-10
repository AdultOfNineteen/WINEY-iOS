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

public struct SplashState: Equatable {
  public init() { }
}

public enum SplashAction: Equatable {
  // MARK: - Inner Business Action
  case _onAppear
  case _checkConnectHistory
  case _moveToHome
  case _moveToAuth
}

public struct SplashEnvironment {
  let userDefaultsService: UserDefaultsService
  
  public init(
    userDefaultsService: UserDefaultsService
  ) {
    self.userDefaultsService = userDefaultsService
  }
}

public let splashReducer = Reducer.combine([
  Reducer<SplashState, SplashAction, SplashEnvironment> { state, action, env in
    switch action {
    case ._onAppear:
    return Effect(value: ._checkConnectHistory)
      
    case ._checkConnectHistory:
      return env.userDefaultsService.load(.registered)
        .map({ status -> SplashAction in
          if status {
            return ._moveToHome
          } else {
            return ._moveToAuth // 전적이 없다면
          }
        })
      
    case ._moveToHome:
      print("_moveToHome")
      return .none
      
    case ._moveToAuth:
      print("_moveToAuth")
      return .none
    }
  }
])
