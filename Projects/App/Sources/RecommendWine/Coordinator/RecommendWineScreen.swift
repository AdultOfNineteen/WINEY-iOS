//
//  RecommendWineScreen.swift
//  Winey
//
//  Created by 정도현 on 3/31/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct RecommendWineScreen: Reducer {
  public enum State: Equatable {
    case wineScroll(WineCardScroll.State)
    case wineDetail(WineDetail.State)
  }

  public enum Action {
    case wineScroll(WineCardScroll.Action)
    case wineDetail(WineDetail.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.wineScroll, action: /Action.wineScroll) {
      WineCardScroll()
    }
    Scope(state: /State.wineDetail, action: /Action.wineDetail) {
      WineDetail()
    }
  }
}
