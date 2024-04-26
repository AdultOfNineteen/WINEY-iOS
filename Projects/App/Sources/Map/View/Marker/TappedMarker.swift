//
//  TappedMarker.swift
//  Winey
//
//  Created by 박혜운 on 4/3/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI

struct TappedMarker: View {
  let category: ShopCategoryType
  
  var body: some View {
    WineyAsset
      .Assets
      .markerBackground
      .swiftUIImage
      .resizable()
      .frame(width: 40, height: 60)
      .overlay(
        alignment: .top,
        content: {
          VStack {
            Spacer()
              .frame(height: 3)
            Image(category.imageTitle)
              .resizable()
              .frame(
                width: 32,
                height: 32
              )
          }
        }
      )
  }
}

#Preview {
  TappedMarker(category: .bottleShop)
}
