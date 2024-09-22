//
//  WinePreferCategory.swift
//  Winey
//
//  Created by 정도현 on 2023/09/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct WinePreferCategory {
  
  @ObservableState
  public struct State: Equatable {
    let title = "선호 품종"
    let wines: [WineRankData]
    
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
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      default: return .none
      }
    }
  }
}
