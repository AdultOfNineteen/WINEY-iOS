//
//  AuthCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

public struct AuthState: Equatable {
  var loginPath: LoginPathType?
  var selectedTermsOfUse: Bool = false

  public init(loginPath: LoginPathType? = nil) {
    self.loginPath = loginPath
  }
}

public enum AuthAction: Equatable {
  // MARK: - User Action
  case categoryTapped(LoginPathType)
  case selectTermsOfUseTapped
  
  // MARK: - Inner Business Action
  // 네트워크 통신
  case kakaoSignUp
  case appleSignUp
  case gmailSingUp
  
  // MARK: - Inner SetState Action
  case completeSocialNetworking
}

public struct SetAuthEnvironment {
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

public let setAuthReducer = Reducer.combine([
  Reducer<AuthState, AuthAction, SetAuthEnvironment> { state, action, env in
    
    switch action {
    case let .categoryTapped(path):
      switch path {
      case .kakao:
        return Effect(value: .kakaoSignUp)
      case .apple:
        return Effect(value: .appleSignUp)
      case .gmail:
        return Effect(value: .gmailSingUp)
      }
      
    case .selectTermsOfUseTapped:
      // 여기서 화면 이동
      return .none
    case .kakaoSignUp:
      // 로그인 서비스에서 처리
      return Effect(value: .completeSocialNetworking)
    case .appleSignUp:
      // 로그인 서비스에서 처리
      return Effect(value: .completeSocialNetworking)
    case .gmailSingUp:
      // 로그인 서비스에서 처리
      return Effect(value: .completeSocialNetworking)
    case .completeSocialNetworking:
      print("네트워킹 완료?")
      return .none
    }
  }
])
