//
//  LoginUserDTO.swift
//  Winey
//
//  Created by 박혜운 on 2023/09/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation

// MARK: - LoginUserDTO
public struct LoginUserDTO: Decodable, Equatable {
  public let userId: Int
  public let accessToken: String
  public let refreshToken: String
  public let userStatus: String
  public let messageStatus: String
  public let preferenceStatus: String
  
  public init(userId: Int, accessToken: String, refreshToken: String, userStatus: String, messageStatus: String, preferenceStatus: String) {
    self.userId = userId
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.userStatus = userStatus
    self.messageStatus = messageStatus
    self.preferenceStatus = preferenceStatus
  }
}
