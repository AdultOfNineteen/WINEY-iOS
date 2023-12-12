//
//  WritingNoteCoordinatorView.swift
//  Winey
//
//  Created by 정도현 on 11/30/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import Combine
import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct WritingNoteCoordinatorView: View {
  private let store: StoreOf<WritingNoteCoordinator>
  
  public init(store: StoreOf<WritingNoteCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .wineSearch:
          CaseLet(
            /WritingNoteScreen.State.wineSearch,
             action: WritingNoteScreen.Action.wineSearch,
             then: WineSearchView.init
          )
          
        case .setAlcohol:
          CaseLet(
            /WritingNoteScreen.State.setAlcohol,
             action: WritingNoteScreen.Action.setAlcohol,
             then: SettingAlcoholView.init
          )
          
        case .setVintage:
          CaseLet(
            /WritingNoteScreen.State.setVintage,
             action: WritingNoteScreen.Action.setVintage,
             then: SettingVintageView.init
          )
          
        case .setColorSmell:
          CaseLet(
            /WritingNoteScreen.State.setColorSmell,
             action: WritingNoteScreen.Action.setColorSmell,
             then: SettingColorSmellView.init
          )
          
        case .setTaste:
          CaseLet(
            /WritingNoteScreen.State.setTaste,
             action: WritingNoteScreen.Action.setTaste,
             then: SettingTasteView.init
          )
          
        case .helpTaste:
          CaseLet(
            /WritingNoteScreen.State.helpTaste,
             action: WritingNoteScreen.Action.helpTaste,
             then: HelpTasteView.init
          )
          
        case .setMemo:
          CaseLet(
            /WritingNoteScreen.State.setMemo,
             action: WritingNoteScreen.Action.setMemo,
             then: SettingMemoView.init
          )
          
        case .noteDone:
          CaseLet(
            /WritingNoteScreen.State.noteDone,
             action: WritingNoteScreen.Action.noteDone,
             then: NoteDoneView.init
          )
        }
      }
    }
    .navigationBarHidden(true)
  }
}
