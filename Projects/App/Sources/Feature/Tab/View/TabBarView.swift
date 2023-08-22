//
//  TabView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct TabBarView: View {
  private let store: Store<TabBarState, TabBarAction>
  
  public init(store: Store<TabBarState, TabBarAction>) {
    self.store = store
  }
  
  public var body: some View { // 홈, 노트, 노트모음, 마이페이지 Coordinator
    WithViewStore(store) { viewStore in
      TabView(
        selection: viewStore.binding(
          get: { $0.selectedTab },
          send: TabBarAction.tabSelected)
      ) {
        MainCoordinatorView(
          store: store.scope(
            state: \TabBarState.main,
            action: TabBarAction.main
          )
        )
        .tabItem {
          Text(TabBarItem.main.description)
        }
        .tag(TabBarItem.main)
        
        
        WritingNoteCoordinatorView(
          store: store.scope(
            state: \TabBarState.writingNote,
            action: TabBarAction.writingNote
          )
        )
        .tabItem {
          Text(TabBarItem.writingNote.description)
        }
        .tag(TabBarItem.writingNote)
      }
    }
  }
}
