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

public struct TabBar: Reducer {
  
  public struct State: Equatable {
    //
    //    case main(MainCoordinator.State)
    //    case note(NoteCoordinator.State)
    //    case selectedTab(TabBarItem = .main)
    public var main: MainCoordinator.State
    public var note: NoteCoordinator.State
    public static var selectedTab: TabBarItem = .main
    
    public init(
      main: MainCoordinator.State,
      note: NoteCoordinator.State
    ) {
      self.main = main
      self.note = note
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tabSelected(TabBarItem)
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case main(MainCoordinator.Action)
    case note(NoteCoordinator.Action)
  }
  
  public var body: some ReducerOf<Self> {
    // 🔥
    Scope(state: \.main, action: /Action.main) {
      MainCoordinator()
    }
    
    Scope(state: \.note, action: /Action.note) {
      NoteCoordinator()
    }
  }
}
