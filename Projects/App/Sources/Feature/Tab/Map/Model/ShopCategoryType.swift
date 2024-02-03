//
//  ShopCategory.swift
//  Winey
//
//  Created by 박혜운 on 1/31/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation

public enum ShopCategoryType: CaseIterable {
  case all
  case myPlace
  case bottleShop
  case wineBar
  case restaurant
  
  var title: String {
    switch self {
    case .all:
      return "전체"
    case .myPlace:
      return "내 장소"
    case .bottleShop:
      return "바틀샵"
    case .wineBar:
      return "와인바"
    case .restaurant:
      return "음식점"
    }
  }
  
  var query: String {
    switch self {
    case .all:
      return "ALL"
    case .myPlace:
      return "LIKE"
    case .bottleShop:
      return "BOTTLE_SHOP"
    case .wineBar:
      return "BAR"
    case .restaurant:
      return "RESTAURANT"
    }
  }
}
