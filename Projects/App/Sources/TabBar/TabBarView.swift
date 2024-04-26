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
        IfLetStore(
          self.store.scope(
            state: \.main,
            action: TabBar.Action.main
          )
        ) {
          MainCoordinatorView(store: $0)
        }
        .tabBarItem(
          tab: .main,
          selection: viewStore.binding(
            get: { $0.selectedTab },
            send: TabBar.Action.tabSelected)
        )
        
        IfLetStore(
          self.store.scope(
            state: \.map,
            action: TabBar.Action.map
          )
        ) {
          MapCoordinatorView(store: $0)
        }
        .tabBarItem(
          tab: .map,
          selection: viewStore.binding(
            get: { $0.selectedTab },
            send: TabBar.Action.tabSelected)
        )
        
        IfLetStore(
          self.store.scope(
            state: \.note,
            action: TabBar.Action.note
          )
        ) {
          NoteCoordinatorView(store: $0)
        }
        .tabBarItem(
          tab: .note,
          selection: viewStore.binding(
            get: { $0.selectedTab },
            send: TabBar.Action.tabSelected)
        )
        
        IfLetStore(
          self.store.scope(
            state: \.userInfo,
            action: TabBar.Action.userInfo
          )
        ) {
          UserInfoCoordinatorView(store: $0)
        }
        .tabBarItem(
          tab: .userInfo,
          selection: viewStore.binding(
            get: { $0.selectedTab },
            send: TabBar.Action.tabSelected)
        )
      }
    }
    .task {
      store.send(._onSetting)
    }
    .navigationBarHidden(true)
  }
}
