//
//  MainScreenCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct MainScreen: Reducer {
  public enum State: Equatable {
    case main(Main.State)
    case wineDetail(WineDetail.State)
    case tipCard(TipCard.State)
    case tipCardDetail(TipCardDetail.State)
    case analysis(WineAnalysisCoordinator.State)
  }

  public enum Action {
    case main(Main.Action)
    case wineDetail(WineDetail.Action)
    case tipCard(TipCard.Action)
    case tipCardDetail(TipCardDetail.Action)
    case analysis(WineAnalysisCoordinator.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.main, action: /Action.main) {
      Main()
    }
    
    Scope(state: /State.wineDetail, action: /Action.wineDetail) {
      WineDetail()
    }
    
    Scope(state: /State.tipCard, action: /Action.tipCard) {
      TipCard()
    }
    
    Scope(state: /State.tipCardDetail, action: /Action.tipCardDetail) {
      TipCardDetail()
    }
    
    Scope(state: /State.analysis, action: /Action.analysis) {
      WineAnalysisCoordinator()
    }
  }
}
