//
//  RecommendWineCoordinatorView.swift
//  Winey
//
//  Created by 정도현 on 3/31/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Combine
import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct RecommendWineCoordinatorView: View {
  private let store: StoreOf<RecommendWineCoordinator>
  
  public init(store: StoreOf<RecommendWineCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .wineScroll:
          CaseLet(
            /RecommendWineScreen.State.wineScroll,
            action: RecommendWineScreen.Action.wineScroll,
            then: WineCardScrollView.init
          )
          
        case .wineDetail:
          CaseLet(
            /RecommendWineScreen.State.wineDetail,
            action: RecommendWineScreen.Action.wineDetail,
            then: WineDetailView.init
          )
        }
      }
    }
    .navigationBarHidden(true)
  }
}
