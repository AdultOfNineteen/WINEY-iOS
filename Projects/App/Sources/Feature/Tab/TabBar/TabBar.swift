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
    public var main: MainCoordinator.State
    public var map: MapCoordinator.State
    public var note: NoteCoordinator.State
    public var userInfo: UserInfoCoordinator.State
    public var selectedTab: TabBarItem = .main
    public var isTabHidden: Bool = false
    
    public init(
      main: MainCoordinator.State,
      map: MapCoordinator.State,
      note: NoteCoordinator.State,
      userInfo: UserInfoCoordinator.State,
      isTabHidden: Bool
    ) {
      self.main = main
      self.map = map
      self.note = note
      self.userInfo = userInfo
      self.isTabHidden = isTabHidden
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tabSelected(TabBarItem)
    
    // MARK: - Inner Business Action
    case _setTabHiddenStatus(Bool)
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case main(MainCoordinator.Action)
    case map(MapCoordinator.Action)
    case note(NoteCoordinator.Action)
    case userInfo(UserInfoCoordinator.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let.tabSelected(tab):
        state.selectedTab = tab
        
        if tab == .main {
          return .send(.main(.routeAction(0, action: .main(.mainTabTapped))))
        }
        return .none
      case .main:
        return .none
      case .map:
        return .none
      case .note:
        return .none
      case .userInfo:
        return .none
      case ._setTabHiddenStatus(let status):
        state.isTabHidden = status
        return .none
      }
    }
    
    Scope(state: \.main, action: /Action.main) {
      MainCoordinator()
    }
    
    Scope(state: \.map, action: /Action.map) {
      MapCoordinator()
    }
    
    Scope(state: \.note, action: /Action.note) {
      NoteCoordinator()
    }
    
    Scope(state: \.userInfo, action: /Action.userInfo) {
      UserInfoCoordinator()
    }
    
    
  }
}
