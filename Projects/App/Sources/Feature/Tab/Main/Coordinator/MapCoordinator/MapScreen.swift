//
//  MapScreen.swift
//  Winey
//
//  Created by 정도현 on 2023/09/13.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct MapScreen: Reducer {
  public enum State: Equatable {
    case map(Map.State)
  }

  public enum Action {
    case map(Map.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.map, action: /Action.map) {
      Map()
    }
  }
}
