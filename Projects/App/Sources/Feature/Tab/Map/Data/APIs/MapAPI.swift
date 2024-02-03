//
//  MapAPI.swift
//  Winey
//
//  Created by 박혜운 on 2/3/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation
import WineyNetwork

public enum MapAPI {
  case shops(
    shopCategory: ShopCategoryType,
    latitude: Double,
    longitude: Double,
    leftTopLatitude: Double,
    leftTopLongitude: Double,
    rightBottomLatitude: Double,
    rightBottomLongitude: Double
  )
  
  case bookmark(
    shopId: Int
  )
}

extension MapAPI: EndPointType {
  public var baseURL: String {
    return .baseURL
  }
  
  public var path: String {
    switch self {
    case .shops:
      return "/shops"
      
    case let .bookmark(shopId):
      return "/shops/bookmark/\(shopId)"
    }
  }
  
  public var method: WineyNetwork.HTTPMethod {
    switch self {
    case .shops, .bookmark:
      return .post
    }
  }
  
  public var task: WineyNetwork.HTTPTask {
    switch self {
      
    case let .shops(
      shopCategory,
      latitude, longitude,
      leftTopLatitude, leftTopLongitude, rightBottomLatitude, rightBottomLongitude
    ):
      let urlParameters = ["shopFilter": shopCategory.query]
      let bodyParameters = [
        "latitude": latitude,
        "longitude": longitude,
        "leftTopLatitude": leftTopLatitude,
        "leftTopLongitude": leftTopLongitude,
        "rightBottomLatitude": rightBottomLatitude,
        "rightBottomLongitude": rightBottomLongitude
      ]
      
      return .requestCompositeParameters(
        urlParameters: urlParameters,
        bodyParameters: bodyParameters
      )
      
    case .bookmark:
      return .requestPlain
    }
  }
}
