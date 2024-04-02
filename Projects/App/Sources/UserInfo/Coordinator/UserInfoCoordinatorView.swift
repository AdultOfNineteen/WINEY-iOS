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
        }
      }
    }
  }
}
