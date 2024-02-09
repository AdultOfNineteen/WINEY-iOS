//
//  WineCardBackground.swift
//  WineyKit
//
//  Created by 정도현 on 2023/08/27.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

struct WineCardBackground: View {
  var wineBackgroundComponent: WineBackgroundColor
  
  var body: some View {
    GeometryReader { geo in
      ZStack {
        RoundedRectangle(cornerRadius: 5.4)
          .foregroundStyle(
            wineBackgroundComponent.backgroundColor
          )
          .overlay(
            RoundedRectangle(cornerRadius: 5.4)
              .foregroundStyle(.ultraThinMaterial)
          )
        
        Circle()
          .fill(
            LinearGradient(
              gradient: Gradient(
                colors: [
                  wineBackgroundComponent.firstCircleStart,
                  wineBackgroundComponent.firstCircleEnd.opacity(0.4),
                  .clear
                ]
              ),
              startPoint: .top,
              endPoint: .bottom
            )
          )
          .frame(width: geo.size.width / 2, height: geo.size.width / 2)
          .offset(x: -30, y: -50)
          .blur(radius: 40)
        
        Circle()
          .fill(
            wineBackgroundComponent.secondCircle
          )
          .frame(width: geo.size.width / 2, height: geo.size.width / 2)
          .offset(x: 30, y: 50)
          .blur(radius: 30)
      }
      .frame(width: geo.size.width, height: 393)
    }
  }
}

struct WineCardBackground_Previews: PreviewProvider {
  static var previews: some View {
    WineCardBackground(wineBackgroundComponent: WineBackgroundColor(
      backgroundColor: Color(red: 68/255, green: 16/255, blue: 16/255),
      firstCircleStart: Color(red: 191/255, green: 54/255, blue: 54/255),
      firstCircleEnd: Color(red: 143/255, green: 3/255, blue: 79/255),
      secondCircle: Color(red: 100/255, green: 13/255, blue: 13/255)
    ))
  }
}
