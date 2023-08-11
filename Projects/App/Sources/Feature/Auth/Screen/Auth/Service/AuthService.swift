//
//  AuthService.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/12.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import Foundation

public struct AuthService {
  public var getAuthPath: () -> Effect<AuthPathType, Error>
  
  private init(
    getAuthPath: @escaping () -> Effect<AuthPathType, Error>
  ) {
    self.getAuthPath = getAuthPath
  }
}
