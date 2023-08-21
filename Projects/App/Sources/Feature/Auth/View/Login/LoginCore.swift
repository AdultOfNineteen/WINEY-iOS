//
//  LoginCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

public enum LoginPathType: String {
  case kakao = "카카오"
  case apple = "애플"
  case gmail = "구글"
}

public struct LoginState: Equatable {
  var hasLoginHistory: Bool = false
  var loginPath: LoginPathType? {
    willSet { hasLoginHistory = self.loginPath != nil }
  }

  public init(loginPath: LoginPathType? = nil) {
    self.loginPath = loginPath
  }
}

public enum LoginAction: Equatable {
  // MARK: - User Action
  case tappedLoginPath(LoginPathType)
  case tappedTermsOfUse
  
  // MARK: - Inner Business Action
  case _onAppear
  case _checkLoginHistory
  case _kakaoSignUp
  case _appleSignUp
  case _gmailSingUp
  
  // MARK: - Inner SetState Action
  case _setLoginPath(LoginPathType)
  case _completeSocialNetworking
}

public struct SetLoginEnvironment {
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

public let setLoginReducer = Reducer.combine([
  Reducer<LoginState, LoginAction, SetLoginEnvironment> { state, action, env in
    switch action {
    case ._onAppear:
      return Effect(value: ._checkLoginHistory)
      
    case ._checkLoginHistory:
      // 여기서 통신
      return Effect(value: ._setLoginPath(.kakao)) // 임시
      
    case .tappedLoginPath(let path):
      switch path {
      case .kakao:
        return Effect(value: ._kakaoSignUp)
        
      case .apple:
        return Effect(value: ._appleSignUp)
        
      case .gmail:
        return Effect(value: ._gmailSingUp)
      }
      
    case .tappedTermsOfUse:
      return .none
      
    case let ._setLoginPath(path):
      state.loginPath = path
      return .none
      
    case ._kakaoSignUp: // 로그인 서비스에서 처리
      return Effect(value: ._completeSocialNetworking)
      
    case ._appleSignUp: // 로그인 서비스에서 처리
      return Effect(value: ._completeSocialNetworking)
      
    case ._gmailSingUp: // 로그인 서비스에서 처리
      return Effect(value: ._completeSocialNetworking)
      
    case ._completeSocialNetworking:
      return .none
    }
  }
])
