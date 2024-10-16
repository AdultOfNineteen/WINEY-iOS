//
//  WineAnalysisCarouselContainer.swift
//  Winey
//
//  Created by 정도현 on 2023/09/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct WineAnalysisCarousel {
  
  @ObservableState
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
        preferTastes: data.taste, isSparkling: data.recommendWineType == WineType.sparkl.rawValue
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
    // MARK: - User Action
    case dragGesture(DragGesture.Value)
    case tappedArrow
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    case _setPage(index: Int)
    
    // MARK: - Child Action
    case winePieChart(WineAnalysisPieChart.Action)
    case wineNation(WinePreferNation.Action)
    case wineCategory(WinePreferCategory.Action)
    case wineTaste(WinePreferTaste.Action)
    case wineSmell(WinePreferSmell.Action)
    case winePrice(WinePrice.Action)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .dragGesture(gesture):
        let dragThreshold: CGFloat = 50.0
        if gesture.translation.height > dragThreshold {
          state.pageIndex = max(state.pageIndex - 1, 0)
        } else if gesture.translation.height < -dragThreshold {
          state.pageIndex = min(state.pageIndex + 1, state.pageCount - 1)
        }
        return .none
        
      case .tappedArrow:
        let curPageIndex = state.pageIndex
        if curPageIndex < state.pageCount - 1 {
          return .send(._setPage(index: curPageIndex + 1))
        } else {
          return .send(._setPage(index: 0))
        }
        
      case ._setPage(let index):
        state.pageIndex = index
        return .none
        
      default:
        return .none
      }
    }
    Scope(state: \.winePieChart, action: \.winePieChart) {
      WineAnalysisPieChart()
    }
    Scope(state: \.wineNation, action: \.wineNation) {
      WinePreferNation()
    }
    Scope(state: \.wineCategory, action: \.wineCategory) {
      WinePreferCategory()
    }
    Scope(state: \.wineTaste, action: \.wineTaste) {
      WinePreferTaste()
    }
    Scope(state: \.wineSmell, action: \.wineSmell) {
      WinePreferSmell()
    }
    Scope(state: \.winePrice, action: \.winePrice) {
      WinePrice()
    }
  }
}
