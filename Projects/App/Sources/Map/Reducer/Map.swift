//
//  Map.swift
//  Winey
//
//  Created by 정도현 on 2023/09/13.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

public struct Map: Reducer {
  public init() {}
  
  public struct State: Equatable {
    // MARK: - Map
    var coordinator: NaverMapCoordinator = NaverMapCoordinator.shared
    
    // MARK: - Visual Data
    @BindingState var filterCategory: ShopCategoryType = .all
    
    // MARK: - BottomSheetState
    var mapSheet: MapSheet.State = .init(shopList: [.dummy, .dummy2])
    var sheetHeight: ShopSheetHeight = .close
    
    var moveNavigation: Bool = false
    var setProgressView: Bool = false
    
    public init() { }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case mapSheet(MapSheet.Action)
    
    // MARK: - User Action
    case tapped(category: ShopCategoryType)
    // Map Navigation
    case tappedCurrentUserLocationMarker
    case tappedListButtonToBottomSheetUp
    case tappedReloadCurrentMap
    
    // MARK: - Inner Business Action
    case _onAppear
    case _checkLocation
    case _getShopInfo
    case _changeBottomSheet(height: ShopSheetHeight)
    case _activeProgressView(Bool)
    case _moveNavigationView(Bool)
    // MARK: - Inner SetState Action
    case _tabBarHidden
    case _tabBarOpen
  }
  
  @Dependency(\.continuousClock) var clock
  @Dependency(\.alert) var alertService
  @Dependency(\.map) var mapService
  @Dependency(\.dismiss) var dismiss
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case ._onAppear:
        state.coordinator.checkIfLocationServiceIsEnabled()
        return .none
        
      case .tappedCurrentUserLocationMarker:
        state.coordinator.fetchUserLocation()
        return .none
        
      case let .mapSheet(.tappedShopBusinessHour(open)):
        state.sheetHeight = open ? .large : .medium
        return .none
        
      case .tappedListButtonToBottomSheetUp:
        state.sheetHeight = .medium
        return .none
        
      case .tappedReloadCurrentMap:
        alertService.showAlert("아직... 연결되지 못한 기능입니다😭")
        return .none
        
      case let .mapSheet(.tappedBookMark(id)):
        //        .tappedBookMark(index):
        // API 호출
        // 성공하면 값 변경 후 알림창 띄우기
//        let old = state.mapSheet.shopList[index]/* .shopList[index]*/
        guard let old = state.mapSheet.shopList.first(where: { $0.id == id }) else {return .none}
        guard let index = state.mapSheet.shopList.firstIndex(of: old) else {return .none}
        
        let new = old.changeBookMarkState()
        state.mapSheet.shopList[index] = new
        if !new.info.like {
          alertService.showAlert("내 장소에서 삭제하였습니다")
        }
        return .none
        
      case .mapSheet(.tappedNavigationBackButton):
        switch state.mapSheet.destination {
        case .shopAll: break
        case .shopList:
          state.mapSheet.destination = .shopAll
          return .send(.tapped(category: .all))
        case .shopDetail:
          state.mapSheet.destination = .shopList
          state.mapSheet.isNavigationActive = false
        }
        return .none
        
        
      case let ._changeBottomSheet(height):
        state.sheetHeight = height
        return .none
        
      case let .tapped(category):
        state.filterCategory = category
        state.mapSheet.selectedCategory = category
        state.mapSheet.destination = .shopList
        if category == .all {
          return .send(._tabBarOpen)
        } else {
          return .run { send in
            await send(._activeProgressView(true))
            try await self.clock.sleep(for: .milliseconds(300))
            await send(._activeProgressView(false))
          }
        }
        
      case let ._activeProgressView(new):
        state.setProgressView = new
        if new {
          state.sheetHeight = .close
        } else {
          state.sheetHeight = .medium
        }
        return .send(._tabBarHidden)
        
        
      default: return .none
      }
    }
    
    Scope(state: \State.mapSheet, action: /Action.mapSheet) {
      MapSheet()
    }
  }
}
