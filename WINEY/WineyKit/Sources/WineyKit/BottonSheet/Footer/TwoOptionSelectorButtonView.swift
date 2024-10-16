//
//  TwoOptionSelectorButtonView.swift
//  WineyKit
//
//  Created by 박혜운 on 2023/09/01.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public struct TwoOptionSelectorButtonView: View {
  let leftTitle: String
  let leftAction: () -> Void
  let rightTitle: String
  let rightAction: () -> Void
  
  public init(
    leftTitle: String,
    leftAction: @escaping () -> Void,
    rightTitle: String,
    rightAction: @escaping () -> Void
  ) {
    self.leftTitle = leftTitle
    self.leftAction = leftAction
    self.rightTitle = rightTitle
    self.rightAction = rightAction
  }
  
  public var body: some View {
    VStack(spacing: 5) {
      Rectangle()
      .frame(height: 1)
      .foregroundColor(.wineyGray700)
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      
      ZStack {
        Rectangle()
          .frame(width: 1, height: 25)
          .foregroundColor(.wineyGray700)
        HStack(spacing: 0) {
          HStack(spacing: 0) {
            Spacer()
            Button(leftTitle) {
              leftAction()
            }
            .foregroundColor(.wineyGray100)
            .wineyFont(.headLine)
            Spacer()
          }
          HStack(spacing: 0) {
            Spacer()
            Button(rightTitle) {
              rightAction()
            }
            .foregroundColor(.wineyGray600)
            .wineyFont(.headLine)
            
            Spacer()
          }
        }
      }
      .frame(height: 55)
    }
  }
}

struct TwoOptionSelectorButtonView_Previews: PreviewProvider {
  static var previews: some View {
    TwoOptionSelectorButtonView(leftTitle: "아니오", leftAction: {}, rightTitle: "예", rightAction: {})
  }
}
