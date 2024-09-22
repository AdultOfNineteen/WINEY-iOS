//
//  UIApplecation + Extension.swift
//  WineyKit
//
//  Created by 박혜운 on 2023/09/02.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import UIKit

public extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
