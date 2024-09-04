//
//  WineAPI.swift
//  Winey
//
//  Created by 박혜운 on 2023/10/12.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation
import WineyNetwork

public enum WineAPI {
  case todaysRecommendations
  case wineDetailInfo(windId: String)
  case wineTip(page: Int, size: Int)
}

extension WineAPI: EndPointType {
  public var baseURL: String {
    return .baseURL
  }
  
  public var path: String {
    switch self {
    case .todaysRecommendations:
      return "/wines/recommend"
    case let .wineDetailInfo(windId):
      return "/wines/\(windId)"
    case .wineTip:
      return "/wine-tip"
    }
  }
  
  public var method: WineyNetwork.HTTPMethod {
    switch self {
    case .todaysRecommendations:
      return .get
    case .wineDetailInfo:
      return .get
    case .wineTip:
      return .get
    }
  }
  
  public var task: WineyNetwork.HTTPTask {
    switch self {
    case .todaysRecommendations:
      return .requestPlain
    case .wineDetailInfo:
      return .requestPlain
    case let .wineTip(page, size):
      return .requestParameters(parameters: ["page": page, "size": size], encoding: .queryString)
    }
  }
}
