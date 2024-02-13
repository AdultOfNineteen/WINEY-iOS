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
  let userId: Int
  let accessToken: String
  let refreshToken: String
  let userStatus: String
  let messageStatus: String
  let preferenceStatus: String
}
