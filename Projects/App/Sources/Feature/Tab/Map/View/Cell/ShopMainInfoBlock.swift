//
//  ShopMainInfoBlock.swift
//  Winey
//
//  Created by 박혜운 on 2/3/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI
import WineyKit

struct ShopMainInfoBlock: View {
  
  enum ShopInfoBlockType {
    case short
    case detail
  }
  
  private let shopId: Int
  private let shopMoods: [String]
  private let type: ShopInfoBlockType
  @Binding var isBookmarked: Bool
  
  public init(
    type: ShopInfoBlockType,
    shopId: Int,
    shopMoods: [String],
    isBookmarked: Binding<Bool>
  )
  {
    self.type = type
    self.shopId = shopId
    self.shopMoods = shopMoods
    self._isBookmarked = isBookmarked
  }
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        HStack(spacing: 8) {
          Text("모이니 와인바")
            .wineyFont(.headLine)
            .foregroundColor(
              WineyKitAsset.gray50.swiftUIColor
            )
          
          Text("와인바")
            .wineyFont(.captionM1)
            .foregroundColor(
              WineyKitAsset.gray500.swiftUIColor
            )
          
          Spacer()
          
          VStack {
            Spacer()
              .frame(height: 4)
            Button(
              action: {
                isBookmarked.toggle()
              },
              label: {
                Group {
                  if isBookmarked {
                    WineyAsset.Assets.fillMarker.swiftUIImage
                      .resizable()
                  } else {
                    WineyAsset.Assets.emptyMarker.swiftUIImage
                      .resizable()
                  }
                }
                .frame(width: 24, height: 25)
              }
            )
          }
        }
        .padding(.bottom, 7)
        
        Text("서울시 마포구 신공덕동")
          .wineyFont(.captionM1)
          .foregroundColor(
            WineyKitAsset.gray700.swiftUIColor
          )
          .padding(.bottom, 14)
        
        HStack(spacing: 5) {
          ForEach(type == .short ? Array(shopMoods.prefix(3)) : Array(shopMoods), id: \.self) { mode in
            Text(mode)
              .wineyFont(.captionM1)
              .foregroundColor(
                WineyKitAsset.gray500.swiftUIColor
              )
              .frame(minWidth: 0, maxWidth: .infinity)
              .padding(.horizontal, 12)
              .padding(.vertical, 4.5)
              .fixedSize()
              .overlay(
                RoundedRectangle(cornerRadius: 24)
                  .stroke(WineyKitAsset.gray800.swiftUIColor, lineWidth: 1)
              )
          }
        }
      }
//      .fixedSize()
      
      Spacer()
    }
  }
}
