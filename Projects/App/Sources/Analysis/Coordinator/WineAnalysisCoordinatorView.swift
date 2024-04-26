//
//  WineAnalysisCoordinatorView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/16.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct WineAnalysisCoordinatorView: View {
  private let store: StoreOf<WineAnalysisCoordinator>
  
  public init(store: StoreOf<WineAnalysisCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .wineAnalysis:
          CaseLet(
            /WineAnalysisScreen.State.wineAnalysis,
            action: WineAnalysisScreen.Action.wineAnaylsis,
            then: WineAnalysisView.init
          )
        case .loading:
          CaseLet(
            /WineAnalysisScreen.State.loading,
            action: WineAnalysisScreen.Action.loading,
            then: WineAnalysisLoadingView.init
          )
        case .result:
          CaseLet(
            /WineAnalysisScreen.State.result,
            action: WineAnalysisScreen.Action.result,
            then: WineAnalysisResultView.init
          )
        }
      }
    }
    .navigationBarHidden(true)
  }
}
