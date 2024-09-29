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
    public var searchCard: IdentifiedArrayOf<WineSearchCard.State> = []
    
    public var userSearch: String = ""
    
    public var searchPage: Int = 0
    public var searchSize: Int = 10
    public var isLast = false
    public var totalCnt = 0
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _settingSearchString(String)
    case _checkPagination(data: WineSearchContent)
    case _fetchNextSearchPage
    case _appendNextSearchData
    
    // MARK: - Inner SetState Action
    case _setSearchData(data: WineSearchDTO)
    case _appendSearchData(newData: WineSearchDTO)
    case _failureSocialNetworking(Error)
    
    // MARK: - Child Action
    case searchCard(IdentifiedActionOf<WineSearchCard>)
  }
  
  @Dependency(\.note) var noteService
  @Dependency(\.mainQueue) var mainQueue
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._viewWillAppear:
        let userInput = state.userSearch
        let searchPage = state.searchPage
        let searchSize = state.searchSize
        
        if searchPage == 0 {
          return .run { send in
            switch await noteService.wineSearch(searchPage, searchSize, userInput) {
            case let .success(data):
              await send(._setSearchData(data: data))
            case let .failure(error):
              await send(._failureSocialNetworking(error))
            }
          }
        } else {
          return .none
        }
        
      case let ._setSearchData(data):
        state.searchCard = IdentifiedArrayOf(
          uniqueElements: data.contents
            .enumerated()
            .map {
              WineSearchCard.State(
                data: $0.element,
                searchString: state.userSearch
              )
            }
        )
        
        state.totalCnt = data.totalCnt
        state.isLast = data.isLast
        
        return .none
        
      case let ._checkPagination(data):
        guard let lastData = state.searchCard.last else {
          return .none
        }
        
        if lastData.data.wineId == data.wineId {
          if state.isLast {
            return .none
          } else {
            return .send(._fetchNextSearchPage)
          }
        } else {
          return .none
        }
        
      case let ._appendSearchData(newData):
        var originSearchData = state.searchCard
        
        originSearchData.append(
          contentsOf: newData.contents
            .enumerated()
            .map {
              WineSearchCard.State(
                data: $0.element,
                searchString: state.userSearch
              )
            }
        )
        
        state.isLast = newData.isLast
        state.searchCard = originSearchData
        return .none
        
      case let ._settingSearchString(text):
        state.userSearch = text
        
        let userInput = state.userSearch
        
        state.searchPage = 0
        
        let searchPage = state.searchPage
        let searchSize = state.searchSize
        
        return .run { send in
          switch await noteService.wineSearch(searchPage, searchSize, userInput) {
          case let .success(data):
            await send(._setSearchData(data: data))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        }
        .debounce(id: CancelID.mapMarker, for: 0.5, scheduler: self.mainQueue)
        
      case ._fetchNextSearchPage:
        if state.isLast {
          return .none
        } else {
          return .send(._appendNextSearchData)
        }
        
      case ._appendNextSearchData:
        let userInput = state.userSearch
        
        state.searchPage += 1
        
        let searchPage = state.searchPage
        let searchSize = state.searchSize
        
        return .run { send in
          switch await noteService.wineSearch(searchPage, searchSize, userInput) {
          case let .success(data):
            await send(._appendSearchData(newData: data))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        }
        
      default:
        return .none
      }
    }
    .forEach(\.searchCard, action: \.searchCard) {
      WineSearchCard()
    }
  }
}
