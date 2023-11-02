//
//  NoteFilter.swift
//  Winey
//
//  Created by 정도현 on 10/23/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public enum SortState: String {
  case latest = "최신순"
  case star = "평점순"
}

public struct NoteFilterScroll: Reducer {
  public struct State: Equatable {
    public var filterList: IdentifiedArrayOf<NoteFilter.State> = []
    
    public var sortState: SortState = .latest
    public var isPresentedBottomSheet: Bool = false
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedFilterButton
    case tappedInitButton
    case tappedSortState
    case tappedOutsideOfBottomSheet
    case tappedSortCard(SortState)
    
    // MARK: - Inner Business Action
    case _navigateFilterSetting(IdentifiedArrayOf<NoteFilter.State>)
    case _viewWillAppear
    case _initData
    case _presentBottomSheet(Bool)
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case noteFilter(id: Int, action: NoteFilter.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .tappedFilterButton:
        return .send(._navigateFilterSetting(state.filterList))
        
      case .tappedInitButton:
        return .send(._initData)
        
      case ._initData:
        state.sortState = .latest
        for filter in FilterManager.shared.filterList.filter({ $0.filterInfo.isSelected }) {
          FilterManager.shared.filterList[filter.id].filterInfo.stateToggle()
        }
        return .send(._viewWillAppear)
        
      case .noteFilter(id: let index, action: .tappedFilter):
        FilterManager.shared.filterList[index].filterInfo.stateToggle()
        return .none
        
      case ._viewWillAppear:
        state.filterList = IdentifiedArrayOf(uniqueElements: FilterManager.shared.filterList)
        return .none
        
      case .tappedSortCard(let option):
        state.sortState = option
        return .send(._presentBottomSheet(false))
        
      case .tappedSortState:
        return .send(._presentBottomSheet(true))
        
      case .tappedOutsideOfBottomSheet:
        return .send(._presentBottomSheet(false))
        
      case ._presentBottomSheet(let bool):
        state.isPresentedBottomSheet = bool
        return .none
        
      default:
        return .none
      }
    }
    .forEach(\.filterList, action: /NoteFilterScroll.Action.noteFilter) {
      NoteFilter()
    }
  }
}
