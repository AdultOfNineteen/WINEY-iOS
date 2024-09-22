//
//  MapService.swift
//  Winey
//
//  Created by 박혜운 on 2/3/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Dependencies
import Foundation
import SwiftUI
import WineyKit
import WineyNetwork

public struct MapService {
  public var getShopsInfoOf: (
    _ shopCategory: ShopCategoryType,
    _ latitude: Double,
    _ longitude: Double,
    _ leftTopLatitude: Double,
    _ leftTopLongitude: Double,
    _ rightBottomLatitude: Double,
    _ rightBottomLongitude: Double
  ) async -> Result<[ShopMapDTO], Error>
  
  public var toggleBookMark: (
    _ shopId: Int
  ) async -> Result<VoidResponse, Error>
}

extension MapService {
  static let live = {
    return Self(
      getShopsInfoOf: {
        shopCategory,
        latitude, longitude,
        leftTopLatitude, leftTopLongitude, rightBottomLatitude, rightBottomLongitude in
        return await Provider<MapAPI>
          .init()
          .request(
            MapAPI.shops(
              shopCategory: shopCategory,
              latitude: latitude,
              longitude: longitude,
              leftTopLatitude: leftTopLatitude,
              leftTopLongitude: leftTopLongitude,
              rightBottomLatitude: rightBottomLatitude,
              rightBottomLongitude: rightBottomLongitude
            ),
            type: [ShopMapDTO].self
          )
      },
      toggleBookMark: { shopId in
        return await Provider<MapAPI>
          .init()
          .request(
            MapAPI.bookmark(shopId: shopId),
            type: VoidResponse.self
          )
      }
    )
  }()
  //  static let mock = Self(…)
  //  static let unimplemented = Self(…)
}

extension MapService: DependencyKey {
  public static var liveValue = MapService.live
}

public extension DependencyValues {
  var map: MapService {
    get { self[MapService.self] }
    set { self[MapService.self] = newValue }
  }
}
