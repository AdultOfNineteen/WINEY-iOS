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
}

extension UserAPI: EndPointType {
  public var baseURL: String {
    return .baseURL
  }
  
  public var path: String {
    switch self {
    case .userInfo:
      return "/info"
    }
  }
  
  public var method: WineyNetwork.HTTPMethod {
    switch self {
    case .userInfo:
      return .get
    }
  }
  
  public var task: WineyNetwork.HTTPTask {
    switch self {
    case .userInfo:
      return .requestPlain
    }
  }
}
