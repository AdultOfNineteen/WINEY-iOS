//
//  WineChartView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public struct WineChartView: View {
  public var body: some View {
    GeometryReader { geo in
      VStack(spacing: 0) {
        VStack {
          Text("선호 국가")
            .wineyFont(.title2)
            .padding(.top, 66)
          
          Spacer()
          
          HStack {
            Spacer().frame(width: 24)
            
            WineBottle(nationName: "이탈리아", count: 3, rank: 1)
            Spacer()
            
            WineBottle(nationName: "미국", count: 1, rank: 2)
            Spacer()
            
            WineBottle(nationName: "이탈리아", count: 1, rank: 3)
            Spacer().frame(width: 24)
          }
          .padding(.top, 43)
          
          Spacer()
          
          WineyAsset.Assets.arrowBottom.swiftUIImage
            .padding(.bottom, 64)
        }
      }
      .frame(width: geo.size.width)
    }
  }
}

public struct WineChartView_Previews: PreviewProvider {
  public static var previews: some View {
    WineChartView()
  }
}
