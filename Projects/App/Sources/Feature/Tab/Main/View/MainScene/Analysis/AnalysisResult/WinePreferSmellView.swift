//
//  WinePreferSmellView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/18.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

public struct WinePreferSmellView: View {
  public var body: some View {
    GeometryReader { geo in
      VStack(spacing: 0) {
        WineAnalysisTitle(title: "선호하는 향")
          .padding(.top, 66)
        
        WinePreferSmellContentView()
          .padding(.top, 16)
        
        Spacer()
        
        WineyAsset.Assets.arrowBottom.swiftUIImage
          .padding(.bottom, 64)
      }
      .frame(width: geo.size.width)
    }
  }
}

public struct WinePreferSmellContentView: View {
  @State var opacity: CGFloat = 0.0
  
  public var body: some View {
    GeometryReader { geo in
      ZStack {
        WinePreferCircleBackground()
        
        Text("유칼립투스")
          .wineyFont(.title2)
          .foregroundColor(WineyKitAsset.main3.swiftUIColor)
          .offset(x: 0, y: 0)
        
        Text("꽃")
          .wineyFont(.bodyB1)
          .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
          .offset(x: geo.size.width / 6, y: -60)
        
        Text("사과")
          .wineyFont(.bodyB1)
          .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
          .offset(x: geo.size.width / 7, y: 50)
        
        Text("가죽")
          .wineyFont(.bodyB1)
          .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
          .offset(x: -geo.size.width / 7, y: 60)
        
        Text("꿀")
          .wineyFont(.bodyB1)
          .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
          .offset(x: -geo.size.width / 4, y: -30)
        
        Text("바닐라")
          .wineyFont(.bodyB1)
          .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
          .offset(x: geo.size.width / 3.2, y: -20)
        
        Text("흙")
          .wineyFont(.bodyB1)
          .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
          .offset(x: -geo.size.width / 2.8, y: 30)
      }
      .opacity(opacity)
      .frame(width: geo.size.width, height: geo.size.height)
      .onAppear {
        withAnimation(.easeIn(duration: 1.0)) {
          opacity = 1.0
        }
      }
    }
  }
}

public struct WinePreferCircleBackground: View {
  public var body: some View {
    GeometryReader { geo in
      ZStack {
        Circle()
          .fill(Color(red: 81/225, green: 35/225, blue: 223/225).opacity(0.5))
          .frame(width: geo.size.width / 3)
          .blur(radius: 40)
      }
      .frame(width: geo.size.width, height: geo.size.height)
    }
  }
}

struct WinePreferSmellView_Previews: PreviewProvider {
  static var previews: some View {
    WinePreferSmellView()
  }
}
