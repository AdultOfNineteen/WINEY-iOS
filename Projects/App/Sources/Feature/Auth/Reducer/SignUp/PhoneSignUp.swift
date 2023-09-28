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

public  struct PhoneSignUp: Reducer {
  public struct State: Equatable {
    var inputPhoneNumber: String = ""
    var validPhoneNumber: Bool = false
    var isPresentedBottomSheet: Bool = false
  }

  public enum Action: Equatable {
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
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .edited(let number):
      state.inputPhoneNumber = number
      state.validPhoneNumber = number.count == 13
      return .none
    
    case .tappedNextButton:
      state.isPresentedBottomSheet = true
      return .none
      
    case .tappedBottomCodeSendConfirmButton:
      return .send(._moveCodeSignUpView)

    default:
      return .none
    }
  }
}
