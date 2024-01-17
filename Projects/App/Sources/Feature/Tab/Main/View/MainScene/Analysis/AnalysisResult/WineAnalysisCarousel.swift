//
//  WineAnalysisCarouselContainer.swift
//  Winey
//
//  Created by 정도현 on 2023/09/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation
import SwiftUI

public struct WineAnalysisCarousel: Reducer {
  public struct State: Equatable {
    let pageCount: Int = 6
    var pageIndex: Int = 0
    
    var winePieChart: WineAnalysisPieChart.State
    var wineNation: WinePreferNation.State
    var wineCategory: WinePreferCategory.State
    var wineTaste: WinePreferTaste.State
    var wineSmell: WinePreferSmell.State
    var winePrice: WinePrice.State
    
    public init(data: TasteAnalysisDTO) {
      self.winePieChart = WineAnalysisPieChart.State.init(
        wineDrink: data.totalWineCnt,
        repurchase: data.buyAgainCnt, 
        preferWineTypes: data.topThreeTypes
      )
      self.wineNation = WinePreferNation.State.init(
        preferNationList: data.topThreeCountries
      )
      self.wineCategory = WinePreferCategory.State.init(
        preferVarieties: data.topThreeVarieties
      )
      self.wineTaste = WinePreferTaste.State.init(
        preferTastes: data.taste
      )
      self.wineSmell = WinePreferSmell.State.init(
        topSevenSmells: data.topSevenSmells
      )
      self.winePrice = WinePrice.State.init(
        price: data.avgPrice
      )
    }
  }
  
  public enum Action {
    case _viewWillAppear
    // MARK: - User Action
    case dragGesture(DragGesture.Value)
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    case winePieChart(WineAnalysisPieChart.Action)
    case wineNation(WinePreferNation.Action)
    case wineCategory(WinePreferCategory.Action)
    case wineTaste(WinePreferTaste.Action)
    case wineSmell(WinePreferSmell.Action)
    case winePrice(WinePrice.Action)
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._viewWillAppear:
        return .none
        
      case let .dragGesture(gesture):
        let dragThreshold: CGFloat = 50.0
        if gesture.translation.height > dragThreshold {
          state.pageIndex = max(state.pageIndex - 1, 0)
        } else if gesture.translation.height < -dragThreshold {
          state.pageIndex = min(state.pageIndex + 1, state.pageCount - 1)
        }
        return .none
        
      default:
        return .none
      }
    }
    Scope(state: \.winePieChart, action: /Action.winePieChart) {
      WineAnalysisPieChart()
    }
    Scope(state: \.wineNation, action: /Action.wineNation) {
      WinePreferNation()
    }
    Scope(state: \.wineCategory, action: /Action.wineCategory) {
      WinePreferCategory()
    }
    Scope(state: \.wineTaste, action: /Action.wineTaste) {
      WinePreferTaste()
    }
    Scope(state: \.wineSmell, action: /Action.wineSmell) {
      WinePreferSmell()
    }
    Scope(state: \.winePrice, action: /Action.winePrice) {
      WinePrice()
    }
  }
}
