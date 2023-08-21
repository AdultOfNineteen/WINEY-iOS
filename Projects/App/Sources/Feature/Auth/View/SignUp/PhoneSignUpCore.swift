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

public struct PhoneSignUpState: Equatable {
  var inputPhoneNumber: String = ""
  var validPhoneNumber: Bool = false
  var isPresentedBottomSheet: Bool = false
}

public enum PhoneSignUpAction: Equatable {
  // MARK: - User Action
  case tappedBackButton
  case tappedNextButton
  case tappedBottomCodeSendConfirmButton
  case tappedOutsideOfBottomSheet
  case edited(inputText: String)

  // MARK: - Inner Business Action
  case _disappear
  case _moveCodeSignUpView

  // MARK: - Inner SetState Action
}

public struct SetPhoneSignUpEnvironment {
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

public let setPhoneSignUpReducer: Reducer<PhoneSignUpState, PhoneSignUpAction, SetPhoneSignUpEnvironment> =
Reducer { state, action, environment in
  switch action {
  case .edited(let number):
    state.inputPhoneNumber = number
    state.validPhoneNumber = number.count == 13
    return .none
  
  case .tappedNextButton:
    state.isPresentedBottomSheet = true
    return .none
    
  case .tappedBottomCodeSendConfirmButton:
    return Effect(value: ._moveCodeSignUpView)

  default:
    return .none
  }
}
.debug("PhoneSignUp Reducer")
