//
//  TabCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import UserInfoPresentation
import SwiftUI

@Reducer
public struct TabBar {
  
  @ObservableState
  public struct State: Equatable {
    var main: Main.State = .init()
    var map: Map.State = .init()
    var note: Note.State = .init()
    var userInfo: UserInfo.State = .init()
    
    public var path: StackState<TabBarPath.State> = .init()
    
    public var selectedTab: TabBarItem = .main
    public var isTabHidden: Bool = false
    
    public init(
      /// Tab을 클릭했을 때 해당 Tab만 로딩되도록 설정.
      selectedTab: TabBarItem,
      isTabHidden: Bool
    ) {
      self.isTabHidden = isTabHidden
      self.selectedTab = selectedTab
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tabSelected(TabBarItem)
    
    // MARK: - Inner Business Action
    case _setTabHiddenStatus(Bool)
    case _onSetting
    case _loadingTab(TabBarItem)
    case _shareNoteOpen(noteId: Int, isMine: Bool)
    
    // MARK: - Inner SetState Action
    case _mapStreamConnect
    
    // MARK: - Child Action
    case main(Main.Action)
    case map(Map.Action)
    case note(Note.Action)
    case userInfo(UserInfo.Action)
    
    case path(StackAction<TabBarPath.State, TabBarPath.Action>)
    
    // MARK: - Delegate
    case delegate(Delegate)
    
    public enum Delegate {
      case logout
      case signOut
    }
  }
  
  @Dependency(\.tap) var tapService
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.main, action: \.main) { Main() }
    Scope(state: \.map, action: \.map) { Map() }
    Scope(state: \.note, action: \.note) { Note() }
    Scope(state: \.userInfo, action: \.userInfo) { UserInfo() }
    
    pathReducer
    
    Reduce<State, Action> { state, action in
      switch action {
        
      case ._onSetting:
        return .run { send in
          _ = tapService.adaptivePresentationControl()
        }
        
      case let .tabSelected(tab):
        state.selectedTab = tab
        if tab == .map {
          return .concatenate([
            .send(._mapStreamConnect),
            .send(._loadingTab(tab))
          ])
        } else {
          return .send(._loadingTab(tab))
        }
        
      case let ._shareNoteOpen(noteId, isMine):
        return .send(.note(.tabDelegate(.noteDetailShare(noteId: noteId, isMine: isMine))))
        
        //      case ._mapStreamConnect:
        //        return .send(.map(.routeAction(0, action: .map(._tappedMapTabBarItem))))
        //
        //      case .main(.routeAction(_, action: .main(._viewWillAppear))):
        //        return .send(._setTabHiddenStatus(false))
        //
        //      case .map(.routeAction(_, action: .map(._tabBarHidden))):
        //        return .send(._setTabHiddenStatus(true))
        //
        //      case .map(.routeAction(_, action: .map(._tabBarOpen))):
        //        return .send(._setTabHiddenStatus(false))
        
      case .userInfo(.delegate(.logout)):
        return .send(.delegate(.logout))
        
      case .userInfo(.delegate(.signOut)):
        return .send(.delegate(.signOut))
        
      case ._setTabHiddenStatus(let status):
        state.isTabHidden = status
        return .none
        
      default:
        return .none
      }
    }
  }
}
