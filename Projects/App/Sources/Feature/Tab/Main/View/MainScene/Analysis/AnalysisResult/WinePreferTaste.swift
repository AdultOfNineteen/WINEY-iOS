//
//  WinePreferTaste.swift
//  Winey
//
//  Created by 정도현 on 2023/09/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import SwiftUI

public struct WinePreferTaste: Reducer {
  public struct State: Equatable {
    
    let title = "선호하는 맛"
    var animation = 0.0
    
    var sweet: CGFloat = 7
    var remain: CGFloat = 2
    var alcohol: CGFloat = 7
    var tannin: CGFloat = 2
    var wineBody: CGFloat = 6
    var acid: CGFloat = 3
    
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
      state.animation = 1.0
      return .none
      
    default:
      return .none
    }
  }
}
