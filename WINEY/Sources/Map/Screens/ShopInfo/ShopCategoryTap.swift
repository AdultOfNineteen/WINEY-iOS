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
    ScrollView(.horizontal) {
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
        }
      }
      .padding(
        .horizontal, WineyGridRules.globalHorizontalPadding
      )
    }
    .scrollIndicators(.hidden)
  }
}

struct ShopCategoryTap: View {
  var categoryType: ShopCategoryType
  @Binding var isTappedCategory: ShopCategoryType
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 42)
        .fill(
          categoryType == isTappedCategory ? .wineyMain2 : .wineyGray900
        )
        .frame(width: 58, height: 35)
      
      Text(categoryType.title)
        .wineyFont(.captionB1)
        .foregroundColor(.wineyGray50)
    }
  }
}

#Preview {
  ShopCategoryListTap(
    isTappedCategory: .constant(.all)
  )
}
