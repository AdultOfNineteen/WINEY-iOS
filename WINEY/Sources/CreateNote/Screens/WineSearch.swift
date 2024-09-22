//
//  WineSearch.swift
//  Winey
//
//  Created by 정도현 on 11/7/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct WineSearch {
  @ObservableState
  public struct State: Equatable {
    public var wineCards: WineSearchDTO?
    
    public var wineSearchPage: Int = 0
    public var wineSearchSize: Int = 10
    public var userSearch: String = ""
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
    case _fetchNextWinePage
    case _appendNextWineData(WineSearchDTO)
    
    // MARK: - Inner SetState Action
    case _setWines(data: WineSearchDTO)
    case _appendWines(WineSearchDTO, data: WineSearchDTO)
    case _failureSocialNetworking(Error)
    
    // MARK: - Child Action
  }
  
  @Dependency(\.note) var noteService
  @Dependency(\.mainQueue) var mainQueue
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._viewWillAppear:
        let userInput = state.userSearch
        let searchPage = state.wineSearchPage
        let searchSize = state.wineSearchSize
        
        if searchPage == 0 {
          return .run { send in
            switch await noteService.wineSearch(searchPage, searchSize, userInput) {
            case let .success(data):
              await send(._setWines(data: data))
            case let .failure(error):
              await send(._failureSocialNetworking(error))
            }
          }
        } else {
          return .none
        }
        
      case let ._setWines(data):
        state.wineCards = data
        return .none
        
      case let ._appendWines(wineData, data):
        var originWineData = wineData
        originWineData.contents.append(contentsOf: data.contents)
        originWineData.isLast = data.isLast
        originWineData.totalCnt = data.totalCnt
        
        state.wineCards = originWineData
        
        return .none
        
      case let ._settingSearchString(text):
        state.userSearch = text
        
        let userInput = state.userSearch
        
        state.wineSearchPage = 0
        let searchPage = state.wineSearchPage
        let searchSize = state.wineSearchSize
        
        return .run { send in
          switch await noteService.wineSearch(searchPage, searchSize, userInput) {
          case let .success(data):
            await send(._setWines(data: data))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        }
        .debounce(id: CancelID.mapMarker, for: 0.5, scheduler: self.mainQueue)
        
      case ._fetchNextWinePage:
        guard let wineData = state.wineCards else {
          return .none
        }
        
        if wineData.isLast {
          return .none
        } else {
          return .send(._appendNextWineData(wineData))
        }
        
      case let ._appendNextWineData(wineData):
        let userInput = state.userSearch
        
        state.wineSearchPage += 1
        let searchPage = state.wineSearchPage
        let searchSize = state.wineSearchSize
        
        return .run { send in
          switch await noteService.wineSearch(searchPage, searchSize, userInput) {
          case let .success(data):
            await send(._appendWines(wineData, data: data))
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
