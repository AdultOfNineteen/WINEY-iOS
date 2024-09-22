//
//  BaseURL.swift
//  WineyNetwork
//
//  Created by 박혜운 on 2023/09/25.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation

public extension String {
  static var baseURL: String {
#if DEBUG
  return "https://dev.winey.shop"
#else
  return "https://prod.winey.shop"
#endif
  }
}
