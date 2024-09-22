//
//  Splash.swift
//  WINEY
//
//  Created by 박혜운 on 9/17/24.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct Splash {
  public struct State: Equatable {}
  
  public enum Action {
    // MARK: - Inner Business Action
    case _onAppear
    case _checkConnectHistory(_ status: Bool)
    case _serverConnection
    case _moveToTabBar
    case _moveToAuth
    
    case _setLoginState
  }
  
  @Dependency(\.userDefaults) var userDefaultsService
  @Dependency(\.user) var userService
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._onAppear:
        // Swipe Gesture 처리
        userDefaultsService.saveFlag(.isPopGestureEnabled, true)
        print("지금 로그아웃해서 다시 돌아옴")
        return .run { send in
          switch await userService.info() {
          case .success(let data):
            // MARK: - 테스트용. 삭제 예정
//            await send(._moveToTabBar)
            // MARK: - 실제 코드 
            await send(._checkConnectHistory(data.status == "ACTIVE"))
          case .failure:
            return await send(._moveToAuth)
          }
        }
        
      case ._checkConnectHistory(let status):
        if status {
          return .send(._serverConnection)
        } else {
          return .send(._moveToAuth)
        }
        
      case ._serverConnection:
        return .run { send in
          _ = await userService.connections()
          await send(._moveToTabBar)
        }
        
      default: return .none
      }
    }
  }
}
