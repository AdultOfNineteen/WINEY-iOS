//
//  NoteFilter.swift
//  Winey
//
//  Created by 정도현 on 10/26/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct FilterInfo: Equatable, Hashable {
  public var title: String
  public var isSelected: Bool
  public var count: Int
  
  public mutating func stateToggle() {
    self.isSelected.toggle()
  }
}

extension FilterInfo {
  static var data =  [
    NoteFilter.State(id: 0, filterInfo: FilterInfo(title: "test", isSelected: false, count: 0)),
    NoteFilter.State(id: 1, filterInfo: FilterInfo(title: "teste", isSelected: false, count: 2)),
    NoteFilter.State(id: 2, filterInfo: FilterInfo(title: "testdd", isSelected: false, count: 103))
  ]
}

public struct NoteFilter: Reducer {
  public struct State: Equatable, Identifiable, Hashable {
    public var id: Int
    public var filterInfo: FilterInfo
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedFilter
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .tappedFilter:
        FilterInfo.data[state.id].filterInfo.stateToggle()
        state.filterInfo.stateToggle()
        return .none
        
      default:
        return .none
      }
    }
  }
}
