//
//  UserInfoCoordinatorView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/13.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct UserInfoCoordinatorView: View {
  private let store: StoreOf<UserInfoCoordinator>
  
  public init(store: StoreOf<UserInfoCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .userInfo:
          CaseLet(
            /UserInfoScreen.State.userInfo,
             action: UserInfoScreen.Action.userInfo,
             then: UserInfoView.init
          )
          
        case .userBadge:
          CaseLet(
            /UserInfoScreen.State.userBadge,
             action: UserInfoScreen.Action.userBadge,
             then: UserBadgeView.init
          )
          
        case .userSetting:
          CaseLet(
            /UserInfoScreen.State.userSetting,
             action: UserInfoScreen.Action.userSetting,
             then: UserSettingView.init
          )
          
        case .termsPolicy:
          CaseLet(
            /UserInfoScreen.State.termsPolicy,
             action: UserInfoScreen.Action.termsPolicy,
             then: TermsPolicyView.init
          )
          
        case .personalPolicy:
          CaseLet(
            /UserInfoScreen.State.personalPolicy,
             action: UserInfoScreen.Action.personalPolicy,
             then: PersonalInfoPolicyView.init
          )
          
        case .nickname:
          CaseLet(
            /UserInfoScreen.State.nickname,
             action: UserInfoScreen.Action.nickname,
             then: ChangeNicknameView.init
          )
          
        case .signOut:
          CaseLet(
            /UserInfoScreen.State.signOut,
             action: UserInfoScreen.Action.signOut,
             then: SignOutView.init
          )
          
        case .signOutConfirm:
          CaseLet(
            /UserInfoScreen.State.signOutConfirm,
             action: UserInfoScreen.Action.signOutConfirm,
             then: SignOutConfirmView.init
          )
        }
      }
    }
  }
}
