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
import WineyNetwork

public struct CodeSignUp: Reducer {

  public enum CodeResponseType: Equatable {
    case completed
    case alreadySignUp(phone: String, path: LoginPathType)
    case codeFail
  }
  
  public struct State: Equatable {
    let phoneNumber: String
    var inputCode: String = ""
    var validCode: Bool = false
    var bottomSheetType: SignUpBottomSheetType = .codeFail
    var isPresentedBottomSheet: Bool = false
  }
  
  public enum Action {
    
    // MARK: - User Action
    case edited(inputText: String)
    case tappedBackButton
    case tappedReSendCodeButton
    case tappedCodeConfirmButton
    case tappedBottomFailConfirmButton
    case tappedBottomResendCodeButton
    case tappedOutsideOfBottomSheet // 구색 맞춤
    
    // MARK: - Inner Business Action
    case _onAppear
    case _handleSignUpResponse(Result<VoidResponse, Error>)
    case _presentBottomSheet(Bool)
    
    // MARK: - Inner SetState Action
    case _changeBottomSheet(type: SignUpBottomSheetType)
    case _moveFlavorSignUpView
    case _backToFirstView
  }
  
  @Dependency(\.userDefaults) var userDefaultsService
  @Dependency(\.auth) var authService

  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._onAppear:
      return .none
      
    case .tappedBackButton:
      return .send(._changeBottomSheet(type: .back))
      
    case .edited(let number):
      state.inputCode = number
      state.validCode = number.count == 6
      return .none
      
    case .tappedReSendCodeButton:
      return .send(._changeBottomSheet(type: .sendCode))
      
    case .tappedCodeConfirmButton:
      guard let userId = userDefaultsService.loadValue(.userID) else { return .none }
      let phone = state.phoneNumber
      let code = state.inputCode
      
      return .run{ send in
        let result = await authService.codeConfirm(
          userId,
          phone,
          code
        )
        await send(._handleSignUpResponse(result))
      }
      
    case ._handleSignUpResponse(.success):
      return .send(._moveFlavorSignUpView)
      
    case ._handleSignUpResponse(.failure): 
      return .send(._changeBottomSheet(type: .codeFail))
      
    case ._changeBottomSheet(let sheetType):
      state.bottomSheetType = sheetType
      return .send(._presentBottomSheet(true))
      
    case ._presentBottomSheet(let bool):
      state.isPresentedBottomSheet = bool
      return .none
      
    default:
      return .none
    }
  }
}
