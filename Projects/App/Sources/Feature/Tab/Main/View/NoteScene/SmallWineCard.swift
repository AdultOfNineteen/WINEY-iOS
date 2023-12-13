//
//  SmallWineCard.swift
//  Winey
//
//  Created by 정도현 on 12/14/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import SwiftUI
import WineyKit

public struct SmallWineCard: View {
  public var wineData: WineCardData
  public var borderColor: Color
  
  public var body: some View {
    VStack(spacing: -10) {
      HStack(spacing: 3) {
        Text(wineData.wineType.typeName)
          .wineyFont(.cardTitle)
        
        WineyAsset.Assets.star1.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 13)
          .offset(y: -2)
        
        Spacer()
      }
      .padding(.leading, 19)
      .padding(.top, 14)
      
      wineData.wineType.illustImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding(.bottom, 4)
    }
    .frame(width: UIScreen.main.bounds.width / 2 - 24 - 15, height: 163)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(Color(red: 63/255, green: 63/255, blue: 63/255).opacity(0.4))
        .background(
          ZStack {
            Circle()
              .fill(
                LinearGradient(
                  colors: [
                    wineData.wineType.backgroundColor.firstCircleStart,
                    wineData.wineType.backgroundColor.firstCircleEnd.opacity(0.25)
                  ],
                  startPoint: .top,
                  endPoint: .bottom
                )
              )
              .frame(height: 70)
              .padding(.trailing, 55)
              .padding(.bottom, 70)
              .blur(radius: 10)
            
            RadialGradient(
              colors: [
                wineData.wineType.backgroundColor.secondCircle,
                .clear
              ],
              center: .center,
              startRadius: 5,
              endRadius: 70
            )
            .padding(.leading, 30)
            .padding(.top, 40)
          }
        )
        .blur(radius: 5)
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(
              LinearGradient(
                colors: [
                  borderColor,
                  borderColor.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              ),
              style: .init(lineWidth: 1)
            )
        )
    )
  }
}

#Preview {
  SmallWineCard(
    wineData: WineCardData(
      id: 1,
      wineType: .rose,
      name: "캄포마리나",
      country: "이탈리아",
      varietal: "test",
      sweetness: 1,
      acidity: 2,
      body: 3,
      tannins: 4,
      wineSummary: WineSummary(
        avgPrice: 1,
        avgSweetness: 2,
        avgAcidity: 3,
        avgBody: 4,
        avgTannins: 5
      )
    ),
    borderColor: Color(red: 150/255, green: 113/255, blue: 1)
  )
}
