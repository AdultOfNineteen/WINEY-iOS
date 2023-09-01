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
  let action: () -> Void

  public init(
    title: String,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.action = action
  }
  
  public var body: some View {
    Button(title, action: action)
      .buttonStyle(MainAnalysisButtonStyle())
  }
}

struct MainAnalysisButton_Previews: PreviewProvider {
  static var previews: some View {
    MainAnalysisButton(
      title: "분석하기",
      action: {}
    )
  }
}
