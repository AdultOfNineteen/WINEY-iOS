//
//  UserAPI.swift
//  Winey
//
//  Created by 박혜운 on 2023/09/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation
import WineyNetwork

public enum UserAPI {
  case socialLogin(socialType: String, accessToken: String)
  case sendCode(userId: String, phoneNumber: String)
  case codeConfirm(userId: String, phoneNumber: String, verificationCode: String)
}

extension UserAPI: EndPointType {
  public var baseURL: String {
    return .baseURL
  }
  
  public var path: String {
    switch self {
    case let .socialLogin(type, _):
      return "/login/\(type)"
    case let .sendCode(userId, _):
      return "/users/\(userId)/phone/code/send"
    case let .codeConfirm(userId, _, _):
      return "/users/\(userId)/phone/code/verify"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .socialLogin, .sendCode, .codeConfirm:
      return .post
    }
  }
  
  public var task: HTTPTask {
    switch self {
    case let .socialLogin(_, token):
      let requestDTO = SocialLoginRequestDTO(token)
      return .requestJSONEncodable(requestDTO)
      
    case let .sendCode(_, phoneNumber):
      let parameters = [
        "phoneNumber": phoneNumber
      ]
      return .requestParameters(parameters: parameters, encoding: .jsonBody)
      
    case let .codeConfirm(_, phoneNumber, verificationCode):
      let parameters = [
        "phoneNumber": phoneNumber,
        "verificationCode": verificationCode
      ]
      return .requestParameters(parameters: parameters, encoding: .jsonBody)
    }
  }
}
