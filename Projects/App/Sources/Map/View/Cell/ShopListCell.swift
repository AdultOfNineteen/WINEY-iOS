//
//  ShopListCellView.swift
//  Winey
//
//  Created by 박혜운 on 1/31/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI
import WineyKit

struct ShopListCell: View {
  @Binding var isBookMarked: Bool
  var shopInfo: ShopMapDTO
  
  public init(
    _ info: ShopMapDTO,
    isBookMarked: Binding<Bool>
  ) {
    self.shopInfo = info
    self._isBookMarked = isBookMarked
  }
  
  var body: some View {
    HStack(spacing: 17) {
      AsyncImage(url: URL(string: shopInfo.imgUrl)) { phase in
        if let image = phase.image {
          image
            .resizable()
            .frame(width: 109, height: 98)
            .cornerRadius(10, corners: .allCorners)
            .aspectRatio(contentMode: .fit)
          
        } else if phase.error != nil {
          Image(systemName: "questionmark.diamond")
            .imageScale(.large)
        } else {
          Rectangle()
            .fill(WineyKitAsset.gray800.swiftUIColor)
            .frame(width: 109, height: 98)
            .cornerRadius(10, corners: .allCorners)
        }
      }
      
      ShopMainInfoBlock(
        type: .short,
        shopId: shopInfo.shopId,
        shopMoods: shopInfo.shopMoods,
        isBookmarked: $isBookMarked
      )
    }
    .frame(height: 98)
  }
}
