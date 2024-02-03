//
//  Map.swift
//  Winey
//
//  Created by 정도현 on 2023/09/13.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation

public struct Map: Reducer {
  public init() {}
  
  public struct State: Equatable {
    // MARK: - Map
    var coordinator: NaverMapCoordinator = NaverMapCoordinator.shared
    
    // MARK: - Visual Data
    var shopList: IdentifiedArrayOf<ShopInfoModel> = [
      .init(
        id: 0,
        info: .init(
          shopId: 0,
          latitude: 0,
          longitude: 0,
          businessHour: "월~화 10:00~19:00",
          imgUrl: "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAyMjBfOTkg%2FMDAxNjc2ODc4OTMyMzQ5.hHZFajUN67R10cw5VrxQgYKUUwyUcqPzKEP9pLc95Mkg.IJHhwoxa3Z_z5wIjb2iR1sKHVQdr3auhVO90KrkY5ysg.JPEG.sky_planet%2F013.jpg&type=sc960_832",
          address: "송파구 올림픽로 37길 2층",
          phone: "000-000-0000",
          name: "",
          meter: 0,
          shopType: "",
          shopMoods: ["양식", "프랑스", "파스타", "파스타", "파스타"],
          like: true
        ))
    ] // 테스트
    var filterCategory: ShopCategoryType = .all
    
    // MARK: - BottomSheetState
    var sheetHeight: ShopSheetHeight = .close
//    @BindingState 
    var moveNavigation: Bool = false
    var setProgressView: Bool = false
    
    public init() { }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    // MARK: - User Action
    case tapped(category: ShopCategoryType)
    case tappedBookMark(index: Int)
    case tappedCurrentUserLocationMarker
    case tappedShopBusinessHour(Bool)
    case tappedListButtonToBottomSheetUp
    case tappedReloadCurrentMap
    case tappedNavigationBackButton
    case tappedShopListCell
    
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
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._onAppear:
      state.coordinator.checkIfLocationServiceIsEnabled()
      return .none
      
    case .tappedCurrentUserLocationMarker:
      state.coordinator.fetchUserLocation()
      return .none
      
//    case .binding(\.$showDetailShopInfo):  // binding 될 때 발생하는 이벤트
//      return .none
      
    case .tappedShopListCell:
      state.moveNavigation = true
      return .none
      
    case let .tappedShopBusinessHour(isTrue):
      state.sheetHeight = isTrue ? .large : .medium
      return .none
      
    case .tappedListButtonToBottomSheetUp:
      state.sheetHeight = .medium
      return .none
      
    case .tappedReloadCurrentMap:
      alertService.showAlert("아직... 연결되지 못한 기능입니다😭")
      return .none
      
    case let .tappedBookMark(index):
      // API 호출
      // 성공하면 값 변경 후 알림창 띄우기
      let old = state.shopList[index]
      let oldInfo = old.info
      let new = ShopInfoModel.init(
        id: old.id,
        info: .init(
          shopId: oldInfo.shopId,
          latitude: oldInfo.latitude,
          longitude: oldInfo.longitude,
          businessHour: oldInfo.businessHour,
          imgUrl: oldInfo.imgUrl,
          address: oldInfo.address,
          phone: oldInfo.phone,
          name: oldInfo.name,
          meter: oldInfo.meter,
          shopType: oldInfo.shopType,
          shopMoods: oldInfo.shopMoods,
          like: !oldInfo.like
        )
      )
      state.shopList[index] = new
      if !new.info.like {
        alertService.showAlert("내 장소에서 삭제하였습니다")
      }
      return .none
      
    case .tappedNavigationBackButton:
      if state.moveNavigation {
        state.moveNavigation = false
      } else {
        return .send(.tapped(category: .all))
      }
      
      return .none
      
      
    case let ._changeBottomSheet(height):
      state.sheetHeight = height
      return .none
      
    case let .tapped(category):
      state.filterCategory = category
      
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
      return .send(._tabBarHidden)
      
      
    default:
      print("map Reducer 액션")
      return .none
    }
  }
}
