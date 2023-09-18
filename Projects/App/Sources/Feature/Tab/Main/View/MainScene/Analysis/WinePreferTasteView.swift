//
//  WinePreferView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/18.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

public struct WinePreferTasteView: View {
  let wines: [WineRankData] = [
    WineRankData(id: 1, rank: .rank1, wineName: "프리미티보", percentage: 74),
    WineRankData(id: 2, rank: .rank2, wineName: "메들로", percentage: 12),
    WineRankData(id: 3, rank: .rank3, wineName: "까르베네 소비뇽", percentage: 6)
  ]
  
  public var body: some View {
    GeometryReader { geo in
      VStack(spacing: 0) {
        Text("선호 품종")
          .wineyFont(.title2)
          .padding(.top, 66)
        
        WinePreferTasteCirlcePositionView(wineData: wines)
        
        Spacer()
        WineyAsset.Assets.arrowBottom.swiftUIImage
          .padding(.bottom, 64)
      }
      .frame(width: geo.size.width)
    }
  }
}

public struct WinePreferTasteCirlcePositionView: View {
  var wineData: [WineRankData]
  
  public var body: some View {
    GeometryReader { geo in
      ZStack {
        ForEach(wineData) { wine in
          WinePreferTasteCirlceView(wine: wine)
            .offset(x: wine.rank.offsetX, y: wine.rank.offsetY)
        }
        .frame(width: geo.size.width, height: geo.size.height)
      }
    }
  }
}


public struct WinePreferTasteCirlceView: View {
  var wine: WineRankData
  @State var radiusAnimation = 0.0
  
  public var body: some View {
    ZStack {
      Circle()
        .fill(
          LinearGradient(
            colors: [wine.rank.circleGraphStartColor, wine.rank.circleGraphEndColor],
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .frame(width: radiusAnimation)
      
      VStack(spacing: 0) {
        Text(wine.wineName)
          .frame(width: wine.rank.circleRadius - 20)
          .multilineTextAlignment(.center)
        
        if wine.rank.rawValue == 1 {
          Text("\(wine.percentage)%")
            .padding(.top, 8)
        }
      }
      .wineyFont(wine.rank.circleFont)
      .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
    }
    .onAppear {
      withAnimation(.easeIn(duration: 1.0)) {
        radiusAnimation = wine.rank.circleRadius
      }
    }
  }
}

public struct WinePreferTasteView_Previews: PreviewProvider {
  public static var previews: some View {
    WinePreferTasteView()
  }
}
