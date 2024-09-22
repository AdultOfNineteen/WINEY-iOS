//
//  WinePreferSmell.swift
//  Winey
//
//  Created by 정도현 on 2023/09/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct WinePreferSmell {
  
  @ObservableState
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
