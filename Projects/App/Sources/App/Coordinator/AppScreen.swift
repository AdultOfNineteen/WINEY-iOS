//
//  AppScreenCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct AppScreen: Reducer {
  public enum State: Equatable {
    case splash(Splash.State)
    case auth(AuthCoordinator.State)
    case createNote(WritingNoteCoordinator.State)
    case analysis(WineAnalysisCoordinator.State)
    case wineTip(WineTipCoordinator.State)
    case recommendWine(RecommendWineCoordinator.State)
    case noteFilter(FilterDetail.State)
    case noteDetail(NoteDetail.State)
    case userSetting(UserSettingCoordinator.State)
    case userBadge(UserBadge.State)
    case policy(WineyPolicy.State)
    case tabBar(TabBar.State)
    case twoSectionSheet(TwoSectionBottomSheet.State)
    case noteRemoveBottomSheet(NoteRemoveBottomSheet.State)
  }

  public enum Action {
    case splash(Splash.Action)
    case auth(AuthCoordinator.Action)
    case createNote(WritingNoteCoordinator.Action)
    case analysis(WineAnalysisCoordinator.Action)
    case wineTip(WineTipCoordinator.Action)
    case recommendWine(RecommendWineCoordinator.Action)
    case noteDetail(NoteDetail.Action)
    case noteFilter(FilterDetail.Action)
    case userSetting(UserSettingCoordinator.Action)
    case userBadge(UserBadge.Action)
    case policy(WineyPolicy.Action)
    case tabBar(TabBar.Action)
    case twoSectionSheet(TwoSectionBottomSheet.Action)
    case noteRemoveBottomSheet(NoteRemoveBottomSheet.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.splash, action: /Action.splash) {
      Splash()
    }
    Scope(state: /State.auth, action: /Action.auth) {
      AuthCoordinator()
    }
    Scope(state: /State.createNote, action: /Action.createNote) {
      WritingNoteCoordinator()
    }
    Scope(state: /State.analysis, action: /Action.analysis) {
      WineAnalysisCoordinator()
    }
    Scope(state: /State.wineTip, action: /Action.wineTip) {
      WineTipCoordinator()
    }
    Scope(state: /State.recommendWine, action: /Action.recommendWine) {
      RecommendWineCoordinator()
    }
    Scope(state: /State.noteFilter, action: /Action.noteFilter) {
      FilterDetail()
    }
    Scope(state: /State.noteDetail, action: /Action.noteDetail) {
      NoteDetail()
    }
    Scope(state: /State.userSetting, action: /Action.userSetting) {
      UserSettingCoordinator()
    }
    Scope(state: /State.userBadge, action: /Action.userBadge) {
      UserBadge()
    }
    Scope(state: /State.policy, action: /Action.policy) {
      WineyPolicy()
    }
    Scope(state: /State.tabBar, action: /Action.tabBar) {
      TabBar()
    }
    Scope(state: /State.twoSectionSheet, action: /Action.twoSectionSheet) {
      TwoSectionBottomSheet()
    }
    Scope(state: /State.noteRemoveBottomSheet, action: /Action.noteRemoveBottomSheet) {
      NoteRemoveBottomSheet()
    }
  }
}
