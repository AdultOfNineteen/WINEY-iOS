//
//  UserDefaultsService.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Dependencies
import Foundation

public enum UserDefaultsKey {
  case boolKeys(BoolValues)
  case stringKeys(StringValues)
  
  public enum BoolValues: String {
    case hasLaunched
  }
  
  public enum StringValues: String {
    case userID
    case accessToken
    case refreshToken
    case socialLoginPath
  }
}

public struct UserDefaultService {
  public let saveFlag: (UserDefaultsKey.BoolValues, Bool) -> Void // Bool
  public let saveValue: (UserDefaultsKey.StringValues, String) -> Void // String
  public let loadFalg: (UserDefaultsKey.BoolValues) -> Bool?
  public let loadValue: (UserDefaultsKey.StringValues) -> String?
  
  private init(
    saveFlag: @escaping (UserDefaultsKey.BoolValues, Bool) -> Void, 
    saveValue: @escaping (UserDefaultsKey.StringValues, String) -> Void,
    loadFalg: @escaping (UserDefaultsKey.BoolValues) -> Bool?,
    loadValue: @escaping (UserDefaultsKey.StringValues) -> String?) {
    self.saveFlag = saveFlag
    self.saveValue = saveValue
    self.loadFalg = loadFalg
    self.loadValue = loadValue
  }
}

extension UserDefaultService {
  static let live = Self(
    saveFlag: { key, value in
      UserDefaults.standard.set(value, forKey: key.rawValue)
    },
    saveValue: { key, value in
      UserDefaults.standard.set(value, forKey: key.rawValue)
    },
    loadFalg: { key in
      return UserDefaults.standard.value(forKey: key.rawValue) as? Bool
    },
    loadValue: { key in
      return UserDefaults.standard.value(forKey: key.rawValue) as? String
    }
  )
}

extension UserDefaultService: DependencyKey {
  public static let liveValue: Self = .live
}

extension DependencyValues {
  var userDefaults: UserDefaultService {
    get { self[UserDefaultService.self] }
    set { self[UserDefaultService.self] = newValue }
  }
}
