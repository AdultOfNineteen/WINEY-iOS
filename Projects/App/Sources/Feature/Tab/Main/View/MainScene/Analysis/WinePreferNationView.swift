//
//  WinePreferNationView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WinePreferNationView: View {
  public var body: some View {
    GeometryReader { geo in
      VStack(spacing: 0) {
        Text("선호 국가")
          .wineyFont(.title2)
          .padding(.top, 66)
        
        HStack {
          Spacer().frame(width: 48)
          
          WineBottle(nationName: "이탈리아", count: 3, rank: 1)
          Spacer()
          
          WineBottle(nationName: "미국", count: 1, rank: 2)
          Spacer()
          
          WineBottle(nationName: "이탈리아", count: 1, rank: 3)
          Spacer().frame(width: 48)
        }
        .padding(.top, 44)
        
        Spacer()
        
        WineyAsset.Assets.arrowBottom.swiftUIImage
          .padding(.bottom, 64)
      }
    }
  }
}

public struct WineBottle: View {
  @State var countAnimation = 0
  var nationName: String
  var count: Int
  var rank: Int
  
  public var body: some View {
    // MARK: WINE BOTTLE
    ZStack(alignment: .center) {
      WineyAsset.Assets.wineBottle.swiftUIImage
      
      VStack(spacing: 0) {
        Spacer()
        
        Rectangle()
          .fill(
            rank == 1 ?
            LinearGradient(
              colors: [
                WineyKitAsset.main1.swiftUIColor,
                WineyKitAsset.main2.swiftUIColor
              ],
              startPoint: .top,
              endPoint: .bottom) :
              LinearGradient(
                colors: [
                  WineyKitAsset.main1.swiftUIColor
                ],
                startPoint: .top,
                endPoint: .bottom)
          )
          .padding(.horizontal, 6)
          .frame(width: 53, height: CGFloat(countAnimation * 40))
          .padding(.bottom, 16)
        
        Text("\(nationName)(\(count)회)")
          .wineyFont(.bodyB2)
          .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
      }
      .offset(y: 26)
      .frame(height: 208)
    }
    .onAppear {
      withAnimation(.easeOut(duration: 1.0)) {
        countAnimation = count
      }
    }
  }
}

public struct WinePreferNationView_Previews: PreviewProvider {
  public static var previews: some View {
    WinePreferNationView()
  }
}
