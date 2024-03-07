//
//  FilteredNote.swift
//  Winey
//
//  Created by 정도현 on 1/11/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public enum SortState: Int, CaseIterable {
  case latest = 0
  case star = 1
  
  public var title: String {
    switch self {
    case .latest:
      return "최신순"
    case .star:
      return "평점순"
    }
  }
}

public struct FilteredNote: Reducer {
  public struct State: Equatable {
    public var rebuyFilter: Set<String> = []
    public var typeFilter: Set<String> = []
    public var countryFilter: Set<String> = []
    
    public var sortState: SortState = .latest
    public var isPresentedBottomSheet: Bool = false
    
    public var noteCardList: NoteCardScroll.State?
    
    public var noteSearchPage: Int = 0
    public var noteSearchSize: Int = 10
  }
  
  public enum Action {
    
    // MARK: - User Action
    case tappedFilterButton
    case tappedAdaptButton
    case tappedInitButton
    case tappedFilterRemoveButton(FilterType, String)
    case tappedSortState
    case tappedSortButton(SortState)
    case tappedOutsideOfBottomSheet
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _cardFetch
    case _presentBottomSheet(Bool)
    case _removeFilter(FilterType, String)
    
    // MARK: - Inner SetState Action
    case _setNotes(data: NoteDTO)
    case _failureSocialNetworking(Error)  // 추후 경고 처리
    case _setSortState(SortState)
    
    // MARK: - Child Action
    case noteCardScroll(NoteCardScroll.Action)
  }
  
  @Dependency(\.note) var noteService
  
  public var body: some ReducerOf<Self> {
    
    Reduce<State, Action> { state, action in
      switch action {
      case ._viewWillAppear:
        state.rebuyFilter = FilterManager.shared.rebuyFilter
        state.typeFilter = FilterManager.shared.typeFilter
        state.countryFilter = FilterManager.shared.countryFilter
        
        let searchPage = state.noteSearchPage
        let searchSize = state.noteSearchSize
        
        let sortState = state.sortState.rawValue
        let rebuy = state.rebuyFilter.isEmpty ? nil : 1
        let countries = state.countryFilter
        let types = state.typeFilter.setmap(transform: { filterRequestString(forValue: $0) })
        
        return .run { send in
          switch await noteService.notes(searchPage, searchSize, sortState, countries, types, rebuy) {
          case let .success(data):
            await send(._setNotes(data: data))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        }
        
      case let ._setNotes(data):
        state.noteCardList = NoteCardScroll.State.init(noteCards: data)
        return .none
        
      case .tappedSortButton(let sortOption):
        return .send(._setSortState(sortOption))
        
      case .tappedSortState:
        return .send(._presentBottomSheet(true))
        
      case .tappedInitButton:
        FilterManager.shared.typeFilter.removeAll()
        FilterManager.shared.countryFilter.removeAll()
        FilterManager.shared.rebuyFilter.removeAll()
        return .send(._viewWillAppear)
        
      case let .tappedFilterRemoveButton(type, filter):
        return .send(._removeFilter(type, filter))
        
      case .tappedOutsideOfBottomSheet:
        return .send(._presentBottomSheet(false))
        
      case let ._removeFilter(type, filter):
        if type == .type {
          FilterManager.shared.typeFilter.remove(filter)
        } else if type == .country {
          FilterManager.shared.countryFilter.remove(filter)
        } else {
          FilterManager.shared.rebuyFilter.remove(filter)
        }
        return .send(._viewWillAppear)
        
      case ._setSortState(let sortOption):
        state.sortState = sortOption
        return .run { send in
          await send(._presentBottomSheet(false))
          await send(._viewWillAppear)
        }
        
      case ._presentBottomSheet(let bool):
        state.isPresentedBottomSheet = bool
        return .none
        
       
      case .noteCardScroll(._fetchNextNotePage):
        guard let noteData = state.noteCardList else {
          return .none
        }
        
        if noteData.noteCards.isLast {
          return .none
        } else {
          return .send(.noteCardScroll(._appendNextNote(noteData.noteCards)))
        }
        
        
      case let .noteCardScroll(._appendNextNote(noteData)):
        
        state.noteSearchPage += 1
        
        let searchPage = state.noteSearchPage
        let searchSize = state.noteSearchSize
        
        let sortState = state.sortState.rawValue
        let rebuy = state.rebuyFilter.isEmpty ? nil : 1
        let countries = state.countryFilter
        let types = state.typeFilter.setmap(transform: { filterRequestString(forValue: $0) })
        
        return .run { send in
          switch await noteService.notes(searchPage, searchSize, sortState, countries, types, rebuy) {
          case let .success(data):
            await send(.noteCardScroll(._appendNotes(noteData, data: data)))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        }
        
      case let .noteCardScroll(._appendNotes(noteData, data)):
        var originNoteData = noteData
        
        originNoteData.contents.append(contentsOf: data.contents)
        originNoteData.isLast = data.isLast
        originNoteData.totalCnt = data.totalCnt
        
        state.noteCardList?.noteCards = originNoteData
        
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.noteCardList, action: /FilteredNote.Action.noteCardScroll) {
      NoteCardScroll()
    }
  }
}
