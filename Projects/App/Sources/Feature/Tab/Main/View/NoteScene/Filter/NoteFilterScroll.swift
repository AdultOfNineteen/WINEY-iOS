//
//  NoteFilter.swift
//  Winey
//
//  Created by 정도현 on 10/23/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct NoteFilterScroll: Reducer {
  public struct State: Equatable {
    public var selectedWineTypeFilter: IdentifiedArrayOf<NoteFilter.State> = []
    public var selectedWineCountryFilter: IdentifiedArrayOf<NoteFilter.State> = []
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedFilterButton
    case tappedInitButton
    
    // MARK: - Inner Business Action
    case _navigateFilterSetting(IdentifiedArrayOf<NoteFilter.State>, IdentifiedArrayOf<NoteFilter.State>)
    case _viewWillAppear
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case noteFilter(id: Int, action: NoteFilter.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .tappedFilterButton:
        return .send(._navigateFilterSetting(state.selectedWineTypeFilter, state.selectedWineCountryFilter))
        
      case .tappedInitButton:
        state.selectedWineTypeFilter = []
        state.selectedWineCountryFilter = []
        return .none
        
      case ._viewWillAppear:
        state.selectedWineTypeFilter = IdentifiedArrayOf(uniqueElements: FilterManager.shared.wineTypeFilter)
        state.selectedWineCountryFilter = IdentifiedArrayOf(uniqueElements: FilterManager.shared.wineCountryFilter)
        return .none
      
      default:
        return .none
      }
    }
    .forEach(\.selectedWineTypeFilter, action: /NoteFilterScroll.Action.noteFilter) {
      NoteFilter()
    }
    .forEach(\.selectedWineCountryFilter, action: /NoteFilterScroll.Action.noteFilter) {
      NoteFilter()
    }
  }
}
