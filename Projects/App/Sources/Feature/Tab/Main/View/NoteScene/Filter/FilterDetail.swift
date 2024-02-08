//
//  FilterDetail.swift
//  Winey
//
//  Created by 정도현 on 1/11/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct FilterDetail: Reducer {
  public struct State: Equatable {
    public var rebuyFilter: [FilterInfo] = []
    public var typeFilter: [FilterInfo] = []
    public var countryFilter: [FilterInfo] = []
    
    public var rebuyFilterBuffer: [String] = []
    public var typeFilterBuffer: [String] = []
    public var countryFilterBuffer: [String] = []
    
    public var wineCountry: [String] = [
      "프랑스", "스페인", "호주", "뉴질랜드", "미국", "이탈리아", "아르헨티나", "칠레", "조지아", "오스트리아", "포르투갈", "독일",
      "남아프리카", "체코", "슬로베니아", "그리스", "우루과이", "헝가리", "몰도바", "남아프리카_공화국", "스웨덴", "불가리아", "캐나다",
      "대한민국", "크로아티아", "중국", "일본", "루마니아", "아제르바이잔", "레바논", "이스라엘", "덴마크", "기타국가", "영국"
    ]
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedFilterButton
    case tappedFilter(FilterInfo)
    case tappedBackButton
    case tappedInitButton
    case tappedAdaptButton
    case tappedFilterRemoveButton(String, FilterType)
    
    // MARK: - Inner Business Action
    case _detailViewWillAppear
    case _navigateFilterDetail([String])
    case _setFilterBuffer(FilterInfo)
    case _removeFilter(String, FilterType)
    
    // MARK: - Inner SetState Action
    case _setFilters(data: NoteFilterDTO)
    case _failureSocialNetworking(Error)  // 추후 경고 처리
    case _setTypeBuffer(String)
    case _setCountryBuffer(String)
    case _setRebuyBuffer
    
    // MARK: - Child Action
  }
  
  @Dependency(\.note) var noteService
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._detailViewWillAppear:
        state.rebuyFilterBuffer = FilterManager.shared.rebuyFilter
        state.typeFilterBuffer = FilterManager.shared.typeFilter
        state.countryFilterBuffer = FilterManager.shared.countryFilter
        
        return .run { send in
          switch await noteService.noteFilter() {
          case let .success(data):
            await send(._setFilters(data: data))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        }
        
      case let ._setFilters(data):
        let wineTypes = data.wineTypes
        let countries = data.countries
        
        WineType.allCases.forEach { type in
          if let wineTypeFilter = wineTypes.filter({ $0.type == type.korName }).first {
            state.typeFilter.append(FilterInfo(title: wineTypeFilter.type, count: Int(wineTypeFilter.count) ?? 0, type: .type))
          }
        }
        
        for country in state.wineCountry {
          if let countryFilter = countries.filter({ $0.country == country }).first {
            state.countryFilter.append(FilterInfo(title: countryFilter.country, count: Int(countryFilter.count) ?? 0, type: .country))
          }
        }
        
        state.rebuyFilter.append(FilterInfo(title: "재구매 의사", type: .rebuy))
        return .none
        
      case .tappedFilter(let filter):
        return .send(._setFilterBuffer(filter))
        
      case .tappedInitButton:
        state.rebuyFilterBuffer.removeAll()
        state.typeFilterBuffer.removeAll()
        state.countryFilterBuffer.removeAll()
        return .none
        
      case .tappedAdaptButton:
        FilterManager.shared.rebuyFilter = state.rebuyFilterBuffer
        FilterManager.shared.typeFilter = state.typeFilterBuffer
        FilterManager.shared.countryFilter = state.countryFilterBuffer
        return .send(.tappedBackButton)
        
      case ._setFilterBuffer(let filter):
        if filter.type == .type {
          return .send(._setTypeBuffer(filter.title))
        } else if filter.type == .country {
          return .send(._setCountryBuffer(filter.title))
        } else {
          return .send(._setRebuyBuffer)
        }
        
      case ._setRebuyBuffer:
        if !state.rebuyFilterBuffer.isEmpty {
          state.rebuyFilterBuffer = []
        } else {
          state.rebuyFilterBuffer.append("재구매 의사")
        }
        return .none
        
      case ._setTypeBuffer(let filter):
        if state.typeFilterBuffer.contains(where: { $0 == filter }) {
          state.typeFilterBuffer.removeAll(where: { $0 == filter })
        } else {
          state.typeFilterBuffer.append(filter)
        }
        return .none
        
      case ._setCountryBuffer(let filter):
        if state.countryFilterBuffer.contains(where: { $0 == filter }) {
          state.countryFilterBuffer.removeAll(where: { $0 == filter })
        } else {
          state.countryFilterBuffer.append(filter)
        }
        return .none
        
      case let .tappedFilterRemoveButton(title, type):
        return .send(._removeFilter(title, type))
        
      case let ._removeFilter(title, type):
        if type == .type {
          state.typeFilterBuffer.removeAll(where: { $0 == title })
        } else if type == .country {
          state.countryFilterBuffer.removeAll(where: { $0 == title })
        } else {
          state.rebuyFilterBuffer.removeAll()
        }
        return .none
        
      default:
        return .none
      }
    }
  }
}
