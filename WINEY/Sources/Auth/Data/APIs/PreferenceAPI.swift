//
//  PreferenceAPI.swift
//  Winey
//
//  Created by 박혜운 on 2023/10/06.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation
import WineyNetwork

public enum PreferenceAPI {
  case socialLogin(
    userId: String,
    chocolate: String,
    coffee: String,
    fruit: String
  )
}

extension PreferenceAPI: EndPointType {
  public var baseURL: String {
    return .baseURL
  }
  
  public var path: String {
    switch self {
    case let .socialLogin(userId, _, _, _):
      return "/users/\(userId)/preferences"
    }
  }
  
  public var method: WineyNetwork.HTTPMethod {
    switch self {
    case .socialLogin:
      return .patch
    }
  }
  
  public var task: WineyNetwork.HTTPTask {
    switch self {
    case let .socialLogin(_, chocolate, coffee, fruit):
      let parameters = [
        "chocolate": chocolate,
        "coffee": coffee,
        "fruit": fruit
      ]

      return .requestParameters(parameters: parameters, encoding: .jsonBody)
    }
  }
}
