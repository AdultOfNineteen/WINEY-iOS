//
//  Result + Extension.swift
//  Utils
//
//  Created by 박혜운 on 2023/10/05.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation

public extension Result where Failure: Error {
  var isSuccess: Bool {
    switch self {
    case .success:
      return true
    case .failure:
      return false
    }
  }
}
