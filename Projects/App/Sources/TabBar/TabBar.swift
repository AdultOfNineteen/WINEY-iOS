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
    var main: MainCoordinator.State?
    var map: MapCoordinator.State?
    var note: NoteCoordinator.State?
    var userInfo: UserInfoCoordinator.State?

    public var selectedTab: TabBarItem = .main
    public var isTabHidden: Bool = false
    
    public init(
      /// Tab을 클릭했을 때 해당 Tab만 로딩되도록 설정.
      selectedTab: TabBarItem,
      isTabHidden: Bool
    ) {
      self.isTabHidden = isTabHidden
      self.selectedTab = selectedTab
      
      switch selectedTab {
      case .main:
        self.main = .init()
      case .map:
        self.map = .init()
      case .note:
        self.note = .init()
      case .userInfo:
        self.userInfo = .init()
      }
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tabSelected(TabBarItem)
    
    // MARK: - Inner Business Action
    case _setTabHiddenStatus(Bool)
    case _onSetting
    case _loadingTab(TabBarItem)
    
    // MARK: - Inner SetState Action
    case _mapStreamConnect
    
    // MARK: - Child Action
    case main(MainCoordinator.Action)
    case map(MapCoordinator.Action)
    case note(NoteCoordinator.Action)
    case userInfo(UserInfoCoordinator.Action)
  }
  
  @Dependency(\.tap) var tapService
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case ._onSetting:
        return .run { send in
          _ = tapService.adaptivePresentationControl()
        }
        
      case let .tabSelected(tab):
        if tab == .map {
          return .concatenate([
            .send(._mapStreamConnect),
            .send(._loadingTab(tab))
          ])
        } else {
          return .send(._loadingTab(tab))
        }
      
      case ._mapStreamConnect:
        return .send(.map(.routeAction(0, action: .map(._tappedMapTabBarItem))))
        
      case .main(.routeAction(_, action: .main(._viewWillAppear))):
        return .send(._setTabHiddenStatus(false))
        
      case .map(.routeAction(_, action: .map(._tabBarHidden))):
        return .send(._setTabHiddenStatus(true))
        
      case .map(.routeAction(_, action: .map(._tabBarOpen))):
        return .send(._setTabHiddenStatus(false))
        
      case ._setTabHiddenStatus(let status):
        state.isTabHidden = status
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.main, action: /Action.main) {
      MainCoordinator()
    }
    .ifLet(\.map, action: /Action.map) {
      MapCoordinator()
    }
    .ifLet(\.note, action: /Action.note) {
      NoteCoordinator()
    }
    .ifLet(\.userInfo, action: /Action.userInfo) {
      UserInfoCoordinator()
    }
  }
}
