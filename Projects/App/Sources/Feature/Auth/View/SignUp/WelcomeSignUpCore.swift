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

public struct WelcomeSignUpState: Equatable {}

public enum WelcomeSignUpAction: Equatable {
  // MARK: - User Action
  case tappedStartButton
  
  // MARK: - Inner Business Action

  // MARK: - Inner SetState Action
}

public struct SetWelcomeSignUpEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let userDefaultsService: UserDefaultsService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
  }
}

public let setWelcomeSignUpReducer: Reducer<WelcomeSignUpState, WelcomeSignUpAction, SetWelcomeSignUpEnvironment> =
Reducer { state, action, environment in
  switch action {
  default:
    return .none
  }
}
.debug("WelcomeSignUp Reducer")
