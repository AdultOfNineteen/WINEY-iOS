//
//  MainCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation

public struct MainState: Equatable {
  var wineCardListState = WineCardListState()
  
  public init() {
    
  }
}

public enum MainAction {
  // MARK: - User Action
  case wineCardListAction(WineCardListAction)
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct MainEnvironment {
  public init() { }
}

public let mainReducer = Reducer.combine([
  Reducer<MainState, MainAction, MainEnvironment> { state, action, env in
    return .none
  }
])
