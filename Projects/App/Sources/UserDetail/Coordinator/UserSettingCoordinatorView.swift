//
//  UserSettingCoordinatorView.swift
//  Winey
//
//  Created by 정도현 on 4/2/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Combine
import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct UserSettingCoordinatorView: View {
  private let store: StoreOf<UserSettingCoordinator>
  
  public init(store: StoreOf<UserSettingCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .settingMain:
          CaseLet(
            /UserSettingScreen.State.settingMain,
            action: UserSettingScreen.Action.settingMain,
            then: UserSettingView.init
          )
          
        case .changeNickname:
          CaseLet(
            /UserSettingScreen.State.changeNickname,
            action: UserSettingScreen.Action.changeNickname,
            then: ChangeNicknameView.init
          )
        
        case .signOut:
          CaseLet(
            /UserSettingScreen.State.signOut,
            action: UserSettingScreen.Action.signOut,
            then: SignOutView.init
          )
          
        case .signOutConfirm:
          CaseLet(
            /UserSettingScreen.State.signOutConfirm,
            action: UserSettingScreen.Action.signOutConfirm,
            then: SignOutConfirmView.init
          )
        }
      }
    }
    .navigationBarHidden(true)
  }
}
