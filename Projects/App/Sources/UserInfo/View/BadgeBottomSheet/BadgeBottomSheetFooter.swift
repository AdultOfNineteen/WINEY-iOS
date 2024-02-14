//
//  BadgeBottomSheetFotter.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/29/23.
//

import SwiftUI
import WineyKit

struct BadgeBottomSheetFooter: View {
  private let tappedYesOption: (() -> Void)
  
  init(
    tappedYesOption: @escaping (() -> Void) = {}
  ) {
    self.tappedYesOption = tappedYesOption
  }
  
  var body: some View {
    VStack(spacing: 5) {
      Rectangle()
      .frame(height: 1)
      .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      
      Button("확인") {
        tappedYesOption()
      }
      .foregroundColor(WineyKitAsset.gray100.swiftUIColor)
      .wineyFont(.headLine)
      .frame(height: 55)
    }
  }
}
