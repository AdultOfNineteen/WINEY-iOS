//
//  TabCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

public struct TabBarState: Equatable {
  public var main: MainCoordinatorState
  
  public init(
    main: MainCoordinatorState
  ) {
    self.main = main
  }
}

public enum TabBarAction {
  // MARK: - User Action
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
  case main(MainCoordinatorAction)
  
}

public struct TabBarEnvironment {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  fileprivate let userDefaultsService: UserDefaultsService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
  }
  
}

public let tabBarReducer = Reducer<
  TabBarState,
  TabBarAction,
  TabBarEnvironment
>.combine([
  mainCoordinatorReducer
    .pullback(
      state: \TabBarState.main,
      action: /TabBarAction.main,
      environment: {
        MainCoordinatorEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: $0.userDefaultsService
        )
      }
    )
])
