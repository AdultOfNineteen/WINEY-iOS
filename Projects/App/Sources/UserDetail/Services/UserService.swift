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
  public var nickname: () async -> Result<UserNicknameDTO, Error>
  public var patchNickname: (_ nickname: String) async -> Result<VoidResponse, Error>
  public var signOut: (_ userId: Int, _ reason: String) async -> Result<SignOutDTO, Error>
  public var logout: (_ deviceId: String) async -> Result<String, Error>
  public var connections: () async -> Result<VoidResponse, Error>
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
      },
      
      nickname: {
        let dtoResult = await Provider<UserAPI>
          .init()
          .request(
            UserAPI.nickname,
            type: UserNicknameDTO.self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(dto)
        case let .failure(error):
          return .failure(error)
        }
      },
      
      patchNickname: { nickname in
        let dtoResult = await Provider<UserAPI>
          .init()
          .request(
            UserAPI.patchNickname(nickname: nickname),
            type: VoidResponse.self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(dto)
        case let .failure(error):
          return .failure(error)
        }
      },
      
      signOut: { userId, reason in
        let dtoResult = await Provider<UserAPI>
          .init()
          .request(
            UserAPI.signOut(userId: userId, reason: reason),
            type: SignOutDTO.self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(dto)
        case let .failure(error):
          return .failure(error)
        }
      },
      
      logout: { deviceId in
        let dtoResult = await Provider<UserAPI>
          .init()
          .request(
            UserAPI.logout(deviceId: deviceId),
            type: String.self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(dto)
        case let .failure(error):
          return .failure(error)
        }
      }, 
      connections: {
        return await Provider<UserAPI>
          .init()
          .request(
            UserAPI.connections,
            type: VoidResponse.self
          )
      }
    )
  }()
}

extension UserService: DependencyKey {
  public static var liveValue = Self.live
  // public static var previewValue = Self.mock
}

extension DependencyValues {
  var user: UserService {
    get { self[UserService.self] }
    set { self[UserService.self] = newValue }
  }
}
