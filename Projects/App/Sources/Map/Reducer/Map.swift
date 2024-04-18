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
    case _onDisappear
    case _checkLocation
    case _userLocationIsEnabled(Bool)
    case _mapMovementDetection
    case _getShopInfo
    case _setShopInfo([ShopMapDTO])
    case _setMapMarker([ShopMapDTO])
    case _changeBottomSheet(height: ShopSheetHeight)
    case _activeProgressView(Bool)
    case _moveNavigationView(Bool)
    case _networkError
    
    // MARK: - Inner SetState Action
    case _tabBarHidden
    case _tabBarOpen
  }
  
  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.continuousClock) var clock
  @Dependency(\.alert) var alertService
  @Dependency(\.map) var mapService
  @Dependency(\.naverCoordinator) var naverMapCoordinator

  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
        
//      case .binding(\.$filterCategory):
//        print("🇰🇷🇰🇷🇰🇷🇰🇷🇰🇷🇰🇷🇰🇷🇰🇷🇰🇷🇰🇷🇰🇷🇰🇷🇰🇷🇰🇷🇰🇷🇰🇷")
//        print("필터 변경에 따라 움직임")
//        return .send(._getShopInfo)
        
      case ._onAppear:
        return .send(._checkLocation)
        
      case ._checkLocation:
        let coordinator = state.coordinator
        return .run { send in
          let result = await coordinator.checkIfLocationServiceIsEnabled()
          await send(._userLocationIsEnabled(result))
        }
        
      case let ._userLocationIsEnabled(result):
        if result {
          return .send(._getShopInfo)
        } else {
          return .none // 경고창 출력
        }
        
//      case ._mapMovementDetection:
//        
//        return .run { send in
//          for await _ in await naverMapCoordinator.cameraMovement() {
//            print("카메라 이동 받고 있음")
//            await send(._getShopInfo)
//          }
//        }
        
      case ._getShopInfo:
        print("1️⃣1️⃣1️⃣1️⃣1️⃣1️⃣1️⃣1️⃣1️⃣")
        let coordinator = state.coordinator
        let cameraEdge = coordinator.getCameraAnglePostion()
        let cameraCenter = coordinator.getCameraCenterPosition()
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
            print("실패?")
            return await send(._networkError)
          }
        }
//        .debounce(
//          id: CancelID.mapCameraObserver,
//          for: 1.0,
//          scheduler: self.mainQueue
//        )
      
      case let ._setShopInfo(data):
        state.mapSheet.shopList = IdentifiedArray(uniqueElements: data)
        return .run { send in
          try await self.clock.sleep(for: .milliseconds(300))
          await send(._activeProgressView(false))
        }
        
      case let ._setMapMarker(data):
        return .run { send in
          for await id in await naverMapCoordinator.tappedMarker(data) {
            print("마커 선택 리듀서에서 읽음")
            await send( .mapSheet(.tappedShopListCell(id: id)))
          }
        }
        
      case .tappedCurrentUserLocationMarker:
        
        state.coordinator.fetchUserLocation() // dlr
        
        return .send(._getShopInfo)
        
      case let .mapSheet(.tappedShopBusinessHour(open)):
        state.sheetHeight = open ? .large : .medium
        return .none
        
      case .tappedListButtonToBottomSheetUp:
        state.sheetHeight = .medium
        return .none
        
      case .tappedReloadCurrentMap:
        alertService.showAlert("아직... 연결되지 못한 기능입니다😭")
        
        return .send(._getShopInfo)
        
//      case let .mapSheet(.tappedBookMark(id)):
        //        .tappedBookMark(index):
        // API 호출
        // 성공하면 값 변경 후 알림창 띄우기
        
//        guard let old = state.mapSheet.shopList.first(where: { $0.id == id }) else {return .none}
//        guard let index = state.mapSheet.shopList.firstIndex(of: old) else {return .none}
//        
//        let new = old.changeBookMarkState()
//        state.mapSheet.shopList[index] = new
//
//        return .run { send in
//          if !new.like {
//            alertService.showAlert("내 장소에서 삭제하였습니다")
//          }
//        }
        
//        return .none
        
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
            await send(._getShopInfo) // 추가
//              .send(._tabBarHidden)
//            await send(._activeProgressView(false))
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
