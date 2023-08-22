//
//  WritingNoteCoordinatorCore.swift
//  Winey
//
//  Created by 정도현 on 2023/08/22.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct WritingNoteCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<WritingNoteScreenState>]
  
  public init(
    routes: [Route<WritingNoteScreenState>] = [
      .root(
        .writingNote(.init()),
        embedInNavigationView: true
      )
    ]
  ){
    self.routes = routes
  }
}

public enum WritingNoteCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<WritingNoteScreenState>])
  case routeAction(Int, action: WritingNoteScreenAction)
}

public struct WritingNoteCoordinatorEnvironment {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
}

public let writingNoteCoordinatorReducer: Reducer<
  WritingNoteCoordinatorState,
  WritingNoteCoordinatorAction,
  WritingNoteCoordinatorEnvironment
> = writingNoteScreenReducer
  .forEachIndexedRoute(
    environment: {
      WritingNoteScreenEnvironment(
        mainQueue: $0.mainQueue
      )
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      return .none
    }
  )
