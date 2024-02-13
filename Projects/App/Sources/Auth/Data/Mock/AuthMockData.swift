//
//  AuthMockData.swift
//  Winey
//
//  Created by 박혜운 on 2023/09/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation
import WineyNetwork

enum DefaultMockData: MockDataProtocol {
  case loginUserStatusInactive // 미가입
  public var data: Data {
    switch self {
    case .loginUserStatusInactive:
      return data(fileName: "login_inactive", extension: "json")
    }
  }
}
