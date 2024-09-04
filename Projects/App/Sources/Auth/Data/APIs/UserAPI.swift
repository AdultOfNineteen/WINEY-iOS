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
  case userInfo
  case nickname
  case patchNickname(nickname: String)
  case signOut(userId: Int, reason: String)
  case logout(deviceId: String)
  case connections
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
    case .userInfo:
      return "/info"
    case .nickname:
      return "/nickname"
    case .patchNickname:
      return "/nickname"
    case let .signOut(userId, _):
      return "/users/\(userId)"
    case .logout:
      return "/users/logout"
    case .connections:
      return "/connections"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .socialLogin, .sendCode, .codeConfirm:
      return .post
    case .userInfo:
      return .get
    case .nickname:
      return .get
    case .patchNickname:
      return .patch
    case .signOut:
      return .delete
    case .logout:
      return .get
    case .connections:
      return .get
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
      
    case .nickname:
      return .requestPlain
      
    case let .patchNickname(nickname: nickname):
      return .requestParameters(
        parameters: [
          "nickname": nickname
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
    case .connections:
      return .requestPlain
    }
  }
}
