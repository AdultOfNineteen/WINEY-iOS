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
public enum WineCountry: String, CaseIterable, Equatable {
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

public struct FilterList: Reducer {
  public struct State: Equatable {
    public var noteFilters: IdentifiedArrayOf<NoteFilter.State> = IdentifiedArrayOf(uniqueElements: FilterInfo.data)
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedAdaptButton
    
    // MARK: - Inner Business Action
    case _sendFilter
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case noteFilter(id: Int, action: NoteFilter.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .noteFilter(id: index, action: .tappedFilter):
        return .none
        
      case .tappedAdaptButton:
        return .send(._sendFilter)
        
      default:
        return .none
      }
    }
    .forEach(\.noteFilters, action: /FilterList.Action.noteFilter) {
      NoteFilter()
    }
  }
}
