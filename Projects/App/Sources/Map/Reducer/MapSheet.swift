//
//  MapSheet.swift
//  Winey
//
//  Created by 박혜운 on 3/28/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture

public struct MapSheet: Reducer {
  public init() {}
  
  public struct State: Equatable {
    @BindingState var selectedCategory: ShopCategoryType = .all
    @BindingState var shopList: [ShopInfoModel]
    @BindingState var isNavigationActive: Bool = false // List -> Cell으로의 이동에 영향
    @BindingState var destination: Action.MapDestination = .shopAll // 네비게이션 상단 바에 영향
    var tappedShopInfo: ShopInfoModel?
  }
  
  public enum Action: BindableAction, Equatable {
    public enum MapDestination: Int {
      case shopAll
      case shopList
      case shopDetail
    }
    
    case binding(BindingAction<State>)
    case destination(MapDestination)
    
    case tappedBookMark(index: Int)
    case tappedShopBusinessHour(Bool)
    case tappedNavigationBackButton
    case tappedShopListCell(id: Int)
  }
  
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
        
      case .tappedBookMark:
        state.tappedShopInfo = state.tappedShopInfo?.changeBookMarkState()
        return .none
        
      default: return .none
      }
    }
    
    
  }
}
