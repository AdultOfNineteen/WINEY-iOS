//
//  UserSettingScreen.swift
//  Winey
//
//  Created by 정도현 on 4/2/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct UserSettingScreen: Reducer {
  public enum State: Equatable {
    case settingMain(UserSetting.State)
    case signOut(SignOut.State)
    case signOutConfirm(SignOutConfirm.State)
    case changeNickname(ChangeNickname.State)
  }

  public enum Action {
    case settingMain(UserSetting.Action)
    case signOut(SignOut.Action)
    case signOutConfirm(SignOutConfirm.Action)
    case changeNickname(ChangeNickname.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.settingMain, action: /Action.settingMain) {
      UserSetting()
    }
    Scope(state: /State.signOut, action: /Action.signOut) {
      SignOut()
    }
    Scope(state: /State.signOutConfirm, action: /Action.signOutConfirm) {
      SignOutConfirm()
    }
    Scope(state: /State.changeNickname, action: /Action.changeNickname) {
      ChangeNickname()
    }
  }
}
