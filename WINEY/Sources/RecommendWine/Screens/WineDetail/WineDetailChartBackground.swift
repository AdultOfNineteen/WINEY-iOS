//
//  WineDetailChartBackground.swift
//  Winey
//
//  Created by 정도현 on 2023/09/14.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

public struct WineDetailChartBackground: View {
  public var body: some View {
    GeometryReader { geo in
      let lineStartX = 0
      let lineCenterY = Int(geo.size.height) / 2
      
      Path { path in
        let lineTopLeft = CGPoint(x: lineStartX, y: lineCenterY)
        let lineTopRight = CGPoint(x: CGFloat(lineStartX) + geo.size.width, y: lineTopLeft.y)
        path.move(to: lineTopLeft)
        path.addLine(to: lineTopRight)
      }
      .stroke(.wineyGray800, lineWidth: 1)
      
      Path { path in
        let lineTopLeft = CGPoint(x: lineStartX, y: lineCenterY - 30)
        let lineTopRight = CGPoint(x: lineTopLeft.x + 14, y: lineTopLeft.y)
        path.move(to: lineTopLeft)
        path.addLine(to: lineTopRight)
      }
      .stroke(.wineyGray800, lineWidth: 1)
      
      Path { path in
        let lineTopLeft = CGPoint(x: lineStartX, y: lineCenterY - 60)
        let lineTopRight = CGPoint(x: lineTopLeft.x + 14, y: lineTopLeft.y)
        path.move(to: lineTopLeft)
        path.addLine(to: lineTopRight)
      }
      .stroke(.wineyGray800, lineWidth: 1)
      
      Path { path in
        let lineTopLeft = CGPoint(x: lineStartX, y: lineCenterY - 90)
        let lineTopRight = CGPoint(x: lineTopLeft.x + 14, y: lineTopLeft.y)
        path.move(to: lineTopLeft)
        path.addLine(to: lineTopRight)
      }
      .stroke(.wineyGray800, lineWidth: 1)
      
      Path { path in
        let lineTopLeft = CGPoint(x: lineStartX, y: lineCenterY - 120)
        let lineTopRight = CGPoint(x: lineTopLeft.x + 14, y: lineTopLeft.y)
        path.move(to: lineTopLeft)
        path.addLine(to: lineTopRight)
      }
      .stroke(.wineyGray800, lineWidth: 1)
      
      Path { path in
        let lineTopLeft = CGPoint(x: lineStartX, y: lineCenterY - 150)
        let lineTopRight = CGPoint(x: lineTopLeft.x + 14, y: lineTopLeft.y)
        path.move(to: lineTopLeft)
        path.addLine(to: lineTopRight)
      }
      .stroke(.wineyGray800, lineWidth: 1)
      
      Path { path in
        let lineTop = CGPoint(x: lineStartX, y: lineCenterY - 180)
        let lineBottom = CGPoint(x: lineStartX, y: lineCenterY)
        path.move(to: lineTop)
        path.addLine(to: lineBottom)
      }
      .stroke(.wineyGray800, lineWidth: 1)
    }
  }
}

struct WineDetailGraphBackground_Previews: PreviewProvider {
  static var previews: some View {
    WineDetailChartBackground()
  }
}

