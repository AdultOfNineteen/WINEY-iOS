//
//  SignUpCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import WineyNetwork
import UserInfoData

@Reducer
public  struct PhoneSignUp {
  
  @ObservableState
  public struct State: Equatable {
    var inputPhoneNumber: String = ""
    var validPhoneNumber: Bool = false
    var bottomSheetType: SignUpBottomSheetType = .sendCode
    var isPresentedBottomSheet: Bool = false
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedNextButton
    case tappedBottomCodeSendConfirmButton
    case tappedBottomAlreadySignUpConfirmButton
    case tappedOutsideOfBottomSheet
    case edited(inputText: String)
    
    // MARK: - Inner Business Action
    case _disappear
    case _moveCodeSignUpView(phone: String)
    
    // MARK: - Inner SetState Action
    case _handleSignUpResponse(Result<VoidResponse, Error>)
    case _changeBottomSheet(type: SignUpBottomSheetType)
    case _presentBottomSheet(Bool)
  }
  
  @Dependency(\.userDefaults) var userDefaultsService
  @Dependency(\.signUp) var signUpService
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .edited(let number):
        state.inputPhoneNumber = String(number.filter("0123456789".contains).prefix(11))
        state.validPhoneNumber = state.inputPhoneNumber.count == 11
        return .none
        
      case .tappedNextButton:
        guard let userId = userDefaultsService.loadValue(.userID) else { return .none }
        let phoneNumber = state.inputPhoneNumber
        
        return .run { send in
          let result = await signUpService.sendCode(
            userId,
            phoneNumber
          )
          await send(._handleSignUpResponse(result))
        }
        
      case let ._handleSignUpResponse(result):
        switch result {
        case .success:
          return .send(._changeBottomSheet(type: .sendCode))
          
        case .failure(let error):
          guard let providerError = error.toProviderError(),
                let message = providerError.errorBody?.message else {
            return .none
          }
          
          if let type = LoginPathType.convert(path: message) {
            let phone = state.inputPhoneNumber
            return .send(._changeBottomSheet(type: .alreadySignUp((phone, type))))
          } else {
            return .send(._changeBottomSheet(type: .codeDelayMinute))
          }
        }
        
      case let ._changeBottomSheet(type):
        state.bottomSheetType = type
        return .send(._presentBottomSheet(true))
        
      case let ._presentBottomSheet(isActive):
        state.isPresentedBottomSheet = isActive
        return .none
        
      case ._disappear:
        return .send(._presentBottomSheet(false))
        
      case .tappedBottomCodeSendConfirmButton:
        let phone = state.inputPhoneNumber
        return .send(._moveCodeSignUpView(phone: phone))
        
      case .tappedBottomAlreadySignUpConfirmButton:
        return .send(._presentBottomSheet(false))
        
      default:
        return .none
      }
    }
  }
}
