//
//  MainAnalysisButtonStyle.swift
//  WineyKit
//
//  Created by 정도현 on 2023/08/27.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

struct MainAnalysisButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration
      .label
      .wineyFont(.captionB1)
      .multilineTextAlignment(.center)
      .lineLimit(1)
      .frame(width: 95, height: 33)
      .background(
        RoundedRectangle(cornerRadius: 45)
          .stroke(WineyKitAsset.main2.swiftUIColor)
          .background(
            RoundedRectangle(cornerRadius: 45)
              .fill(WineyKitAsset.mainBackground.swiftUIColor)
          )
      )
      .foregroundColor(WineyKitAsset.main3.swiftUIColor)
  }
}

struct MainAnalysisButtonStyle_Previews: PreviewProvider {
  static var previews: some View {
    Button("분석하기", action: {})
      .buttonStyle(
        MainAnalysisButtonStyle()
      )
  }
}
