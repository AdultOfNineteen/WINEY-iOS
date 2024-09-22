//
//  FilteredNote.swift
//  Winey
//
//  Created by 정도현 on 1/11/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct FilteredNotes {
  
  @ObservableState
  public struct State: Equatable {
    static let searchSize = 10
    public var nowSearchPage: Int = 0
    public var filterOptions: FilterOptions = .init()
    
    public var isPresentedBottomSheet: Bool = false
    
    public var tastingNotes: TastingNotes.State = .init()
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
    case _onAppear
    
    case _presentBottomSheet(Bool)
    case _removeFilter(FilterType, String)
    
    // MARK: - Inner SetState Action
    case _fetchNotes
    case _resetNotes(data: NoteDTO)
    case _addNotes(data: NoteDTO)
    
    case _setSortState(SortState)
    
    case editFilterOptions(to: FilterOptions)
    case scrollToNextPage
    
    // MARK: - Child Action
    case tastingNotes(TastingNotes.Action)
  }
  
  @Dependency(\.note) var noteService
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._onAppear:
        return .send(._fetchNotes)
        
      case ._fetchNotes:
        let param = convertToParameterForNoteDTO(
          nowSearchPage: state.nowSearchPage, filterOptions: state.filterOptions)
        
        return .run { send in
          switch await noteService.loadNotes(param.page, param.size, param.order, param.country, param.wineType, param.buyAgain, param.wineId) {
            
          case let .success(data):
            await send(._resetNotes(data: data))
          case let .failure(error):
            print(error)
          }
        }
        
      case let ._resetNotes(data):
        state.tastingNotes.noteListInfo = data
        return .none

      case let .editFilterOptions(newOptions):
        state.filterOptions = newOptions
        return .send(._fetchNotes)
        
      case .scrollToNextPage:
        state.nowSearchPage += 1
        let param = convertToParameterForNoteDTO(
          nowSearchPage: state.nowSearchPage, filterOptions: state.filterOptions)
        
        return .run { send in
          switch await noteService.loadNotes(param.page, param.size, param.order, param.country, param.wineType, param.buyAgain, param.wineId) {
            
          case let .success(data):
            await send(._addNotes(data: data))
          case let .failure(error):
            print(error)
          }
        }
        
      case let ._addNotes(newData):
        state.tastingNotes.noteListInfo.isLast = newData.isLast
        state.tastingNotes.noteListInfo.contents += newData.contents
        return .none

      case .tappedSortButton(let sortOption):
        return .send(._setSortState(sortOption))
        
      case .tappedSortState:
        return .send(._presentBottomSheet(true))
        
      case ._setSortState(let newSortOption):
        var nowOptions = state.filterOptions
        nowOptions.sortState = newSortOption
        let newOptions = nowOptions
        return .run { send in
          await send(._presentBottomSheet(false))
          await send(.editFilterOptions(to: newOptions))
        }
        
      case .tappedInitButton:
        let noneOptions = FilterOptions()
        return .send(.editFilterOptions(to: noneOptions))

      case let .tappedFilterRemoveButton(type, filter):
        var newOptions = state.filterOptions
        switch type {
        case .country:
          newOptions.country.remove(filter)
        case .rebuy:
          newOptions.rebuy = false
        case .type:
          newOptions.type.remove(filter)
        }
        return .send(.editFilterOptions(to: newOptions))
        
      case .tappedOutsideOfBottomSheet:
        return .send(._presentBottomSheet(false))
        
      case ._presentBottomSheet(let bool):
        state.isPresentedBottomSheet = bool
        return .none
        
      case .tastingNotes(._fetchNextNotePage):
        guard state.tastingNotes.noteListInfo.totalCnt != 0 else {
          return .none
        }
        
        let noteData = state.tastingNotes
        
        if noteData.noteListInfo.isLast {
          return .none
        } else {
          return .send(.scrollToNextPage)
        }
        
      default:
        return .none
      }
    }
  }
  
  func convertToParameterForNoteDTO(nowSearchPage: Int, filterOptions: FilterOptions) -> ParameterForNoteDTO {
    let searchSize = State.searchSize
    let sortself = filterOptions.sortState.rawValue
    let rebuy = filterOptions.rebuy ? 1 : nil
    let countries = filterOptions.country
    let types = filterOptions.type.setmap(transform: { filterRequestString(forValue: $0) })
    let searchPage = nowSearchPage
    let wineId: Int? = nil
    return (searchPage, searchSize, sortself, countries, types, rebuy, wineId)
  }
}
