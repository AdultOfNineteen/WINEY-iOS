//
//  MapSheet.swift
//  Winey
//
//  Created by 박혜운 on 3/28/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct MapSheet {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var selectedCategory: ShopCategoryType = .all
    var shopList: IdentifiedArrayOf<ShopMapDTO>
    var isNavigationActive: Bool = false // List -> Cell으로의 이동에 영향
    var destination: Action.MapDestination = .shopAll // 네비게이션 상단 바에 영향
    var tappedShopInfo: ShopMapDTO?
  }
  
  @Dependency(\.map) var mapService
  
  public enum Action: BindableAction, Equatable {
    public enum MapDestination: Int {
      case shopAll
      case shopList
      case shopDetail
    }
    
    case binding(BindingAction<State>)
    case destination(MapDestination)
    
    case tappedBookMark(id: Int)
    case tappedShopBusinessHour(Bool)
    case tappedNavigationBackButton
    case tappedShopListCell(id: Int)
  }
  
  @Dependency(\.alert) var alertService
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case let .tappedShopListCell(id):
        state.isNavigationActive = true
        state.destination = .shopDetail
        guard let shopInfo = state.shopList.first(where: { $0.id == id }) else {return .none}
        state.tappedShopInfo = shopInfo
        return .none
        
        
        
      case let .tappedBookMark(id):
        guard let oldShopInfo = state.shopList[id: id] else { return .none }
//          .first(where: { $0.id == id }) else { return .none }
//        let shopIndex = state.shopList.firstIndex(of: oldShopInfo) else { return .none }
        let changeBookmarkStateTo = !oldShopInfo.like
        let newShopInfo = oldShopInfo.changeBookMarkState()
        
        if oldShopInfo == state.tappedShopInfo {
          state.tappedShopInfo = newShopInfo
        }
        
        state.shopList[id: id] = state.shopList[id: id]?.changeBookMarkState()
        
        // local에서 바꾼 뒤, 서버 요청
        
//        let new =  .changeBookMarkState()
//        
//        if !new.like {
//          alertService.showAlert("내 장소에서 삭제하였습니다")
//        }
//        
//        guard let old = state.mapSheet.shopList.first(where: { $0.id == id }) else {return .none}
//        
//        guard let index = state.mapSheet.shopList.firstIndex(of: old) else {return .none}
//        
//        let new = old.changeBookMarkState()
//        state.mapSheet.shopList[index] = new
//        if !new.like {
//          alertService.showAlert("내 장소에서 삭제하였습니다")
//        }
        
        return .run { _ in
          let result = await mapService.toggleBookMark(id)
          switch result {
          case .success:
            if !changeBookmarkStateTo {
              alertService.showAlert("내 장소에서 삭제하였습니다")
            }
          case .failure: break
          }
        }
        
      default: return .none
      }
    }
  }
}
