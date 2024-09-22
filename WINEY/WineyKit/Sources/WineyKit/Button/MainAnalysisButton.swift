//
//  MainAnalysisButton.swift
//  WineyKit
//
//  Created by 정도현 on 2023/08/27.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public struct MainAnalysisButton: View {
  let title: String
  let icon: Image
  let action: () -> Void

  public init(
    title: String,
    icon: Image,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.icon = icon
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      HStack(spacing: 3) {
        icon
        Text(title)
      }
    }
    .buttonStyle(MainAnalysisButtonStyle())

  }
}

struct MainAnalysisButton_Previews: PreviewProvider {
  static var previews: some View {
    MainAnalysisButton(
      title: "분석하기",
      icon: Image.init(.analysisIcon),
      action: {}
    )
  }
}
