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
    @PresentationState var main: MainCoordinator.State?
    @PresentationState var map: MapCoordinator.State?
    @PresentationState var note: NoteCoordinator.State?
    @PresentationState var userInfo: UserInfoCoordinator.State?
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
    case main(PresentationAction<MainCoordinator.Action>)
    case map(PresentationAction<MapCoordinator.Action>)
    case note(PresentationAction<NoteCoordinator.Action>)
    case userInfo(PresentationAction<UserInfoCoordinator.Action>)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let.tabSelected(tab):
        state.selectedTab = tab
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
    .ifLet(\.$main, action: /Action.main) {
      MainCoordinator()
    }
    .ifLet(\.$map, action: /Action.map) {
      MapCoordinator()
    }
    .ifLet(\.$note, action: /Action.note) {
      NoteCoordinator()
    }
    .ifLet(\.$userInfo, action: /Action.userInfo) {
      UserInfoCoordinator()
    }
  }
}
