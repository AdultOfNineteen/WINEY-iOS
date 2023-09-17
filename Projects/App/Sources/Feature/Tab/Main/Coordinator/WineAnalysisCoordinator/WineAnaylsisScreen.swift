//
//  WineAnaylsis.swift
//  Winey
//
//  Created by 정도현 on 2023/09/16.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct WineAnalysisScreen: Reducer {
  public enum State: Equatable {
    case wineAnalysis(WineAnalysis.State)
    case loading(WineAnalysisLoading.State)
    case result(WineAnalysisResult.State)
  }

  public enum Action {
    case wineAnaylsis(WineAnalysis.Action)
    case loading(WineAnalysisLoading.Action)
    case result(WineAnalysisResult.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.wineAnalysis, action: /Action.wineAnaylsis) {
      WineAnalysis()
    }
    Scope(state: /State.loading, action: /Action.loading) {
      WineAnalysisLoading()
    }
    Scope(state: /State.result, action: /Action.result) {
      WineAnalysisResult()
    }
  }
}
