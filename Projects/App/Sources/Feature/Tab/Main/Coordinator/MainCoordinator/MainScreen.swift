//
//  MainScreenCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct MainScreen: Reducer {
  public enum State: Equatable {
    case main(Main.State)
  }

  public enum Action {
    case main(Main.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.main, action: /Action.main) {
      Main()
    }
  }
}
