//
//  SocialLoginRequestDTO.swift
//  Winey
//
//  Created by 박혜운 on 2023/09/25.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation

public struct SocialLoginRequestDTO: Encodable {
  let accessToken: String
  
  public init(_ accessToken: String) {
    self.accessToken = accessToken
  }
}
