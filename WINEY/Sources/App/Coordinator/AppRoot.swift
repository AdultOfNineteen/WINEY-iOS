//
//  AppRoot.swift
//  WINEY
//
//  Created by 박혜운 on 9/17/24.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct AppRoot {
  
  @ObservableState
  public struct State: Equatable {
    var destination: AppRootDestination.State? = .splash(.init())
  }
  
  public enum Action {
    case _moveToSplash
    case _moveToAuth
    case _moveToTabBar
    case _openOtherNote(noteId: Int, isMine: Bool)
    
    case handleDeepLink(_ url: URL)
    
    case destination(AppRootDestination.Action)
  }
  
  public var body: some Reducer<State, Action> {
    
    destinationReducer
    
    Reduce<State, Action> { state, action in
      switch action {
      case let .handleDeepLink(url):
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
          let queryItems = components.queryItems ?? []
          for queryItem in queryItems {
            if queryItem.name == "id", let value = queryItem.value, let noteId = Int(value) {
              return .send(._openOtherNote(noteId: noteId, isMine: false))
            }
          }
        }
        
        return .none
        
      default: return .none
      }
    }
  }
}
