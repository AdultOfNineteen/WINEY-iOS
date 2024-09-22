//
//  Auth.swift
//  WINEY
//
//  Created by 박혜운 on 9/17/24.
//

import ComposableArchitecture

@Reducer
public struct Auth {
  @ObservableState
  public struct State: Equatable {
    var login: Login.State = .init()
    var path: StackState<AuthPath.State> = .init()
  }
  
  public enum Action {
    case delegate(Delegate)
    
    public enum Delegate {
      case moveToTab
    }
    
    case login(Login.Action)
    case path(StackAction<AuthPath.State, AuthPath.Action>)
  }
  
  public var body: some Reducer<State, Action> {
    
    Scope(state: \.login, action: \.login, child: { Login() })
    
    pathReducer
    
    Reduce<State, Action> { state, action in
      switch action {
      
      default: return .none
      }
    }
  }
}
