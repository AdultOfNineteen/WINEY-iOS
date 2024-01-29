//
//  UserService.swift
//  MyPageFeature
//
//  Created by 정도현 on 1/30/24.
//

import Dependencies
import Foundation
import WineyNetwork

public struct UserService {
  public var info: () async -> Result<UserInfoDTO, Error>
}

extension UserService {
  static let live = {
    return Self(
      info: {
        let dtoResult = await Provider<UserAPI>
          .init()
          .request(
            UserAPI.userInfo,
            type: UserInfoDTO.self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(dto)
        case let .failure(error):
          return .failure(error)
        }
      }
    )
  }()
  
  static let mock = {
    return Self(
      info: {
        return .success(
          UserInfoDTO(userId: 22, status: "ACTIVATE")
        )
      }
    )
  }()
  //  static let unimplemented = Self(…)
}

extension UserService: DependencyKey {
  public static var liveValue = Self.live
  public static var previewValue = Self.mock
}

extension DependencyValues {
  var user: UserService {
    get { self[UserService.self] }
    set { self[UserService.self] = newValue }
  }
}
