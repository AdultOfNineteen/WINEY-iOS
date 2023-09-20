//
//  WineAnalysisPieChart.swift
//  Winey
//
//  Created by 정도현 on 2023/09/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation


public struct WineAnalysisPieChart: Reducer {
  public struct State: Equatable {
    let wineDrink: Int = 7
    let repurchase: Int = 5
    
    public init() { }
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
