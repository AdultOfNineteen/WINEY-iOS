//
//  Font+Utils.swift
//  Utils
//
//  Created by 박혜운 on 2023/08/01.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public extension Font {
  static func winey(_ type: WineyFont, size: CGFloat) -> Font {
    return .custom(type.rawValue, size: size)
  }
}
