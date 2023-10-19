//
//  WinePreferCategory.swift
//  Winey
//
//  Created by 정도현 on 2023/09/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import SwiftUI

public struct WinePreferCategory: Reducer {
  public struct State: Equatable {
    
    let title = "선호 품종"
    let wines: [WineRankData] 
    
//    [
//      WineRankData(id: 1, rank: .rank1, wineName: "프리미티보", percentage: 74),
//      WineRankData(id: 2, rank: .rank2, wineName: "메들로", percentage: 12),
//      WineRankData(id: 3, rank: .rank3, wineName: "까르베네 소비뇽", percentage: 6)
//    ]
    
    public init(preferVarieties: [TopVarietal]) {
      wines = (preferVarieties.indices).map {
        WineRankData(
          id: $0,
          rank: WineRank(rawValue: $0 + 1) ?? .rank1,
          wineName: preferVarieties[$0].varietal,
          percentage: preferVarieties[$0].percent
        )
      }
    }
  }
  
  public enum Action {
    // MARK: - User Action
    
    // MARK: - Inner Business Action
    case _onAppear
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    default:
      return .none
    }
  }
}
