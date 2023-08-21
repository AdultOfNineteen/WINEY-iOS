//
//  CodeSignUpCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

public enum CodeBottomSheetType: Equatable {
  case back
  case alreadySignUp
  case codeFail
}

public enum CodeResponseType: Equatable {
  case completed
  case alreadySignUp
  case codeFail
}

public struct CodeSignUpState: Equatable {
  var inputCode: String = ""
  var validCode: Bool = false
  var bottomSheetType: CodeBottomSheetType = .codeFail
  var isPresentedBottomSheet: Bool = false
}

public enum CodeSignUpAction {
  
  // MARK: - User Action
  case tappedBackButton
  case tappedCodeConfirmButton
  case tappedBottomFailConfirmButton
  case tappedBottomAlreadySignUpButton
  case tappedOutsideOfBottomSheet
  case tappedReSendCodeButton
  case edited(inputText: String)
  
  // MARK: - Inner Business Action
  case _onAppear
  case _handleSignUpResponse(Result<CodeResponseType, Error>)
  case _presentBottomSheet(Bool)
  
  // MARK: - Inner SetState Action
  case _changeBottomSheet(type: CodeBottomSheetType)
  case _moveFlavorSignUpView
  case _backToFirstView
}

public struct SetCodeSignUpEnvironment {
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

public let setCodeSignUpReducer: Reducer<CodeSignUpState, CodeSignUpAction, SetCodeSignUpEnvironment> =
Reducer { state, action, environment in
  switch action {
  case ._onAppear:
    return .none
    
  case .tappedBackButton:
    return Effect(value: ._changeBottomSheet(type: .back))
    
  case .edited(let number):
    state.inputCode = number
    state.validCode = number.count == 6
    return .none
    
  case .tappedCodeConfirmButton:
    // Environment 통한 통신결과 반영
    let envResult: Result<CodeResponseType, Error> = .success(.completed) // 임시
    return Effect(value: ._handleSignUpResponse(envResult))
    
  case .tappedBottomAlreadySignUpButton:
    
    return .none
    
  case .tappedBottomFailConfirmButton:
    return Effect(value: ._presentBottomSheet(false))
    
  case ._handleSignUpResponse(.success(let result)):
    switch result {
    case .completed:
      return Effect(value: ._moveFlavorSignUpView)
    case .alreadySignUp:
      return Effect(value: ._changeBottomSheet(type: .alreadySignUp))
    case .codeFail:
      return Effect(value: ._changeBottomSheet(type: .codeFail))
    }
    
  case ._handleSignUpResponse(.failure):
    return Effect(value: ._changeBottomSheet(type: .codeFail))
    
  case ._changeBottomSheet(let sheetType):
    state.bottomSheetType = sheetType
    return Effect(value: ._presentBottomSheet(true))
    
  case ._presentBottomSheet(let bool):
    state.isPresentedBottomSheet = bool
    return .none

  default:
    return .none
  }
}
.debug("CodeSignUp Reducer")
