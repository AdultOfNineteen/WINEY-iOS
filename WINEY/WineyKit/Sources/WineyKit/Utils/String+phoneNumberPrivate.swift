//
//  File.swift
//  
//
//  Created by 박혜운 on 9/21/24.
//

import Foundation

public extension String {
  func phoneNumberPrivate() -> String {
    return self.dropLast(4) + "****"
  }
}
