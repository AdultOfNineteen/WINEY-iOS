//
//  MainCoordinator.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct MainCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<MainScreenState>]
  
  public init(
    routes: [Route<MainScreenState>] = [
      .root(
        .main(.init()),
        embedInNavigationView: true
      )
    ]
  ){
    self.routes = routes
  }
}

public enum MainCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<MainScreenState>])
  case routeAction(Int, action: MainScreenAction)
}

public struct MainCoordinatorEnvironment {
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

public let mainCoordinatorReducer: Reducer<
  MainCoordinatorState,
  MainCoordinatorAction,
  MainCoordinatorEnvironment
> = mainScreenReducer
  .forEachIndexedRoute(
    environment: {
      MainScreenEnvironment(
        mainQueue: $0.mainQueue,
        userDefaultsService: $0.userDefaultsService
      )
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      return .none 
    }
  )
