//
//  WinePreferSmell.swift
//  Winey
//
//  Created by 정도현 on 2023/09/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import SwiftUI

public struct WinePreferSmell: Reducer {
  public struct State: Equatable {
    let title = "선호하는 향"
    let secondTitle = "평균 구매가"
    var topSevenSmells: [TopSmell] = []
    var opacity = 0.0
    
    public init(topSevenSmells: [TopSmell]) {
      self.topSevenSmells = topSevenSmells
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
    }
  }
}
