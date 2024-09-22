//
//  TabView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import UserInfoPresentation
import SwiftUI
import WineyKit

public struct TabBarView: View {
  let store: StoreOf<TabBar>
  
  public init(store: StoreOf<TabBar>) { self.store = store }
  
  public var body: some View { // 홈, 노트, 노트모음, 마이페이지 Coordinator
    NavigationStack {
      TabBarInfoContainerView(
        selection: .init(
          get: { store.selectedTab },
          set: { isSelected in store.send(.tabSelected(isSelected))}
        ), isHidden: .init(
          get: { store.isTabHidden },
          set: { isBool in store.send( ._setTabHiddenStatus(isBool) )}
        )
      ) {
        switch store.selectedTab {
        case .main:
          let mainStore = store.scope(state: \.main, action: \.main)
          MainView(store: mainStore)
            .tabBarItem(
              tab: .main,
              selection: .init(
                get: { store.selectedTab },
                set: { tabSelect in store.send(.tabSelected(tabSelect)) }
              )
            )
            
        case .map:
          let mapStore = store.scope(state: \.map, action: \.map)
          MapView(store: mapStore)
            .tabBarItem(
              tab: .map,
              selection: .init(
                get: { store.selectedTab },
                set: { tabSelect in store.send(.tabSelected(tabSelect)) }
              )
            )
        case .note:
          let noteStore = store.scope(state: \.note, action: \.note)
          NoteView(store: noteStore)
            .tabBarItem(
              tab: .note,
              selection: .init(
                get: { store.selectedTab },
                set: { tabSelect in store.send(.tabSelected(tabSelect)) }
              )
            )
        case .userInfo:
          let userInfoStore = store.scope(state: \.userInfo, action: \.userInfo)
          UserInfoView(store: userInfoStore)
            .tabBarItem(
              tab: .userInfo,
              selection: .init(
                get: { store.selectedTab },
                set: { tabSelect in store.send(.tabSelected(tabSelect)) }
              )
            )
        }
      }
    }
    .onOpenURL { url in
      print("공유 링크 타고 들어옴")
    }
    .task {
      store.send(._onSetting)
    }
    .navigationBarHidden(true)
  }
}
