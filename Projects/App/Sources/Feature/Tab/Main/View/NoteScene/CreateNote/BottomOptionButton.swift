//
//  ButtomOptionButton.swift
//  Winey
//
//  Created by 정도현 on 11/12/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import SwiftUI
import WineyKit

public struct BottomOptionButton: View {
  public var validation: Bool
  public var tooltipVisible: Bool
  public var action: () -> Void
  public var skipAction: () -> Void
  
  public var body: some View {
    HStack(spacing: 15) {
      Button {
        skipAction()
      } label: {
        Text("건너뛰기")
          .wineyFont(.headLine)
          .foregroundColor(.white)
          .padding(.vertical, 16.5)
          .padding(.horizontal, 20)
          .background(
            RoundedRectangle(cornerRadius: 5)
              .foregroundStyle(WineyKitAsset.gray950.swiftUIColor)
          )
      }
      
      WineyConfirmButton(title: "다음", validBy: validation) {
        action()
      }
    }
    .overlay(
      ReverseToolTip(content: "건너뛰기를 누르면 내용이 저장되지 않아요.")
        .offset(x: -50, y: -60)
        .opacity(tooltipVisible ? 1.0 : 0.0)
    )
    .padding(.bottom, 20)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
}
