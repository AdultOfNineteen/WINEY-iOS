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

public enum LoginPathType: String, Equatable {
  case kakao = "카카오"
  case apple = "애플"
  case gmail = "구글"
}

public struct Login: Reducer {
  
  public struct State: Equatable {
    var hasLoginHistory: Bool = false
    var loginPath: LoginPathType? {
      willSet { hasLoginHistory = self.loginPath != nil }
    }
    
    public init(loginPath: LoginPathType? = nil) {
      self.loginPath = loginPath
    }
  }
  
  public enum Action: Equatable {
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
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._onAppear:
      print("온어피어")
      return .send(._checkLoginHistory)
      
    case ._checkLoginHistory:
      // 여기서 통신
      return .send(._setLoginPath(.kakao)) // 임시
      
    case .tappedLoginPath(let path):
      print("touch 인지")
      switch path {
      case .kakao:
        return .send(._kakaoSignUp)
        
      case .apple:
        return .send(._appleSignUp)
        
      case .gmail:
        return .send(._gmailSingUp)
      }
      
    case .tappedTermsOfUse:
      return .none
      
    case let ._setLoginPath(path):
      state.loginPath = path
      return .none
      
    case ._kakaoSignUp: // 로그인 서비스에서 처리
      return .send(._completeSocialNetworking)
      
    case ._appleSignUp: // 로그인 서비스에서 처리
      return .send(._completeSocialNetworking)
      
    case ._gmailSingUp: // 로그인 서비스에서 처리
      return .send(._completeSocialNetworking)
      
    case ._completeSocialNetworking:
      print("소셜네트워킹 완료 수신")
      return .none
    }
  }
}
