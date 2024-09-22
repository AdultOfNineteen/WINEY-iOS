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
    
    case destination(AppRootDestination.Action)
  }
  
  public var body: some Reducer<State, Action> {
    destinationReducer
    
    Reduce<State, Action> { state, action in
      switch action {
      default: return .none
      }
    }
  }
}
