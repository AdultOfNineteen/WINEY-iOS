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

public struct AuthScreen: Reducer {
  public enum State: Equatable {
    case login(Login.State)
    case setPhoneSignUp(PhoneSignUp.State)
    case setCodeSignUP(CodeSignUp.State)
    case setFlavorSignUp(FlavorSignUp.State)
    case setWelcomeSignUp(WelcomeSignUp.State)
  }
  
  public enum Action {
    case login(Login.Action)
    case setPhoneSignUp(PhoneSignUp.Action)
    case setCodeSignUp(CodeSignUp.Action)
    case setFlavorSignUp(FlavorSignUp.Action)
    case setWelcomeSignUp(WelcomeSignUp.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.login, action: /Action.login) {
      Login()
    }
    Scope(state: /State.setPhoneSignUp, action: /Action.setPhoneSignUp) {
      PhoneSignUp()
    }
    Scope(state: /State.setCodeSignUP, action: /Action.setCodeSignUp) {
      CodeSignUp()
    }
    Scope(state: /State.setFlavorSignUp, action: /Action.setFlavorSignUp) {
      FlavorSignUp()
    }
    Scope(state: /State.setWelcomeSignUp, action: /Action.setWelcomeSignUp) {
      WelcomeSignUp()
    }
  }
}
