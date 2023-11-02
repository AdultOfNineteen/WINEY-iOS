//
//  WinePrice.swift
//  Winey
//
//  Created by 정도현 on 2023/09/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import SwiftUI

public struct WinePrice: Reducer {
  public struct State: Equatable {
    let title = "가격대"
    let secondTitle = "평균 구매가"
    let average: Int
    var opacity = 0.0
    
    public init(price: Int) {
      self.average = price
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
      state.opacity = 1.0
      return .none
      
    default:
      return .none
    }
  }
}
