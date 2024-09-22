//
//  TokenAPI.swift
//  WineyNetwork
//
//  Created by 박혜운 on 4/25/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation
import UIKit

public enum TokenAPI {
  case refreshToken
}

extension TokenAPI: EndPointType {
  public var baseURL: String {
    return .baseURL
  }
  
  public var path: String {
    switch self {
    case .refreshToken:
      return "/refresh"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .refreshToken:
      return .post
    }
  }
  
  public var task: HTTPTask {
    switch self {
    case .refreshToken:
      return .requestAccessTokenViasRefreshToken
    }
  }
}
