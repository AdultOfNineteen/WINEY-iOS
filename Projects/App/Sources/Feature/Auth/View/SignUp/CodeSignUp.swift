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

public struct CodeSignUp: Reducer {
  public enum CodeBottomSheetType: Equatable {
    public static func == (lhs: CodeBottomSheetType, rhs: CodeBottomSheetType) -> Bool {
      switch (lhs, rhs) {
      case (.back, .back), (.codeFail, .codeFail), (.resendCode, .resendCode):
        return true
      case let (.alreadySignUp((lhsPhone, lhsPath)), .alreadySignUp((rhsPhone, rhsPath))):
        return lhsPhone == rhsPhone && lhsPath == rhsPath
      default:
        return false
      }
    }
    
    case back
    case resendCode
    case alreadySignUp((phone: String, path: LoginPathType))
    case codeFail
  }
  
  
  public enum CodeResponseType: Equatable {
    case completed
    case alreadySignUp
    case codeFail
  }
  
  public struct State: Equatable {
    let id = UUID()
    var inputCode: String = ""
    var validCode: Bool = false
    var bottomSheetType: CodeBottomSheetType = .codeFail
    var isPresentedBottomSheet: Bool = false
  }
  
  public enum Action {
    
    // MARK: - User Action
    case tappedBackButton
    case tappedCodeConfirmButton
    case tappedBottomFailConfirmButton
    case tappedBottomResendCodeButton
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
  
  //  public struct SetCodeSignUpEnvironment {
  //    let mainQueue: AnySchedulerOf<DispatchQueue>
  //    let userDefaultsService: UserDefaultsService
  //
  //    public init(
  //      mainQueue: AnySchedulerOf<DispatchQueue>,
  //      userDefaultsService: UserDefaultsService
  //    ) {
  //      self.mainQueue = mainQueue
  //      self.userDefaultsService = userDefaultsService
  //    }
  //  }
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
      return .send(._changeBottomSheet(type: .resendCode))
      
    case .tappedCodeConfirmButton:
      // Environment 통한 통신결과 반영
      let envResult: Result<CodeResponseType, Error> = .success(.completed)
      return .send(._handleSignUpResponse(envResult))
      
    case .tappedBottomAlreadySignUpButton:
      
      return .none
      
    case .tappedBottomFailConfirmButton:
      return .send(._presentBottomSheet(false))
      
    case .tappedBottomResendCodeButton:
      return .send(._presentBottomSheet(false))
      
    case ._handleSignUpResponse(.success(let result)):
      switch result {
      case .completed:
        return .send(._moveFlavorSignUpView)
      case .alreadySignUp:
        // 통신 결과를 통한 값 반영
        return .send(._changeBottomSheet(type: .alreadySignUp(("010-1234-1234", .kakao)))) // 임시 값
      case .codeFail:
        return .send(._changeBottomSheet(type: .codeFail))
      }
      
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
