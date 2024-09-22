//
//  FilterDetail.swift
//  Winey
//
//  Created by 정도현 on 1/11/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct FilterDetail {
  
  @ObservableState
  public struct State: Equatable {
    public var rebuyFilter: [FilterInfo] = []
    public var typeFilter: [FilterInfo] = []
    public var countryFilter: [FilterInfo] = []
    
    public var filterOptionsBuffer: FilterOptions
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
    
    // MARK: - Delegate
    case delegate(Delegate)
    
    public enum Delegate {
      case editFilterOptions(to: FilterOptions)
    }
  }
  
  @Dependency(\.note) var noteService
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._detailViewWillAppear:

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
            state.typeFilter.append(
              FilterInfo(
                title: wineTypeFilter.type,
                count: Int(wineTypeFilter.count) ?? 0,
                type: .type
              )
            )
          }
        }
        
        for country in countries {
          state.countryFilter.append(
            FilterInfo(
              title: country.country,
              count: Int(country.count) ?? 0,
              type: .country
            )
          )
        }
        
        state.rebuyFilter.append(FilterInfo(title: "재구매 의사", type: .rebuy))
        return .none
        
      case .tappedFilter(let filter):
        return .send(._setFilterBuffer(filter))
        
      case .tappedInitButton:
        state.filterOptionsBuffer.rebuy = false
        state.filterOptionsBuffer.type.removeAll()
        state.filterOptionsBuffer.country.removeAll()
        return .none
        
      case .tappedAdaptButton:
        let newOptions = state.filterOptionsBuffer
        return .run { send in
          await send(.delegate(.editFilterOptions(to: newOptions)))
          await send(.tappedBackButton)
        }
        
      case ._setFilterBuffer(let filter):
        if filter.type == .type {
          return .send(._setTypeBuffer(filter.title))
        } else if filter.type == .country {
          return .send(._setCountryBuffer(filter.title))
        } else {
          return .send(._setRebuyBuffer)
        }
        
      case ._setRebuyBuffer:
        state.filterOptionsBuffer.rebuy.toggle()
        return .none
        
      case ._setTypeBuffer(let filter):
        if state.filterOptionsBuffer.type.contains(filter) {
          state.filterOptionsBuffer.type.remove(filter)
        } else {
          state.filterOptionsBuffer.type.insert(filter)
        }
        return .none
        
      case ._setCountryBuffer(let filter):
        if state.filterOptionsBuffer.country.contains(filter) {
          state.filterOptionsBuffer.country.remove(filter)
        } else {
          state.filterOptionsBuffer.country.insert(filter)
        }
        return .none
        
      case let .tappedFilterRemoveButton(title, type):
        return .send(._removeFilter(title, type))
        
      case let ._removeFilter(title, type):
        if type == .type {
          state.filterOptionsBuffer.type.remove(title)
        } else if type == .country {
          state.filterOptionsBuffer.country.remove(title)
        } else {
          state.filterOptionsBuffer.rebuy = false
        }
        return .none
        
      default:
        return .none
      }
    }
  }
}
