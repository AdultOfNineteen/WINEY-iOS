//
//  UserInfoScreen.swift
//  Winey
//
//  Created by 정도현 on 2023/09/13.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct UserInfoScreen: Reducer {
  public enum State: Equatable {
    case userInfo(UserInfo.State)
    case userBadge(UserBadge.State)
    case userSetting(UserSetting.State)
    case termsPolicy(TermsPolicy.State)
    case personalPolicy(PersonalInfoPolicy.State)
    case nickname(ChangeNickname.State)
    case signOut(SignOut.State)
    case signOutConfirm(SignOutConfirm.State)
  }

  public enum Action {
    case userInfo(UserInfo.Action)
    case userBadge(UserBadge.Action)
    case userSetting(UserSetting.Action)
    case termsPolicy(TermsPolicy.Action)
    case personalPolicy(PersonalInfoPolicy.Action)
    case nickname(ChangeNickname.Action)
    case signOut(SignOut.Action)
    case signOutConfirm(SignOutConfirm.Action)
  }
  
  public init() { }
  
  public var body: some ReducerOf<Self> {
    Scope(
      state: /State.userInfo,
      action: /Action.userInfo
    ) {
      UserInfo()
    }
    Scope(
      state: /State.userBadge,
      action: /Action.userBadge
    ) {
      UserBadge()
    }
    Scope(
      state: /State.userSetting,
      action: /Action.userSetting
    ) {
      UserSetting()
    }
    Scope(
      state: /State.termsPolicy,
      action: /Action.termsPolicy
    ) {
      TermsPolicy()
    }
    Scope(
      state: /State.personalPolicy,
      action: /Action.personalPolicy
    ) {
      PersonalInfoPolicy()
    }
    Scope(
      state: /State.nickname,
      action: /Action.nickname
    ) {
      ChangeNickname()
    }
    Scope(
      state: /State.signOut,
      action: /Action.signOut
    ) {
      SignOut()
    }
    Scope(
      state: /State.signOutConfirm,
      action: /Action.signOutConfirm
    ) {
      SignOutConfirm()
    }
  }
}
