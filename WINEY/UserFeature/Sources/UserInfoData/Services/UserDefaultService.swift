//
//  Utils.swift
//  Winey
//
//  Created by 박혜운 on 2023/07/31.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Dependencies
import Foundation

public enum UserDefaultsKey {
  case boolKeys(BoolValues)
  case stringKeys(StringValues)
  
  public enum BoolValues: String {
    case hasLaunched
    case isPopGestureEnabled
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
  public let deleteValue: (UserDefaultsKey.StringValues) -> Void // String
  
  public init(
    saveFlag: @escaping (UserDefaultsKey.BoolValues, Bool) -> Void,
    saveValue: @escaping (UserDefaultsKey.StringValues, String) -> Void,
    loadFalg: @escaping (UserDefaultsKey.BoolValues) -> Bool?,
    loadValue: @escaping (UserDefaultsKey.StringValues) -> String?,
    deleteValue: @escaping (UserDefaultsKey.StringValues) -> Void
  ) {
    self.saveFlag = saveFlag
    self.saveValue = saveValue
    self.loadFalg = loadFalg
    self.loadValue = loadValue
    self.deleteValue = deleteValue
  }
}

extension UserDefaultService {
  public static let live = Self(
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
    },
    deleteValue: { key in
      return UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
  )
}

extension UserDefaultService: DependencyKey {
  public static let liveValue: Self = .live
}

extension DependencyValues {
  public var userDefaults: UserDefaultService {
    get { self[UserDefaultService.self] }
    set { self[UserDefaultService.self] = newValue }
  }
}
