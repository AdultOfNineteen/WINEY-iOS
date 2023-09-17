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

public struct WinePreferNation: Equatable {
  var nationName: String
  var count: Int
}

public struct WineAnalysisResult: Reducer {
  public struct State: Equatable {
    let wineRecommend: String = "이탈리아의 프리미티보 품종으로 만든 레드 와인"
    let wineCount: Int = 7
    let wineRepurchase: Int = 5
    let winePreferNation: [WinePreferNation] = [
      WinePreferNation(nationName: "이탈리아", count: 3),
      WinePreferNation(nationName: "미국", count: 1),
      WinePreferNation(nationName: "칠레", count: 1)
    ]
    
    public init(
    ) {
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    case _onAppear
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }

  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .tappedBackButton:
      return .none
    case ._onAppear:
      return .none
    default:
      return .none
    }
  }
}
