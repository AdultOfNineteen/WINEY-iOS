//
//  BadgeAPI.swift
//  MyPageFeatureInterface
//
//  Created by 정도현 on 1/25/24.
//

import Foundation
import UIKit
import WineyNetwork

public enum BadgeAPI {
  case badgeList(userId: Int)
  case badgeDetail(userId: Int, badgeId: Int)
}

extension BadgeAPI: EndPointType {
  public var baseURL: String {
    return .baseURL
  }
  
  public var path: String {
    switch self {
    case let .badgeList(userId):
      return "/users/\(userId)/wine-badges"
      
    case let .badgeDetail(userId, badgeId):
      return "/users/\(userId)/wine-badges/\(badgeId)"
    }
  }
  
  public var method: WineyNetwork.HTTPMethod {
    switch self {
    case .badgeList:
      return .get
    case .badgeDetail:
      return .get
    }
  }
  
  public var task: WineyNetwork.HTTPTask {
    switch self {
    case let .badgeList(userId):
      return .requestParameters(
        parameters: ["userId": userId],
        encoding: .queryString
      )
    case let .badgeDetail(userId, badgeId):
      return .requestParameters(
        parameters: [
          "userId": userId,
          "wineBadgeId": badgeId
        ],
        encoding: .queryString
      )
    }
  }
}
