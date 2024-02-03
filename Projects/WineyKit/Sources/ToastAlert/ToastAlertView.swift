//
//  ToastAlertView.swift
//  WineyKit
//
//  Created by 박혜운 on 2/2/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI


// SwiftUI 토스트 뷰
public struct ToastAlertView: View {
  private var message: String
  
  public init(message: String) {
    self.message = message
  }
  
  public var body: some View {
    ZStack {
      Text(message)
        .wineyFont(.bodyB2)
        .padding(.horizontal, 20)
        .padding(.vertical, 13)
        .background(WineyKitAsset.gray900.swiftUIColor.opacity(0.8))
        .foregroundColor(.white)
        .cornerRadius(34)
    }
  }
}
