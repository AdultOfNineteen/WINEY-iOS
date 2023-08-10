//
//  SignUpCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

import Combine
import ComposableArchitecture
import Foundation

public struct SignUpState: Equatable {
}

public enum SignUpAction: Equatable {
  case start
  case signUpCompleted
}

public struct SetSignUpEnvironment {
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

public let setSignUpReducer: Reducer<SignUpState, SignUpAction, SetSignUpEnvironment> =
Reducer { state, action, environment in
  switch action {
  case .signUpCompleted:
    return .none

  case .start:
    return .none
  }
}
