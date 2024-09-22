//
//  WineAnalysisPieChart.swift
//  Winey
//
//  Created by 정도현 on 2023/09/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct WineAnalysisPieChart {
  @ObservableState
  public struct State: Equatable {
    var wineDrink: Int
    var repurchase: Int
    var preferWineTypes: [TopType]
    
    public init(
      wineDrink: Int,
      repurchase: Int,
      preferWineTypes: [TopType]
    ) {
      self.wineDrink = wineDrink
      self.repurchase = repurchase
      self.preferWineTypes = preferWineTypes
    }
  }
  
  public enum Action {
    // MARK: - User Action
    
    // MARK: - Inner Business Action
    case _setPieChartData(TasteAnalysisDTO)
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case let ._setPieChartData(analysisData):
        state.wineDrink = analysisData.totalWineCnt
        state.repurchase = analysisData.buyAgainCnt
        return .none
      }
    }
  }
}
