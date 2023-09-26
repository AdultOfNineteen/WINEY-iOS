//
//  WineCardBackground.swift
//  WineyKit
//
//  Created by 정도현 on 2023/08/27.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

struct WineCardBackground: View {
  var wineBackgroundComponent: WineBackgroundColor
  
  var body: some View {
    GeometryReader { geo in
      ZStack {
        RoundedRectangle(cornerRadius: 10)
          .frame(width: geo.size.width - 35, height: 383)
          .foregroundColor(wineBackgroundComponent.backgroundColor)
        
        Circle()
          .fill(
            LinearGradient(
              gradient: Gradient(
                colors: [wineBackgroundComponent.firstCircleStart, wineBackgroundComponent.firstCircleEnd.opacity(0)]
              ),
              startPoint: .top, endPoint: .bottom
            )
          )
          .frame(width: 157, height: 157)
          .offset(x: -30, y: -50)
          
        Circle()
          .fill(
            wineBackgroundComponent.secondCircle
          )
          .frame(width: 157, height: 157)
          .offset(x: 30, y: 50)
      }
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
