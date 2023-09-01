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

public struct NoteCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<NoteScreenState>]
  
  public init(
    routes: [Route<NoteScreenState>] = [
      .root(
        .note(.init()),
        embedInNavigationView: true
      )
    ]
  ){
    self.routes = routes
  }
}

public enum NoteCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<NoteScreenState>])
  case routeAction(Int, action: NoteScreenAction)
}

public struct NoteCoordinatorEnvironment {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
}

public let noteCoordinatorReducer: Reducer<
  NoteCoordinatorState,
  NoteCoordinatorAction,
 NoteCoordinatorEnvironment
> = noteScreenReducer
  .forEachIndexedRoute(
    environment: {
      NoteScreenEnvironment(
        mainQueue: $0.mainQueue
      )
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      return .none
    }
  )
