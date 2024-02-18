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
import UserDomain
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
    var isTimeOver: Bool = false
    var bottomSheetType: SignUpBottomSheetType = .codeFail
    var isPresentedBottomSheet: Bool = false
    
    var codeTryCount: Int = 1
    var codeValidateClock: Int = 10
    
    var timerId: String = "SignUpTimerID"  // for Cancellable Timer
    
    public init(phoneNumber: String) {
      self.phoneNumber = phoneNumber
    }
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
    case _onDisappear
    case _handleSignUpResponse(Result<VoidResponse, Error>)
    case _presentBottomSheet(Bool)
    case _startTimer
    case _decreaseTimer
    case _stopTimer
    
    // MARK: - Inner SetState Action
    case _changeBottomSheet(type: SignUpBottomSheetType)
    case _moveFlavorSignUpView
    case _backToFirstView
    case _movePhoneNumberView
  }
  
  @Dependency(\.userDefaults) var userDefaultsService
  @Dependency(\.auth) var authService
  @Dependency(\.continuousClock) var clock
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._onAppear:
      return .send(._startTimer)
      
    case ._onDisappear:
      return .send(._stopTimer)
      
    case ._startTimer:
      return .run { send in
        while true {
          try await Task.sleep(for: .seconds(1))
          await send(._decreaseTimer)
        }
      }
      .cancellable(id: state.timerId)
      
    case ._decreaseTimer:
      state.codeValidateClock -= 1
      
      if state.codeValidateClock == 0 {
        state.isTimeOver = true
        return .run { send in
          await send(._changeBottomSheet(type: .codeExpired))
          await send(._stopTimer)
          await send(._presentBottomSheet(true))
        }
      } else {
        return .none
      }
      
    case ._stopTimer:
      return .cancel(id: state.timerId)
      
    case .tappedBackButton:
      return .send(._movePhoneNumberView)
   
    case .edited(let number):
      state.inputCode = number
      state.validCode = number.count == 6
      return .none
      
    case .tappedReSendCodeButton:
      // TODO: 재전송 코드 추가
      state.codeTryCount += 1
      
      if state.codeTryCount > 3 {
        return .concatenate([
          .send(._stopTimer),
          .send(._changeBottomSheet(type: .codeSendOver))
        ])
      } else {
        state.codeValidateClock = 10
        state.isTimeOver = false
        
        return .concatenate([
          .send(._stopTimer),
          .run { send in
            await send(._startTimer)
            await send(._changeBottomSheet(type: .sendCode))
          }
        ])
      }
      
      //      return .run { send in
      //        let result = await authService.sendCode(
      //          userId,
      //          phoneNumber
      //        )
      //        await send(._handleSignUpResponse(result))
      //      }
      
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
