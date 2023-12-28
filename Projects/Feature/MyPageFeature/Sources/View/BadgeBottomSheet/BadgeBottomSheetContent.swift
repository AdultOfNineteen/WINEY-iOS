//
//  BadgeBottomSheetContent.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/29/23.
//

import SwiftUI
import WineyKit

struct BadgeBottomSheetContent: View {
  let badgeInfo: BadgeInfoModel
  
  init(badgeInfo: BadgeInfoModel) {
    self.badgeInfo = badgeInfo
  }
  
  var body: some View {
    VStack(spacing: 13) {
      Text(badgeInfo.title)
        .wineyFont(.bodyB1)
        .foregroundColor(WineyKitAsset.gray200.swiftUIColor)

      Text(badgeInfo.date)
        .wineyFont(.bodyB2)
        .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
      
      Text(badgeInfo.description)
        .wineyFont(.captionM3)
        .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
    }
    .multilineTextAlignment(.center)
  }
}
