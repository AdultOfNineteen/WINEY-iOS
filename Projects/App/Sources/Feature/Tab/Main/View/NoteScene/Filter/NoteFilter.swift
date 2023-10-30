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
        state.filterInfo.stateToggle()
        return .none
        
      default:
        return .none
      }
    }
  }
}
