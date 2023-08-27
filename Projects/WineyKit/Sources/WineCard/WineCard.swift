//
//  WineCard.swift
//  WineyKit
//
//  Created by 정도현 on 2023/08/22.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public struct WineCard: View {
  public let wineData: WineData
  
  public init (
    wineData: WineData
  ) {
    self.wineData = wineData
  }
  
  public var body: some View {
    GeometryReader { geo in
      ZStack {
        WineCardBackground(wineBackgroundComponent: wineData.wineType.backgroundColor)
          .offset(y: 11)
        
        // Wine Card Border
        Path { path in
          let cardWidth: CGFloat = 282
          let cardHeight: CGFloat = 382
          let arcRadius: CGFloat = 38
          let cornerRadius: CGFloat = 5
          
          let topLeft = CGPoint(x: (geo.size.width - cardWidth) / 2, y: (geo.size.height - cardHeight) / 2)
          let topRight = CGPoint(x: topLeft.x + cardWidth, y: topLeft.y)
          let bottomRight = CGPoint(x: topRight.x, y: topLeft.y + cardHeight)
          let bottomLeft = CGPoint(x: topLeft.x, y: topLeft.y + cardHeight)
          let arcCenter = CGPoint(x: geo.size.width / 2, y: topLeft.y + cardHeight + 20)
          
          path.move(to: CGPoint(x: topLeft.x + cornerRadius, y: topLeft.y))
          path.addLine(to: CGPoint(x: topRight.x - cornerRadius, y: topRight.y))
          path.addArc(
            center: CGPoint(x: topRight.x - cornerRadius, y: topRight.y + cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: -90),
            endAngle: Angle(degrees: 0),
            clockwise: false
          )
          path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - cornerRadius))
          path.addArc(
            center: CGPoint(x: bottomRight.x - cornerRadius, y: bottomRight.y - cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 90),
            clockwise: false
          )
          
          path.addArc(
            center: arcCenter,
            radius: arcRadius,
            startAngle: Angle(degrees: -30),
            endAngle: Angle(degrees: 210),
            clockwise: true
          )
          
          path.addLine(to: CGPoint(x: bottomLeft.x + cornerRadius, y: bottomLeft.y))
          path.addArc(
            center: CGPoint(x: bottomLeft.x + cornerRadius, y: bottomLeft.y - cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 90),
            endAngle: Angle(degrees: 180),
            clockwise: false
          )
          path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + cornerRadius))
          path.addArc(
            center: CGPoint(x: topLeft.x + cornerRadius, y: topLeft.y + cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 180),
            endAngle: Angle(degrees: 270),
            clockwise: false
          )
          
          path.closeSubpath()
        }
        .fill(.ultraThinMaterial)
        .overlay(
          Path { path in
            let cardWidth: CGFloat = 282
            let cardHeight: CGFloat = 382
            let arcRadius: CGFloat = 38
            let cornerRadius: CGFloat = 5
            
            let topLeft = CGPoint(x: (geo.size.width - cardWidth) / 2, y: (geo.size.height - cardHeight) / 2)
            let topRight = CGPoint(x: topLeft.x + cardWidth, y: topLeft.y)
            let bottomRight = CGPoint(x: topRight.x, y: topLeft.y + cardHeight)
            let bottomLeft = CGPoint(x: topLeft.x, y: topLeft.y + cardHeight)
            let arcCenter = CGPoint(x: geo.size.width / 2, y: topLeft.y + cardHeight + 20)
            
            
            path.move(to: CGPoint(x: topLeft.x + cornerRadius, y: topLeft.y))
            path.addLine(to: CGPoint(x: topRight.x - cornerRadius, y: topRight.y))
            path.addArc(
              center: CGPoint(x: topRight.x - cornerRadius, y: topRight.y + cornerRadius),
              radius: cornerRadius,
              startAngle: Angle(degrees: -90),
              endAngle: Angle(degrees: 0),
              clockwise: false
            )
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - cornerRadius))
            path.addArc(
              center: CGPoint(x: bottomRight.x - cornerRadius, y: bottomRight.y - cornerRadius),
              radius: cornerRadius,
              startAngle: Angle(degrees: 0),
              endAngle: Angle(degrees: 90),
              clockwise: false
            )
            
            path.addArc(
              center: arcCenter,
              radius: arcRadius,
              startAngle: Angle(degrees: -30),
              endAngle: Angle(degrees: 210),
              clockwise: true
            )
            
            path.addLine(to: CGPoint(x: bottomLeft.x + cornerRadius, y: bottomLeft.y))
            path.addArc(
              center: CGPoint(x: bottomLeft.x + cornerRadius, y: bottomLeft.y - cornerRadius),
              radius: cornerRadius,
              startAngle: Angle(degrees: 90),
              endAngle: Angle(degrees: 180),
              clockwise: false
            )
            
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + cornerRadius))
            path.addArc(
              center: CGPoint(x: topLeft.x + cornerRadius, y: topLeft.y + cornerRadius),
              radius: cornerRadius,
              startAngle: Angle(degrees: 180),
              endAngle: Angle(degrees: 270),
              clockwise: false
            )
            
            path.closeSubpath()
          }
            .stroke(WineyKitAsset.gray50.swiftUIColor.opacity(0.12), lineWidth: 1)
        )
        
        Path { path in
          let lineTopLeft = CGPoint(x: ((geo.size.width - 282) / 2) + 28, y: ((geo.size.height - 382) / 2) + 145)
          let lineTopRight = CGPoint(x: lineTopLeft.x + 282 - 18 - 28, y: lineTopLeft.y)
          path.move(to: lineTopLeft)
          path.addLine(to: lineTopRight)
        }
        .stroke(
          LinearGradient(
            gradient: Gradient(colors: [.white, .clear]),
            startPoint: .leading,
            endPoint: .trailing),
          lineWidth: 1)
        
        Path { path in
          let lineVerticalStart = CGPoint(
            x: ((geo.size.width - 282) / 2) + 107,
            y: ((geo.size.height - 382) / 2) + 145
          )
          let lineVerticalEnd = CGPoint(x: lineVerticalStart.x, y: lineVerticalStart.y + 382 - 205)
          path.move(to: lineVerticalStart)
          path.addLine(to: lineVerticalEnd)
        }
        .stroke(
          LinearGradient(
            gradient: Gradient(colors: [.white, .white.opacity(0.15)]),
            startPoint: .top,
            endPoint: .trailing),
          lineWidth: 1)
        
        Path { path in
          let lineSecondLeft = CGPoint(x: ((geo.size.width - 282) / 2) + 107, y: ((geo.size.height - 382) / 2) + 203)
          let lineSecondRight = CGPoint(x: lineSecondLeft.x + 282 - 18 - 107, y: lineSecondLeft.y)
          path.move(to: lineSecondLeft)
          path.addLine(to: lineSecondRight)
        }
        .stroke(
          LinearGradient(
            gradient: Gradient(colors: [.white, .clear]),
            startPoint: .leading,
            endPoint: .trailing),
          lineWidth: 1)
        
        Path { path in
          let lineThirdLeft = CGPoint(x: ((geo.size.width - 282) / 2) + 107, y: ((geo.size.height - 382) / 2) + 261)
          let lineThirdRight = CGPoint(x: lineThirdLeft.x + 282 - 18 - 107, y: lineThirdLeft.y)
          path.move(to: lineThirdLeft)
          path.addLine(to: lineThirdRight)
        }
        .stroke(
          LinearGradient(
            gradient: Gradient(colors: [.white, .clear]),
            startPoint: .leading,
            endPoint: .trailing),
          lineWidth: 1)
        
        wineData.wineType.illustImage
          .position(x: ((geo.size.width - 282) / 2) + 29 + 33, y: ((geo.size.height - 382) / 2) + 181 + 59)
        
        VStack(spacing: 0) {
          // MARK: WINE NAME
          HStack {
            Text(wineData.wineType.typeName)
              .wineyFont(.display1)  // TODO: 임시 폰트
              .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
              .frame(width: 222, height: 54, alignment: .topLeading)
            
            Spacer()
          }
          .padding(.leading, ((geo.size.width - 282) / 2) + 30)
          .padding(.top, ((geo.size.height - 382) / 2) + 28)
          
          // MARK: WINE NAME
          HStack {
            Text(wineData.wineName)
              .wineyFont(.captionM1)
              .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
              .frame(width: 222, height: 40, alignment: .topLeading)
            
            Spacer()
          }
          .padding(.leading, ((geo.size.width - 282) / 2) + 30)
          .padding(.top, 14)
          
          // MARK: NATIONAL ANTHEMS
          VStack(spacing: 0) {
            HStack {
              Text("national anthems")
                .wineyFont(.captionM3)
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, ((geo.size.width - 282) / 2) + 120)
            
            HStack {
              Text(wineData.nationalAnthems)
                .wineyFont(.captionB1)
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, ((geo.size.width - 282) / 2) + 120)
            .padding(.top, 3)
          }
          .padding(.top, 20)
          
          // MARK: Varieties
          VStack(spacing: 0) {
            HStack {
              Text("Varieties")
                .wineyFont(.captionM3)
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, ((geo.size.width - 282) / 2) + 120)
            
            HStack {
              Text(wineData.varities)
                .wineyFont(.captionB1)
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, ((geo.size.width - 282) / 2) + 120)
            .padding(.top, 3)
          }
          .padding(.top, 24)
          
          // MARK: Purchase Price
          VStack(spacing: 0) {
            HStack {
              Text("Purchase Price")
                .wineyFont(.captionM3)
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, ((geo.size.width - 282) / 2) + 120)
            
            HStack {
              Text("\(String(format: "%.2f", wineData.purchasePrice))")
                .wineyFont(.captionB1)
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, ((geo.size.width - 282) / 2) + 120)
            .padding(.top, 4)
          }
          .padding(.top, 24)
          
          
          Spacer()
        }
      }
    }
  }
}
