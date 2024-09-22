//
//  UserInfo+Navigation.swift
//  WINEY
//
//  Created by 박혜운 on 9/16/24.
//

import ComposableArchitecture
import UserInfoData

@Reducer
public struct UserInfoDestination {
  @ObservableState
  public enum State: Equatable {
    case userBadge(UserBadge.State)
    case wineyPolicy(WineyPolicy.State)
  }
  
  public enum Action {
    case userBadge(UserBadge.Action)
    case wineyPolicy(WineyPolicy.Action)
  }
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.userBadge, action: \.userBadge) { UserBadge() }
    Scope(state: \.wineyPolicy, action: \.wineyPolicy) { WineyPolicy() }
  }
}

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
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.userSetting, action: \.userSetting) { UserSetting() }
    Scope(state: \.changeNickname, action: \.changeNickname) { ChangeNickname() }
    Scope(state: \.signOut, action: \.signOut) { SignOut() }
    Scope(state: \.signOutConfirm, action: \.signOutConfirm) { SignOutConfirm() }
  }
}

extension UserInfo {
  
  var destinationReducer: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .userBadgeButtonTapped(id):
        guard let id else { return .none }
        AmplitudeProvider.shared.track(event: .WINEY_BADGE_CLICK)
        state.destination = .userBadge(.init(userId: id))
        return .none
        
      case let .tappedPolicySection(type):
        state.destination = .wineyPolicy(.init(viewType: type))
        return .none
      
      case .destination(.presented(.userBadge(.tappedBackButton))):
        return .send(.destination(.dismiss))
        
      case .destination(.presented(.wineyPolicy(.tappedBackButton))):
        return .send(.destination(.dismiss))
        
      default: return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      UserInfoDestination()
    }
  }
}

extension UserInfo {
  var pathReducer: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
        
      case let .userSettingTapped(userId):
        guard let userId else { return .none }
        state.path.append(.userSetting(.init(userId: userId)))
        return .none
        
      case let .path(action):
        switch action {
          
          // MARK: - .append 진입 로직
        case .element(id: _, action: .userSetting(.delegate(.toChangeUserNickNameView))):
          state.path.append(.changeNickname(.init()))
          return .none
          
        case let .element(id: _, action: .userSetting(.delegate(.toSignOutView(userId)))):
          state.path.append(.signOut(.init(userId: userId)))
          return .none
          
        case let .element(id: _, action: .signOut(.delegate(.toSignOutConfirmView(userId, selectedOption, userReason)))):
          state.path.append(.signOutConfirm(.init(userId: userId, selectedSignOutOption: selectedOption, userReason: userReason)))
          return .none
          
          // MARK: - .remove 삭제 로직
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
          
          // MARK: - delegate 상위 전달 로직
        case .element(id: _, action: .userSetting(.delegate(.logOut))):
          return .send(.delegate(.logout))
          
        case .element(id: _, action: .signOutConfirm(.delegate(.signOut))):
          return .send(.delegate(.signOut))
          
        case let .element(id: _, action: .changeNickname(.delegate(.changeNickName(newNickName)))):
          state.userNickname = newNickName
          return .none
          
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
