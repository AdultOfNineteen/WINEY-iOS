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
  @Bindable var store: StoreOf<TabBar>
  
  public init(store: StoreOf<TabBar>) { self.store = store }
  
  public var body: some View { // 홈, 노트, 노트모음, 마이페이지 Coordinator
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
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
      .onOpenURL { url in
        print("공유 링크 타고 들어옴")
      }
      .task {
        store.send(._onSetting)
      }
      .navigationBarHidden(true)
    } destination: { store in
      switch store.state {
        // MARK: - Analysis
      case .analysis:
        if let store = store.scope(state: \.analysis, action: \.analysis) {
          WineAnalysisView(store: store)
        }
      case .loading:
        if let store = store.scope(state: \.loading, action: \.loading) {
          WineAnalysisLoadingView(store: store)
        }
      case .result:
        if let store = store.scope(state: \.result, action: \.result) {
          WineAnalysisResultView(store: store)
        }
        
        // MARK: - Main
      case .detailWine:
        if let store = store.scope(state: \.detailWine, action: \.detailWine) {
          WineDetailView(store: store)
        }
      case .tipCardList:
        if let store = store.scope(state: \.tipCardList, action: \.tipCardList) {
          TipCardListView(store: store)
        }
      case .tipDetail:
        if let store = store.scope(state: \.tipDetail, action: \.tipDetail) {
          TipCardDetailView(store: store)
        }
        
        // MARK: - NoteMain
      case .noteDetail:
        if let store = store.scope(state: \.noteDetail, action: \.noteDetail) {
          NoteDetailView(store: store)
        }
        
        // MARK: - Create/Edit Note
      case .wineSearch:
        if let store = store.scope(state: \.wineSearch, action: \.wineSearch) {
          WineSearchView.init(store: store)
        }
      case .wineConfirm:
        if let store = store.scope(state: \.wineConfirm, action: \.wineConfirm) {
          WineConfirmView.init(store: store)
        }
      case .setAlcohol:
        if let store = store.scope(state: \.setAlcohol, action: \.setAlcohol) {
          SettingAlcoholView.init(store: store)
        }
      case .setVintage:
        if let store = store.scope(state: \.setVintage, action: \.setVintage) {
          SettingVintageView.init(store: store)
        }
      case .setColorSmell:
        if let store = store.scope(state: \.setColorSmell, action: \.setColorSmell) {
          SettingColorSmellView.init(store: store)
        }
      case .helpSmell:
        if let store = store.scope(state: \.helpSmell, action: \.helpSmell) {
          HelpSmellView.init(store: store)
        }
      case .setTaste:
        if let store = store.scope(state: \.setTaste, action: \.setTaste) {
          SettingTasteView.init(store: store)
        }
      case .helpTaste:
        if let store = store.scope(state: \.helpTaste, action: \.helpTaste) {
          HelpTasteView.init(store: store)
        }
      case .setMemo:
        if let store = store.scope(state: \.setMemo, action: \.setMemo) {
          SettingMemoView.init(store: store)
        }
      case .noteDone:
        if let store = store.scope(state: \.noteDone, action: \.noteDone) {
          NoteDoneView.init(store: store)
        }
        
      // MARK: - UserInfo
      case .userSetting:
        if let store = store.scope(state: \.userSetting, action: \.userSetting) {
          UserSettingView(store: store)
        }
      case .changeNickname:
        if let store = store.scope(state: \.changeNickname, action: \.changeNickname) {
          ChangeNicknameView(store: store)
        }
      case .signOut:
        if let store = store.scope(state: \.signOut, action: \.signOut) {
          SignOutView(store: store)
        }
        
      case .signOutConfirm:
        if let store = store.scope(state: \.signOutConfirm, action: \.signOutConfirm) {
          SignOutConfirmView(store: store)
        }
      }
    }
  }
}
