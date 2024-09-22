//
//  SetWindowBackgroundColor.swift
//  WineyKit
//
//  Created by 박혜운 on 1/31/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI

public func setWindowBackgroundColor(_ color: Color) {
  guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
  let window = windowScene.windows.first else { return }
  window.backgroundColor = UIColor(color)
}
