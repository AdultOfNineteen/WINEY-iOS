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
  
  public init() {}
  
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
        print("뒤로가기 버튼 누름")
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
  public var pathReducer: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .userSettingTapped(userId):
        guard let userId else { return .none }
        return .send(.tabDelegate(.userSetting(id: userId)))
        
      default: return .none
      }
    }
  }
}
