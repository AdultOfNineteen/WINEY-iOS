//
//  FilterList.swift
//  Winey
//
//  Created by 정도현 on 10/24/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

// 와인 생산지
public enum WineCountry: String, Equatable {
  case italy = "이탈리아"
  case france = "프랑스"
  case chile = "칠레"
  case america = "미국"
  case spain = "스페인"
  case germany = "독일"
  case greece = "그리스"
  case australia = "호주"
  case southAfrica = "남아공"
  case newZealand = "뉴질랜드"
  case portugal = "포르투갈"
}

class FilterManager: ObservableObject {
  static let shared = FilterManager()
  
  private init() { }
  
  @Published public var filterList =  [
    NoteFilter.State(id: 0, filterInfo: FilterInfo(title: "재구매 의사", isSelected: false, count: 0)),
    NoteFilter.State(id: 1, filterInfo: FilterInfo(title: WineType.red.korName, isSelected: false, count: 0)),
    NoteFilter.State(id: 2, filterInfo: FilterInfo(title: WineType.white.korName, isSelected: false, count: 2)),
    NoteFilter.State(id: 3, filterInfo: FilterInfo(title: WineType.rose.korName, isSelected: false, count: 13)),
    NoteFilter.State(id: 4, filterInfo: FilterInfo(title: WineType.sparkl.korName, isSelected: false, count: 2)),
    NoteFilter.State(id: 5, filterInfo: FilterInfo(title: WineType.port.korName, isSelected: false, count: 13)),
    NoteFilter.State(id: 6, filterInfo: FilterInfo(title: WineType.etc.korName, isSelected: false, count: 2)),
    NoteFilter.State(id: 7, filterInfo: FilterInfo(title: WineCountry.italy.rawValue, isSelected: false, count: 2)),
    NoteFilter.State(id: 8, filterInfo: FilterInfo(title: WineCountry.france.rawValue, isSelected: false, count: 103)),
    NoteFilter.State(id: 9, filterInfo: FilterInfo(title: WineCountry.chile.rawValue, isSelected: false, count: 2)),
    NoteFilter.State(id: 10, filterInfo: FilterInfo(title: WineCountry.america.rawValue, isSelected: false, count: 10)),
    NoteFilter.State(id: 11, filterInfo: FilterInfo(title: WineCountry.spain.rawValue, isSelected: false, count: 12)),
    NoteFilter.State(id: 12, filterInfo: FilterInfo(title: WineCountry.germany.rawValue, isSelected: false, count: 42)),
    NoteFilter.State(id: 13, filterInfo: FilterInfo(title: WineCountry.greece.rawValue, isSelected: false, count: 12)),
    NoteFilter.State(id: 14, filterInfo: FilterInfo(title: WineCountry.australia.rawValue, isSelected: false, count: 12)),
    NoteFilter.State(id: 15, filterInfo: FilterInfo(title: WineCountry.southAfrica.rawValue, isSelected: false, count: 2)),
    NoteFilter.State(id: 16, filterInfo: FilterInfo(title: WineCountry.newZealand.rawValue, isSelected: false, count: 13)),
    NoteFilter.State(id: 17, filterInfo: FilterInfo(title: WineCountry.portugal.rawValue, isSelected: false, count: 103))
  ]
}

public struct FilterList: Reducer {
  public struct State: Equatable {
    public var filterList: IdentifiedArrayOf<NoteFilter.State>
    
    public init(filterList: IdentifiedArrayOf<NoteFilter.State>) {
      self.filterList = filterList
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedAdaptButton
    case tappedInitButton
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case noteFilter(id: Int, action: NoteFilter.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .tappedAdaptButton:
        FilterManager.shared.filterList = state.filterList.elements
        return .none
        
      case .tappedInitButton:
        for filter in state.filterList.filter({ $0.filterInfo.isSelected }) {
          state.filterList[filter.id].filterInfo.stateToggle()
        }
        return .none
        
      default:
        return .none
      }
    }
    .forEach(\.filterList, action: /FilterList.Action.noteFilter) {
      NoteFilter()
    }
  }
}
