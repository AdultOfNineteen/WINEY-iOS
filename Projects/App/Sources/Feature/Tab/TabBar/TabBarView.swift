//
//  TabView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct TabBarView: View {
  private let store: StoreOf<TabBar>
  
  public init(store: StoreOf<TabBar>) {
    self.store = store
  }
  
  public var body: some View { // 홈, 노트, 노트모음, 마이페이지 Coordinator
    WithViewStore(store, observe: { $0 }) { viewStore in
      TabBarInfoContainerView(
        selection: viewStore.binding(
          get: { $0.selectedTab },
          send: TabBar.Action.tabSelected
        ), isHidden: viewStore.binding(
          get: { $0.isTabHidden },
          send: TabBar.Action._setTabHiddenStatus
        )
      ) {
        MainCoordinatorView(
          store: store.scope(
            state: \.main,
            action: TabBar.Action.main
          )
        )
        .tabBarItem(
          tab: .main,
          selection: viewStore.binding(
            get: { $0.selectedTab },
            send: TabBar.Action.tabSelected)
        )
        
        MapCoordinatorView(
          store: store.scope(
            state: \.map,
            action: TabBar.Action.map
          )
        )
        .tabBarItem(
          tab: .map,
          selection: viewStore.binding(
            get: { $0.selectedTab },
            send: TabBar.Action.tabSelected)
        )
        
        NoteCoordinatorView(
          store: store.scope(
            state: \.note,
            action: TabBar.Action.note
          )
        )
        .tabBarItem(
          tab: .note,
          selection: viewStore.binding(
            get: { $0.selectedTab },
            send: TabBar.Action.tabSelected)
        )
        
        UserInfoCoordinatorView(
          store: store.scope(
            state: \.userInfo,
            action: TabBar.Action.userInfo
          )
        )
        .tabBarItem(
          tab: .userInfo,
          selection: viewStore.binding(
            get: { $0.selectedTab },
            send: TabBar.Action.tabSelected)
        )
      }
    }
  }
}
