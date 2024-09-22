//
//  WinePrice.swift
//  Winey
//
//  Created by 정도현 on 2023/09/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct WinePrice {
  
  @ObservableState
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
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._onAppear:
        state.opacity = 1.0
        return .none
      }
    }
  }
}
