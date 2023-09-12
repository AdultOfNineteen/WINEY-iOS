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
      TabView(
        selection: viewStore.binding(
          get: { _ in TabBar.State.selectedTab },
          send: TabBar.Action.tabSelected)
      ) {
        MainCoordinatorView(
          store: store.scope(
            state: \.main,
            action: TabBar.Action.main
          )
        )
        .tabItem {
          Text(TabBarItem.main.description)
            .wineyFont(.captionB1)
          TabBarItem.main.icon
        }
        .tag(TabBarItem.main)
        
        
        NoteCoordinatorView(
          store: store.scope(
            state: \.note,
            action: TabBar.Action.note
          )
        )
        .tabItem {
          Text(TabBarItem.note.description)
          TabBarItem.note.icon
        }
        
      }
    }
  }
}
