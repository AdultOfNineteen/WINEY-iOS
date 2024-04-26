//
//  BottomSheetCategoryTitleView.swift
//  Winey
//
//  Created by 박혜운 on 3/26/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI
import WineyKit

struct BottomSheetCategoryTitle: View {
  private let title: String
  private let savesShopCount: String
  
  init(
    title: String,
    savesShopCount: String
  ) {
    self.title = title
    self.savesShopCount = savesShopCount
  }
  
  var body: some View {
    VStack(spacing: 6) {
      HStack(spacing: 4) {
        Text(title)
          .wineyFont(.title2)
          .foregroundStyle(WineyKitAsset.gray50.swiftUIColor)
        
        WineyAsset.Assets.whiteMarker.swiftUIImage
      }
      
      Text("저장 \(savesShopCount)개")
        .wineyFont(.captionM1)
        .foregroundStyle(WineyKitAsset.gray700.swiftUIColor)
    }
  }
}

#Preview {
  BottomSheetCategoryTitle(
    title: "내 장소",
    savesShopCount: "0"
  )
}
