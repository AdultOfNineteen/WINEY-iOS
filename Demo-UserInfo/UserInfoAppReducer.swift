//
//  UserInfoDemo.swift
//  Demo-UserInfo
//
//  Created by 박혜운 on 10/4/24.
//

import ComposableArchitecture
import UserInfoPresentation

@Reducer
public struct UserInfoAppReducer {
  
  @ObservableState
  public struct State: Equatable {
    var userInfo: UserInfo.State = .init()
    
    public var path: StackState<UserInfoPath.State> = .init()
  }
  
  public enum Action {
    case userInfo(UserInfo.Action)
    
    case path(StackAction<UserInfoPath.State, UserInfoPath.Action>)
  }
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.userInfo, action: \.userInfo) { UserInfo() }
    
    pathReducer
  }
}
