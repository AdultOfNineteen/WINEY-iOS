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
        return .none
        
      case .main(
        .routeAction(
          _, action: .main(._navigateToAnalysis)
        )
      ):
        return .send(._setTabHiddenStatus(true))
        
      case .main(.routeAction(_, action: .main(.wineCardScroll(.wineCard(id: _, action: _))))):
        return .send(._setTabHiddenStatus(true))
        
      case .main(.routeAction(_, action: .main(._navigateToTipCard))):
        return .send(._setTabHiddenStatus(true))
        
      case .main(.routeAction(_, action: .tipCard(.tappedBackButton))):
        return .send(._setTabHiddenStatus(false))
        
      case .main(.routeAction(_, action: .analysis(.routeAction(_, action: .wineAnaylsis(.tappedBackButton))))):
        return .send(._setTabHiddenStatus(false))
        
      case .main(.routeAction(_, action: .wineDetail(.tappedBackButton))):
        return .send(._setTabHiddenStatus(false))
        
      case .map:
        return .none
        
      case .note:
        return .none
        
      case .userInfo:
        return .none
        
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
