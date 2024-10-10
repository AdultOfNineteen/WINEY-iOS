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
  public struct State: Equatable {
    public var shareNoteId: Int? = nil
  }
  
  public enum Action {
    // MARK: - Inner Business Action
    case _onAppear
    case _checkConnectHistory(_ status: Bool)
    case _serverConnection
    case _moveToTabBar(shareNoteId: Int?)
    case _moveToAuth
    
    case _setLoginState
    
    case handleDeepLink(_ url: URL)
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
        let shareNoteId = state.shareNoteId
        
        return .run { send in
          _ = await userService.connections()
          await send(._moveToTabBar(shareNoteId: shareNoteId))
        }
        
      case let .handleDeepLink(url):
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
          let queryItems = components.queryItems ?? []
          for queryItem in queryItems {
            if queryItem.name == "id", let value = queryItem.value, let noteId = Int(value) {
              state.shareNoteId = noteId
            }
          }
        }
        
        return .none
        
      default: return .none
      }
    }
  }
}
