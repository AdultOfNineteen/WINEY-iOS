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
    var bottomSheetType: SignUpBottomSheetType = .codeExpired
    var isPresentedBottomSheet: Bool = false
    
    var timerId: String = "SignUpTimerID"  // for Cancellable Timer
    var codeVerifyCount: Int = 0  // 코드 인증 횟수
    var codeResendCount: Int = 1  // 코드 재전송 횟수
    var codeValidateClock: Int = 180
    var isShowVerifyError: Bool = false
    
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
    case _handleSendCodeResponse(Result<VoidResponse, Error>)
    case _presentBottomSheet(Bool)
    case _startTimer
    case _decreaseTimer
    case _stopTimer
    case _sendCode
    
    // MARK: - Inner SetState Action
    case _changeBottomSheet(type: SignUpBottomSheetType)
    case _moveFlavorSignUpView
    case _backToFirstView
    case _movePhoneNumberView
    case _setDisplayErrorState(Bool)
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
      return .send(._changeBottomSheet(type: .back))
      
    case ._sendCode:
      guard let userId = userDefaultsService.loadValue(.userID) else { return .none }
      let phoneNumber = state.phoneNumber
      
      return .run { send in
        let result = await authService.sendCode(
          userId,
          phoneNumber
        )
        await send(._handleSendCodeResponse(result))
      }
   
    case .edited(let number):
      state.inputCode = String(number.filter("0123456789".contains).prefix(6))
      state.validCode = state.inputCode.count == 6
      
      if state.isShowVerifyError {
        return .send(._setDisplayErrorState(false))
      } else {
        return .none
      }
      
    case .tappedReSendCodeButton:
      state.codeResendCount += 1
      state.codeVerifyCount = 0
      
      if state.codeResendCount > 3 {
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
            await send(._sendCode)
          }
        ])
      }
      
    case .tappedCodeConfirmButton:
      guard let userId = userDefaultsService.loadValue(.userID) else { return .none }
      let phone = state.phoneNumber
      let code = state.inputCode
      
      state.codeVerifyCount += 1
      
      return .run { send in
        let result = await authService.codeConfirm(
          userId,
          phone,
          code
        )
        await send(._handleSignUpResponse(result))
      }
      
    case ._setDisplayErrorState(let bool):
      state.isShowVerifyError = bool
      return .none
      
    case ._handleSendCodeResponse(let result):
      switch result {
      case .success:
        return .send(._changeBottomSheet(type: .sendCode))
        
      case .failure(let error):
        // TODO: 메시지 전송 실패 시.
//        guard let providerError = error.toProviderError(),
//        let message = providerError.errorBody?.message,
//        let type = LoginPathType.convert(path: message) else { break }
//
//        return .send(._changeBottomSheet(type: .codeFail))
        return .none
      }
      
      
    case ._handleSignUpResponse(.success):
      return .send(._moveFlavorSignUpView)
      
    case ._handleSignUpResponse(.failure):
      if state.codeVerifyCount >= 5 {
        return .send(._changeBottomSheet(type: .codeFail))
      } else {
        return .send(._setDisplayErrorState(true))
      }
      
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
