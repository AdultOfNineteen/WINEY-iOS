//
//  ShopCategoryListTap.swift
//  Winey
//
//  Created by 박혜운 on 1/31/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI
import WineyKit

struct ShopCategoryListTap: View {
  @Binding var isTappedCategory: ShopCategoryType
  
  var body: some View {
    HStack {
      ForEach(
        ShopCategoryType.allCases,
        id: \.title
      ) { category in
        ShopCategoryTap(
          categoryType: category,
          isTappedCategory: $isTappedCategory
        )
        .onTapGesture {
          isTappedCategory = category
        }
        if category != .restaurant {
          Spacer()
        }
      }
    }
  }
}

struct ShopCategoryTap: View {
  var categoryType: ShopCategoryType
  @Binding var isTappedCategory: ShopCategoryType
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 42)
        .fill(
          categoryType == isTappedCategory ? WineyKitAsset.main2.swiftUIColor : WineyKitAsset.gray900.swiftUIColor
        )
        .frame(width: 58, height: 35)
      
      Text(categoryType.title)
        .wineyFont(.captionB1)
        .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
    }
  }
}
