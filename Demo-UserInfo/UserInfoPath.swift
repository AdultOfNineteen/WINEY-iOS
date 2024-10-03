//
//  File.swift
//
//
//  Created by 박혜운 on 10/4/24.
//

import ComposableArchitecture
import UserInfoPresentation

@Reducer
public struct UserInfoPath {
  
  @ObservableState
  public enum State: Equatable {
    case userSetting(UserSetting.State)
    case changeNickname(ChangeNickname.State)
    case signOut(SignOut.State)
    case signOutConfirm(SignOutConfirm.State)
  }
  
  public enum Action {
    case userSetting(UserSetting.Action)
    case changeNickname(ChangeNickname.Action)
    case signOut(SignOut.Action)
    case signOutConfirm(SignOutConfirm.Action)
  }
  
  public init() {}
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.userSetting, action: \.userSetting) { UserSetting() }
    Scope(state: \.changeNickname, action: \.changeNickname) { ChangeNickname() }
    Scope(state: \.signOut, action: \.signOut) { SignOut() }
    Scope(state: \.signOutConfirm, action: \.signOutConfirm) { SignOutConfirm() }
  }
}


extension UserInfoAppReducer {
  public var pathReducer: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .userInfo(.tabDelegate(.userSetting(id))):
        state.path.append(.userSetting(.init(userId: id)))
        return .none
        
      case let .path(action):
        switch action {
        case .element(id: _, action: .userSetting(.delegate(.toChangeUserNickNameView))):
          state.path.append(.changeNickname(.init()))
          return .none
          
        case let .element(id: _, action: .userSetting(.delegate(.toSignOutView(userId)))):
          state.path.append(.signOut(.init(userId: userId)))
          return .none
          
        case let .element(id: _, action: .signOut(.delegate(.toSignOutConfirmView(userId, selectedOption, userReason)))):
          state.path.append(.signOutConfirm(.init(userId: userId, selectedSignOutOption: selectedOption, userReason: userReason)))
          return .none
          
        case let .element(id: id, action: .userSetting(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
        case .element(id: _, action: .changeNickname(.delegate(.dismiss))):
          state.path.removeLast()
          return .none
          
        case .element(id: _, action: .signOut(.delegate(.dismiss))):
          state.path.removeLast()
          return .none
          
        case .element(id: _, action: .signOutConfirm(.delegate(.dismiss))):
          state.path.removeLast()
          return .none
          
          
        case let .element(id: _, action: .changeNickname(.delegate(.changeNickName(newNickName)))):
          return .send(.userInfo(._changeNickname(newNickName)))
          
        default: return .none
        }
        
      default: return .none
      }
    }
    .forEach(\.path, action: \.path) {
      UserInfoPath()
    }
  }
}
