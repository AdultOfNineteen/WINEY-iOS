//
//  WineTipCoordinatorView.swift
//  Winey
//
//  Created by 정도현 on 3/31/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Combine
import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct WineTipCoordinatorView: View {
  private let store: StoreOf<WineTipCoordinator>
  
  public init(store: StoreOf<WineTipCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .tipCardList:
          CaseLet(
            /WineTipScreen.State.tipCardList,
            action: WineTipScreen.Action.tipCardList,
            then: TipCardView.init
          )
          
        case .tipCardDetail:
          CaseLet(
            /WineTipScreen.State.tipCardDetail,
            action: WineTipScreen.Action.tipCardDetail,
            then: TipCardDetailView.init
          )
        }
      }
    }
    .navigationBarHidden(true)
  }
}
