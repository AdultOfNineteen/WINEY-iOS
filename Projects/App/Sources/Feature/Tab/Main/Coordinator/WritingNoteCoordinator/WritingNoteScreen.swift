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
    case setAlcohol(SettingAlcohol.State)
    case setVintage(SettingVintage.State)
    case setColorSmell(SettingColorSmell.State)
    case setTaste(SettingTaste.State)
    case helpTaste(HelpTaste.State)
    case setMemo(SettingMemo.State)
  }

  public enum Action {
    case wineSearch(WineSearch.Action)
    case setAlcohol(SettingAlcohol.Action)
    case setVintage(SettingVintage.Action)
    case setColorSmell(SettingColorSmell.Action)
    case setTaste(SettingTaste.Action)
    case helpTaste(HelpTaste.Action)
    case setMemo(SettingMemo.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.wineSearch, action: /Action.wineSearch) {
      WineSearch()
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
    
    Scope(state: /State.setTaste, action: /Action.setTaste) {
      SettingTaste()
    }
    
    Scope(state: /State.helpTaste, action: /Action.helpTaste) {
      HelpTaste()
    }
    
    Scope(state: /State.setMemo, action: /Action.setMemo) {
      SettingMemo()
    }
  }
}