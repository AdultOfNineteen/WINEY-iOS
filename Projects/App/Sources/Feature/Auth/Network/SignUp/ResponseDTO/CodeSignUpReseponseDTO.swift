//
//  CodeSignUpReseponseDTO.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation

public struct CodeSignUpReseponseDTO: Decodable {
  public enum ResponseType: Decodable {
    case completed
    case alreadySignUp
  }
  public let signupResult: ResponseType
}
