//
//  LoginCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import UserInfoData

@Reducer
public struct Login {
  
  @ObservableState
  public struct State: Equatable {
    var loginPath: LoginPathType?
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedLogin(LoginPathType)
    case tappedTermsOfUse
    
    // MARK: - Inner Business Action
    case _onAppear
    case _checkLoginHistory
    case _socialLogin(path: LoginPathType, accessToken: String?)
    
    // MARK: - Inner SetState Action
    case _setLoginPath(LoginPathType)
    case _completeSocialNetworking(Result<LoginUserDTO, Error>)
    case _moveUserStatusPage(LoginProcessType)
    
    case _gotoMain // 편의를 위한 임시
  }
  
  @Dependency(\.userDefaults) var userDefaultsService
  @Dependency(\.login) var authService
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._onAppear:
        return .run { send in
          await send(._checkLoginHistory)
        }
        
      case ._checkLoginHistory:
        if let path = userDefaultsService.loadValue(.socialLoginPath) {
          switch path {
          case "kakao":
            return .send(._setLoginPath(.kakao))
          case "google":
            return .send(._setLoginPath(.google))
          case "apple":
            return .send(._setLoginPath(.apple))
          default: break
          }
        }
        
        return .none
        
      case .tappedLogin(let path):
        return .run { send in
          if let token = await authService.socialLogin(path) {
            await send(._socialLogin(path: path, accessToken: token))
          }
        }
        
      case .tappedTermsOfUse:
        return .none
        
      case let ._setLoginPath(path):
        state.loginPath = path
        return .none
        
      case let ._socialLogin(path, token):
        self.userDefaultsService.saveValue(.socialLoginPath, path.rawValue)
        
        return .run { send in
          if let token = token {
            let data = await authService.loginState(path, token)
            await send(._completeSocialNetworking(data))
          }
        }
        
      case ._completeSocialNetworking(.failure):
        return .none // 에러 처리
        
      case let ._completeSocialNetworking(.success(data)):
        sendUserDefaults(data: data)
        
        return .send(
          ._moveUserStatusPage(
            self.routeBasedOnLoginStatus(data: data)
          )
        )
        
      case ._gotoMain:
        return .send(._moveUserStatusPage(.done))
        
      default: return .none
      }
    }
  }
  
  private func sendUserDefaults(data: LoginUserDTO) {
    self.userDefaultsService.saveValue(.accessToken, data.accessToken)
    self.userDefaultsService.saveValue(.refreshToken, data.refreshToken)
    self.userDefaultsService.saveValue(.userID, String(data.userId))
    self.userDefaultsService.saveFlag(.hasLaunched, true)
  }
  
  private func routeBasedOnLoginStatus(data: LoginUserDTO) -> LoginProcessType {
    switch (data.userStatus, data.messageStatus) {
    case ("ACTIVE", _):
      return .done
    case (_, "VERIFIED"):
      return .flavor
    default:
      return .code
    }
  }
}
