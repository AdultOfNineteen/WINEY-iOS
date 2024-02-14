//
//  WritingNoteScreen.swift
//  Winey
//
//  Created by 정도현 on 11/30/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct WritingNoteScreen: Reducer {
  public enum State: Equatable {
    case wineSearch(WineSearch.State)
    case wineConfirm(WineConfirm.State)
    case setAlcohol(SettingAlcohol.State)
    case setVintage(SettingVintage.State)
    case setColorSmell(SettingColorSmell.State)
    case helpSmell(HelpSmell.State)
    case setTaste(SettingTaste.State)
    case helpTaste(HelpTaste.State)
    case setMemo(SettingMemo.State)
    case noteDone(NoteDone.State)
  }

  public enum Action {
    case wineSearch(WineSearch.Action)
    case wineConfirm(WineConfirm.Action)
    case setAlcohol(SettingAlcohol.Action)
    case setVintage(SettingVintage.Action)
    case setColorSmell(SettingColorSmell.Action)
    case helpSmell(HelpSmell.Action)
    case setTaste(SettingTaste.Action)
    case helpTaste(HelpTaste.Action)
    case setMemo(SettingMemo.Action)
    case noteDone(NoteDone.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.wineSearch, action: /Action.wineSearch) {
      WineSearch()
    }
    
    Scope(state: /State.wineConfirm, action: /Action.wineConfirm) {
      WineConfirm()
    }
    
    Scope(state: /State.setAlcohol, action: /Action.setAlcohol) {
      SettingAlcohol()
    }
    
    Scope(state: /State.setVintage, action: /Action.setVintage) {
      SettingVintage()
    }
    
    Scope(state: /State.setColorSmell, action: /Action.setColorSmell) {
      SettingColorSmell()
    }
    
    Scope(state: /State.helpSmell, action: /Action.helpSmell) {
      HelpSmell()
    }
    
    Scope(state: /State.setTaste, action: /Action.setTaste) {
      SettingTaste()
    }
    
    Scope(state: /State.helpTaste, action: /Action.helpTaste) {
      HelpTaste()
    }
    
    Scope(state: /State.setMemo, action: /Action.setMemo) {
      SettingMemo()
    }
    
    Scope(state: /State.noteDone, action: /Action.noteDone) {
      NoteDone()
    }
  }
}
