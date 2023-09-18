//
//  WinePriceView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/18.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

struct WinePriceView: View {
  public var body: some View {
    GeometryReader { geo in
      VStack(spacing: 0) {
        Text("가격대")
          .wineyFont(.title2)
        
        WinePriceContentView()
          .padding(.top, 16)
        
        Spacer()
        
        WineyAsset.Assets.arrowTop.swiftUIImage
          .padding(.bottom, 64)
      }
      .padding(.top, 66)
      .frame(width: geo.size.width)
    }
  }
}

struct WinePriceContentView: View {
  public var body: some View {
    GeometryReader { geo in
      ZStack {
        WinePreferCircleBackground()
        
        VStack(spacing: 0) {
          Text("평균 구매가")
            .wineyFont(.captionB1)
            .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
          Text("\(70580) 원")
            .wineyFont(.title1)
            .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
            .padding(.top, 6)
        }
      }
      .frame(width: geo.size.width, height: geo.size.height)
    }
  }
}

struct WinePriceView_Previews: PreviewProvider {
  static var previews: some View {
    WinePriceView()
  }
}
