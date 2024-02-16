//
//  BadgeBottomSheetContent.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/29/23.
//

import SwiftUI
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
          .foregroundColor(WineyKitAsset.gray200.swiftUIColor)
          .padding(.bottom, 4)

        Text(extractDate(badgeInfo.acquiredAt) ?? "미취득 뱃지")
          .wineyFont(.bodyB2)
          .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
          .padding(.bottom, 13)
        
        Text(badgeInfo.acquiredAt == nil ? badgeInfo.acquisitionMethod : badgeInfo.description)
          .wineyFont(.captionM3)
          .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
      }
      .padding(.horizontal, 72)
      .multilineTextAlignment(.center)
    } else {
      Text("데이터 오류")
        .wineyFont(.bodyB1)
        .foregroundColor(WineyKitAsset.gray200.swiftUIColor)
        .multilineTextAlignment(.center)
    }
  }
  
  private func extractDate(_ dateString: String?) -> String? {
    if let dateString = dateString {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      
      if let date = dateFormatter.date(from: dateString) {
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd"
        return outputDateFormatter.string(from: date)
      } else {
        return nil
      }
    } else {
      return nil
    }
  }
}
