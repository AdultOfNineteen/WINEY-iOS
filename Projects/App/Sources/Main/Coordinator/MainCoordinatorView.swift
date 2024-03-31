//
//  MainCoordinatorView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct MainCoordinatorView: View {
  private let store: StoreOf<MainCoordinator>
  
  public init(store: StoreOf<MainCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .main:
          CaseLet(
            /MainScreen.State.main,
            action: MainScreen.Action.main,
            then: MainView.init
          )
          
        case .wineDetail:
          CaseLet(
            /MainScreen.State.wineDetail,
            action: MainScreen.Action.wineDetail,
            then: WineDetailView.init
          )
          
        case .tipCard:
          CaseLet(
            /MainScreen.State.tipCard,
            action: MainScreen.Action.tipCard,
            then: TipCardView.init
          )
          
        case .tipCardDetail:
          CaseLet(
            /MainScreen.State.tipCardDetail,
            action: MainScreen.Action.tipCardDetail,
            then: TipCardDetailView.init
          )
        }
      }
      .navigationBarHidden(true)
    }
  }
}
