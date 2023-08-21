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
  case login(LoginState)
  case setPhoneSignUp(PhoneSignUpState)
  case setCodeSignUP(CodeSignUpState)
  case setFlavorSignUp(FlavorSignUpState)
  case setWelcomeSignUp(WelcomeSignUpState)
}

public enum AuthScreenAction {
  case login(LoginAction)
  case setPhoneSignUp(PhoneSignUpAction)
  case setCodeSignUp(CodeSignUpAction)
  case setFlavorSignUp(FlavorSignUpAction)
  case setWelcomeSignUp(WelcomeSignUpAction)
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
  setLoginReducer
    .pullback(
      state: /AuthScreenState.login,
      action: /AuthScreenAction.login,
      environment: {
        SetLoginEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: .live
        )
      }
    ),
  
  setPhoneSignUpReducer
    .pullback(
      state: /AuthScreenState.setPhoneSignUp,
      action: /AuthScreenAction.setPhoneSignUp,
      environment: {
        SetPhoneSignUpEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: .live
        )
      }
    ),
  
  setCodeSignUpReducer
    .pullback(
      state: /AuthScreenState.setCodeSignUP,
      action: /AuthScreenAction.setCodeSignUp,
      environment: {
        SetCodeSignUpEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: .live
        )
      }
    ),
  
  setFlavorSignUpReducer
    .pullback(
      state: /AuthScreenState.setFlavorSignUp,
      action: /AuthScreenAction.setFlavorSignUp,
      environment: {
        SetFlavorSignUpEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: .live
        )
      }
    ),
  
  setWelcomeSignUpReducer
    .pullback(
      state: /AuthScreenState.setWelcomeSignUp,
      action: /AuthScreenAction.setWelcomeSignUp,
      environment: {
        SetWelcomeSignUpEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: .live
        )
      }
    )
])
