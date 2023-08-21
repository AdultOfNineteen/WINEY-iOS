//
//  LoginService.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/12.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import Foundation

public struct LoginService {
  public var getLoginPath: () -> Effect<LoginPathType, Error>
  
  private init(
    getLoginPath: @escaping () -> Effect<LoginPathType, Error>
  ) {
    self.getLoginPath = getLoginPath
  }
}
