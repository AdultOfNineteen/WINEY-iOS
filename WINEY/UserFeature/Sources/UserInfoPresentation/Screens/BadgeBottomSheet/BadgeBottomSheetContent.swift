//
//  BadgeBottomSheetContent.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/29/23.
//

import SwiftUI
import UserInfoData
import WineyKit

struct BadgeBottomSheetContent: View {
  let badgeInfo: Badge?
  
  init(badgeInfo: Badge?) {
    self.badgeInfo = badgeInfo
  }
  
  var body: some View {
    if let badgeInfo = badgeInfo {
      VStack(spacing: 0) {
        Text(badgeInfo.name)
          .wineyFont(.bodyB1)
          .foregroundColor(.wineyGray200)
          .padding(.bottom, 4)

        Text(badgeInfo.acquiredAt ?? "미취득 뱃지")
          .wineyFont(.bodyM2)
          .foregroundColor(.wineyGray600)
          .padding(.bottom, 13)
        
        Text(badgeInfo.acquiredAt == nil ? badgeInfo.acquisitionMethod : badgeInfo.description)
          .wineyFont(.captionM3)
          .foregroundColor(.wineyGray600)
          .multilineTextAlignment(.center)
      }
      .padding(.horizontal, 72)
      .multilineTextAlignment(.center)
    } else {
      Text("데이터 오류")
        .wineyFont(.bodyB1)
        .foregroundColor(.wineyGray200)
        .multilineTextAlignment(.center)
    }
  }
}
