//
//  PreferenceService.swift
//  Winey
//
//  Created by 박혜운 on 2023/10/06.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Dependencies
import Foundation
import WineyNetwork

public struct PreferenceService {
  public var settingFlavor: (
    _ userId: String,
    _ chocolate: String,
    _ coffee: String,
    _ fruit: String
  ) async -> Result<VoidResponse, Error>
}

extension PreferenceService {
  static let live = {
    return Self(
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
  //  static let mock = Self(…)
  //  static let unimplemented = Self(…)
}

extension PreferenceService: DependencyKey {
  public static var liveValue = Self.live
}

extension DependencyValues {
  var preference: PreferenceService {
    get { self[PreferenceService.self] }
    set { self[PreferenceService.self] = newValue }
  }
}
