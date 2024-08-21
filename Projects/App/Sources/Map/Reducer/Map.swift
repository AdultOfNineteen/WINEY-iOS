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
    // MARK: - Visual Data
    @BindingState var filterCategory: ShopCategoryType = .all
    
    // MARK: - BottomSheetState
    var mapSheet: MapSheet.State = .init(shopList: [])
    var sheetHeight: ShopSheetHeight = .close
    
    var tappedOpenFirst: Bool = true
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
    case _viewWillAppear
    case _checkLocation
    case _userLocationIsEnabled(Bool) // 미사용
    case _getShopInfo
    case _setShopInfo([ShopMapDTO])
    case _setMapMarker([ShopMapDTO])
    case _changeBottomSheet(height: ShopSheetHeight)
    case _activeProgressView(Bool)
    case _networkError
    
    // MARK: - Inner SetState Action
    case _tabBarHidden
    case _tabBarOpen
    case _tappedMapTabBarItem(Bool)
  }
  
  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.continuousClock) var clock
  @Dependency(\.alert) var alertService
  @Dependency(\.map) var mapService
  @Dependency(\.location) var locationService
  @Dependency(\.naverCoordinator) var naverMapService
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case ._viewWillAppear:
        AmplitudeProvider.shared.track(event: .MAP_ENTER)
        return .none
        
      case let ._tappedMapTabBarItem(isTappedMapTabBarItem):
        guard !state.tappedOpenFirst else {
          state.tappedOpenFirst = false
          return .send(._checkLocation)
        }
        guard isTappedMapTabBarItem else { return .none }
        return .cancel(id: CancelID.mapMarker)
        
      case ._checkLocation:
        return .run { send in
          _ = await locationService.checkIfLocationServiceIsEnabled()
        }
        
      case ._getShopInfo:
        let cameraEdge = naverMapService.getCameraAnglePostion()
        let cameraCenter = naverMapService.getCameraCenterPosition()
        let category = state.filterCategory
        return  .run { send in
          let result = await mapService.getShopsInfoOf(
            category,
            cameraCenter.latitude,
            cameraCenter.longitude,
            cameraEdge.leftTopLatitude,
            cameraEdge.leftTopLongitude,
            cameraEdge.rightBottomLatitude,
            cameraEdge.rightBottomLongitude
          )
          
          switch result {
          case let .success(data):
            await send(._setShopInfo(data))
            await send(._setMapMarker(data))
            return
          case .failure:
            return await send(._networkError)
          }
        }
        
      case let ._setShopInfo(data):
        state.mapSheet.shopList = IdentifiedArray(uniqueElements: data)
        return .run { send in
          try await self.clock.sleep(for: .milliseconds(300))
          await send(._activeProgressView(false))
        }
        
      case let ._setMapMarker(data):
        return .run { send in
          for await id in await naverMapService.tappedMarker(data) {
            await send( .mapSheet(.tappedShopListCell(id: id)))
            await send(._changeBottomSheet(height: .medium))
          }
        }
        .cancellable(id: CancelID.mapMarker)
        
      case .tappedCurrentUserLocationMarker:
        if let location = locationService.userLocation() {
          naverMapService.updateUserLocationInMap(location.lat, location.lng)
        } else {
          // MARK: - 내 위치 허용 권장
          alertService.showAlert("내 위치를 알기 위해 위치접근 허용이 필요해요!")
        }
        return .none
        
      case let .mapSheet(.tappedShopBusinessHour(open)):
        state.sheetHeight = open ? .large : .medium
        return .none
        
      case .tappedListButtonToBottomSheetUp:
        state.sheetHeight = .medium
        return .none
        
      case .tappedReloadCurrentMap:
        return .send(._getShopInfo)
        
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
        state.mapSheet.shopList = []
        
        if category == .all {
          return .send(._tabBarOpen)
            .concatenate(with: .send(._getShopInfo))
        } else {
          return .run { send in
            await send(._tabBarHidden)
            await send(._activeProgressView(true))
            await send(._getShopInfo)
          }
        }
        
      case let ._activeProgressView(new):
        state.setProgressView = new
        if new {
          state.sheetHeight = .close
        } else {
          state.sheetHeight = .medium
        }
        return .none
        
      default: return .none
      }
    }
    
    Scope(state: \State.mapSheet, action: /Action.mapSheet) {
      MapSheet()
    }
  }
}
