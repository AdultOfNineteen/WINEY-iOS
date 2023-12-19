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
    public var userSearch: String = ""
    
    public var wineCards: WineSearchDTO?
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedWineCard(WineSearchContent)
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _settingSearchString(String)
    case _focusing
    case _unfocusing
    
    // MARK: - Inner SetState Action
    case _setWines(data: WineSearchDTO)
    case _failureSocialNetworking(Error)
    
    // MARK: - Child Action
  }
  
  @Dependency(\.note) var noteService
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case ._viewWillAppear:
        let userInput = state.userSearch
        return .run { send in
          switch await noteService.wineSearch(1, 10, userInput) {
          case let .success(data):
            await send(._setWines(data: data))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        }
        
      case let ._setWines(data):
        state.wineCards = data
        return .none
        
      case let ._settingSearchString(text):
        state.userSearch = text
        return .run { send in
          switch await noteService.wineSearch(1, 10, text) {
          case let .success(data):
            await send(._setWines(data: data))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        }
        
      default:
        return .none
      }
    }
  }
}
