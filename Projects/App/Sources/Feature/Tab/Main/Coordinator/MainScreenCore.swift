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

public enum MainScreenState: Equatable {
  case main(MainState)
}

public enum MainScreenAction {
  case main(MainAction)
}

internal struct MainScreenEnvironment {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  fileprivate let userDefaultsService: UserDefaultsService
  
  internal init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
  }
}

internal let mainScreenReducer =
Reducer<
  MainScreenState,
  MainScreenAction,
  MainScreenEnvironment
>
  .combine([
  mainReducer
    .pullback(
      state: /MainScreenState.main,
      action: /MainScreenAction.main,
      environment: { _ in
        MainEnvironment()
      }
    )
])
