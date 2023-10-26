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
    public var selectedFilter: [NoteFilter.State] = []
    
    public var filterList = FilterList.State()
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedFilterButton
    
    // MARK: - Inner Business Action
    case _navigateFilterSetting
    case _settingFilter
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case filterList(FilterList.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.filterList, action: /Action.filterList) {
      FilterList()
    }
    
    Reduce<State, Action> { state, action in
      switch action {
      case .tappedFilterButton:
        return .send(._navigateFilterSetting)
        
      case .filterList(.tappedAdaptButton):
        return .run { send in
          await send(._settingFilter)
        }
        
      case ._settingFilter:
        state.selectedFilter = FilterInfo.data.filter { $0.filterInfo.isSelected }
        print(state.selectedFilter)
        return .none
      
      default:
        return .none
      }
    }
  }
}
