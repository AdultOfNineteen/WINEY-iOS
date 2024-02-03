//
//  UserAPI.swift
//  MyPageFeature
//
//  Created by 정도현 on 1/30/24.
//

import Foundation
import UIKit
import WineyNetwork

public enum UserAPI {
  case userInfo
  case signOut(userId: Int, reason: String)
  case logout(deviceId: String)
}

extension UserAPI: EndPointType {
  public var baseURL: String {
    return .baseURL
  }
  
  public var path: String {
    switch self {
    case .userInfo:
      return "/info"
    case let .signOut(userId: userId, reason: reason):
      return "/users/\(userId)"
    case let .logout(deviceId: deviceId):
      return "/users/logout"
    }
  }
  
  public var method: WineyNetwork.HTTPMethod {
    switch self {
    case .userInfo:
      return .get
    case .signOut:
      return .delete
    case .logout:
      return .get
    }
  }
  
  public var task: WineyNetwork.HTTPTask {
    switch self {
    case .userInfo:
      return .requestPlain
    case let .signOut(userId: userId, reason: reason):
      return .requestParameters(
        parameters: [
          "userId": userId,
          "reason": reason
        ],
        encoding: .queryString
      )
    case let .logout(deviceId: deviceId):
      return .requestParameters(
        parameters: [
          "deviceId": deviceId
        ],
        encoding: .queryString
      )
    }
  }
}
