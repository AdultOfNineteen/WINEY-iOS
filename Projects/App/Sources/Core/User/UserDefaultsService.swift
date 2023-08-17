//
//  UserDefaultsService.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import CombineExt
import ComposableArchitecture
import Foundation

public enum UserDefaultsKey: String {
  case registered // 등록 정보
  case hasLaunched // 아직 사용 X 
  case userID
}

public struct UserDefaultsService {
  public let save: (UserDefaultsKey, Bool) -> Effect<Void, Never>
  public let load: (UserDefaultsKey) -> Effect<Bool, Never>
  public let saveUserID: (String) -> Effect<Void, Never>
  
  private init(
    save: @escaping (UserDefaultsKey, Bool) -> Effect<Void, Never>,
    load: @escaping (UserDefaultsKey) -> Effect<Bool, Never>,
    saveUserID: @escaping (String) -> Effect<Void, Never>
  ) {
    self.save = save
    self.load = load 
    self.saveUserID = saveUserID
  }
}

public extension UserDefaultsService {
  static var live = Self.init(
    save: { key, value in
      return Publishers.Create<Void, Never>(factory: { subscriber -> Cancellable in
        subscriber.send(UserDefaults.standard.set(value, forKey: key.rawValue))
        subscriber.send(completion: .finished)
        return AnyCancellable({})
      })
      .eraseToEffect()
    },
    load: { key in
      return Publishers.Create<Bool, Never>(factory: { subscriber -> Cancellable in
        subscriber.send(UserDefaults.standard.bool(forKey: key.rawValue))
        subscriber.send(completion: .finished)
        return AnyCancellable({})
      })
      .eraseToEffect()
    },
    saveUserID: { value in
      return Publishers.Create<Void, Never>(factory: { subscriber -> Cancellable in
        subscriber.send(UserDefaults.standard.set(value, forKey: UserDefaultsKey.userID.rawValue))
        subscriber.send(completion: .finished)
        return AnyCancellable({})
      })
      .eraseToEffect()
    }
  )
}
