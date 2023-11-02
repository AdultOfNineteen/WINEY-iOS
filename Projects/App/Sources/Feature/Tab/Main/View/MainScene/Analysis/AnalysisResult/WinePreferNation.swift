//
//  WinePreferNation.swift
//  Winey
//
//  Created by 정도현 on 2023/09/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation

public struct WinePreferNationData: Equatable, Identifiable {
  public var id: Int
  var nationName: String
  var count: Int
}

public struct WinePreferNation: Reducer {
  
  public struct State: Equatable {
    let titleName = "선호 국가"
    let winePreferNationList: IdentifiedArrayOf<WinePreferNationData>
    
    public init(preferNationList: [TopCountry]) {
      winePreferNationList = IdentifiedArrayOf(
        uniqueElements:
          (preferNationList.indices).map {
            WinePreferNationData(
              id: $0,
              nationName: preferNationList[$0].country,
              count: preferNationList[$0].count
            )
          }
      )
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
    case ._onAppear:
      return .none
    default:
      return .none
    }
  }
}
