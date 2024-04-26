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
  
  private let type: ShopInfoBlockType
  private var shopInfo: ShopMapDTO
  @Binding var isBookmarked: Bool
  
  public init(
    type: ShopInfoBlockType,
    shopInfo: ShopMapDTO,
    isBookmarked: Binding<Bool>
  )
  {
    self.type = type
    self.shopInfo = shopInfo
    self._isBookmarked = isBookmarked
  }
  
  var body: some View {
    HStack {
      VStack(
        alignment: .leading,
        spacing: 0
      ) {
        HStack(spacing: 8) {
          Text(shopInfo.name)
            .wineyFont(.headLine)
            .foregroundColor(
              WineyKitAsset.gray50.swiftUIColor
            )
            .frame(height: 23)
          
          Text(shopInfo.shopType)
            .wineyFont(.captionM1)
            .foregroundColor(
              WineyKitAsset.gray500.swiftUIColor
            )
          
          Spacer()
          
          VStack(spacing: 0) {
            Spacer()
              .frame(height: 4)
            Button(
              action: {
                isBookmarked = !isBookmarked
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
        
        Text(shopInfo.address)
          .wineyFont(.captionM1)
          .foregroundColor(
            WineyKitAsset.gray700.swiftUIColor
          )
          .padding(.bottom, 14)
        
        HStack(spacing: 5) {
          ForEach(
            type == .short ? Array(
              shopInfo
                .shopMoods
                .prefix(3)
            ) : Array(
              shopInfo
                .shopMoods
            ),
            id: \.self
          ) { mode in
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
        .padding(.leading, 1)
        .frame(height: 26)
      }
      
      Spacer()
    }
  }
}

#Preview {
  ShopMainInfoBlock(
    type: .short,
    shopInfo: .dummy,
    isBookmarked: .constant(true)
  )
}
