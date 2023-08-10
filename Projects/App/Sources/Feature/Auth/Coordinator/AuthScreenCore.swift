//
//  AuthScreenCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public enum AuthScreenState: Equatable {
  case auth(AuthState)
  case setSignUp(SignUpState)
}

public enum AuthScreenAction {
  case auth(AuthAction)
  case setSignUp(SignUpAction)
}

internal struct AuthScreenEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  
  internal init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
}

internal let authScreenReducer = Reducer<
  AuthScreenState,
  AuthScreenAction,
  AuthScreenEnvironment
>.combine([
  setAuthReducer
    .pullback(
      state: /AuthScreenState.auth,
      action: /AuthScreenAction.auth,
      environment: {
        SetAuthEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: .live
        )
      }
    ),
  
  setSignUpReducer
    .pullback(
      state: /AuthScreenState.setSignUp,
      action: /AuthScreenAction.setSignUp,
      environment: {
        SetSignUpEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: .live
        )
      }
    )
])
