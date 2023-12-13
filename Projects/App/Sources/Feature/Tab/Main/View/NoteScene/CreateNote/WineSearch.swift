//
//  WineSearch.swift
//  Winey
//
//  Created by 정도현 on 11/7/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct WineSearch: Reducer {
  public struct State: Equatable {
    public var userSearch = ""
    public var noteCards: IdentifiedArrayOf<NoteCard.State> = NoteCardScroll.State().noteCards
    public var searchResult: IdentifiedArrayOf<NoteCard.State> = NoteCardScroll.State().noteCards
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    case _settingSearchString(String)
    case _updateList(String)
    case _focusing
    case _unfocusing
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case noteCard(id: Int, action: NoteCard.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case let ._settingSearchString(text):
        state.userSearch = text
        return .send(._updateList(text))
        
      case let ._updateList(text):
        state.searchResult = state.noteCards.filter { 
          text.isEmpty ? true : $0.noteCardData.wineName.lowercased().contains(text.lowercased())
        }
        return .none
        
      default:
        return .none
      }
    }.forEach(\.noteCards, action: /WineSearch.Action.noteCard) {
      NoteCard()
    }
  }
}
