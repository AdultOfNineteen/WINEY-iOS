//
//  AppCoordinatorView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct AppCoordinatorView: View {
  let store: StoreOf<AppCoordinator>
  
  public init(store: StoreOf<AppCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .splash:
          CaseLet(
            /AppScreen.State.splash,
            action: AppScreen.Action.splash,
            then: SplashView.init
          )
          
        case .auth:
          CaseLet(
            /AppScreen.State.auth,
            action: AppScreen.Action.auth,
            then: AuthCoordinatorView.init
          )
          
        case .createNote:
          CaseLet(
            /AppScreen.State.createNote,
            action: AppScreen.Action.createNote,
            then: WritingNoteCoordinatorView.init
          )
          
        case .analysis:
          CaseLet(
            /AppScreen.State.analysis,
            action: AppScreen.Action.analysis,
            then: WineAnalysisCoordinatorView.init
          )
          
        case .wineTip:
          CaseLet(
            /AppScreen.State.wineTip,
            action: AppScreen.Action.wineTip,
            then: WineTipCoordinatorView.init
          )
          
        case .recommendWine:
          CaseLet(
            /AppScreen.State.recommendWine,
            action: AppScreen.Action.recommendWine,
            then: RecommendWineCoordinatorView.init
          )
          
        case .noteFilter:
          CaseLet(
            /AppScreen.State.noteFilter,
            action: AppScreen.Action.noteFilter,
            then: FilterDetailView.init
          )
          
        case .userSetting:
          CaseLet(
            /AppScreen.State.userSetting,
            action: AppScreen.Action.userSetting,
            then: UserSettingCoordinatorView.init
          )
          
        case .userBadge:
          CaseLet(
            /AppScreen.State.userBadge,
            action: AppScreen.Action.userBadge,
            then: UserBadgeView.init
          )
          
        case .policy:
          CaseLet(
            /AppScreen.State.policy,
            action: AppScreen.Action.policy,
            then: WineyPolicyView.init
          )
          
        case .tabBar:
          CaseLet(
            /AppScreen.State.tabBar,
            action: AppScreen.Action.tabBar,
            then: TabBarView.init
          )
        }
      }
    }
  }
}
