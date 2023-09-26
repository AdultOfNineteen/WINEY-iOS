//
//  LoginAPI.swift
//  Winey
//
//  Created by 박혜운 on 2023/09/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation
import WineyNetwork

public enum AuthAPI {
  case socialLogin(socialType: String, accessToken: String)
}

extension AuthAPI: EndPointType {
  public var baseURL: String {
    return .baseURL
  }
  
  public var path: String {
    switch self {
    case let .socialLogin(type, _):
      return "/login/\(type)"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .socialLogin:
      return .post
    }
  }
  
  public var task: HTTPTask {
    switch self {
    case let .socialLogin(_, token):
      let requestDTO = SocialLoginRequestDTO(token)
      return .requestJSONEncodable(requestDTO)
    }
  }
}
