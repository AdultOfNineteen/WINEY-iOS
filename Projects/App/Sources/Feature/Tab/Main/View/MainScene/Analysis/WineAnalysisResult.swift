//
//  WineAnalysisResult.swift
//  Winey
//
//  Created by 정도현 on 2023/09/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation



public struct WineAnalysisResult: Reducer {
  public struct State: Equatable {
    let wineRecommend: String = "이탈리아의 프리미티보 품종으로 만든 레드 와인"
    let wineCount: Int = 7
    let wineRepurchase: Int = 5
    
    var carouselList = WineAnalysisCarousel.State.init()
    
    public init(
    ) {
      
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case carousel(WineAnalysisCarousel.Action)
  }

  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .carousel:
        return .none
      case .tappedBackButton:
        return .none
      case ._viewWillAppear:
        return .none
      default:
        return .none
      }
    }
    
    Scope(state: \.carouselList, action: /Action.carousel) {
      WineAnalysisCarousel()
    }
  }
}
