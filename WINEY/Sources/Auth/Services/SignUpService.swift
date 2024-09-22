//
//  SignUpService.swift
//  Winey
//
//  Created by 박혜운 on 2023/10/06.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Dependencies
import UserInfoData
import WineyNetwork
import Foundation

public struct SignUpService {
  public var sendCode: (
    _ userId: String,
    _ phoneNumber: String
  ) async -> Result<VoidResponse, Error>
  
  public var codeConfirm: (
    _ userId: String,
    _ phoneNumber: String,
    _ code: String
  ) async -> Result<VoidResponse, Error> // View가 요구하는 타입으로 변환 후 전달
  
  public var settingFlavor: (
    _ userId: String,
    _ chocolate: String,
    _ coffee: String,
    _ fruit: String
  ) async -> Result<VoidResponse, Error>
}

extension SignUpService {
  static let live = {
    return Self(
      sendCode: { userId, phoneNumber in
        return await Provider<UserAPI>
          .init()
          .request(
            UserAPI.sendCode(
              userId: userId,
              phoneNumber: phoneNumber.filter{ $0.isNumber }
            ),
            type: VoidResponse.self
          )
      },
      
      codeConfirm: { userId, phoneNumber, code in
        return await Provider<UserAPI>
          .init()
          .request(
            UserAPI.codeConfirm(
              userId: userId,
              phoneNumber: phoneNumber.filter{ $0.isNumber },
              verificationCode: code
            ),
            type: VoidResponse.self
          )
      },
      
      settingFlavor: { userId, chocolate, coffee, fruit in
        return await Provider<PreferenceAPI>
          .init()
          .request(
            PreferenceAPI.socialLogin(
              userId: userId,
              chocolate: chocolate.uppercased(),
              coffee: coffee.uppercased(),
              fruit: fruit.uppercased()
            ),
            type: VoidResponse.self
          )
      }
    )
  }()
    static let mock = Self(
      sendCode: { userId, phoneNumber in
        return .success(.init())
      },
      codeConfirm: { userId, phoneNumber, code in
        return .success(.init())
      },
      settingFlavor: { userId, chocolate, coffee, fruit in
        return .success(.init())
      }
    )
}

extension SignUpService: DependencyKey {
  public static var liveValue = Self.live
  public static var previewValue = Self.mock
}

extension DependencyValues {
  var signUp: SignUpService {
    get { self[SignUpService.self] }
    set { self[SignUpService.self] = newValue }
  }
}
