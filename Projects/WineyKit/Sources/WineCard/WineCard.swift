//
//  WineCard.swift
//  WineyKit
//
//  Created by 정도현 on 2023/08/22.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public struct WineCard: View {
  public let wineType: String
  public let wineName: String
  public let nationalAnthems: String
  public let varities: String
  public let purchasePrice: Double
  
  public init (
    wineType: String,
    wineName: String,
    nationalAnthems: String,
    varities: String,
    purchasePrice: Double
  ) {
    self.wineType = wineType
    self.wineName = wineName
    self.nationalAnthems = nationalAnthems
    self.varities = varities
    self.purchasePrice = purchasePrice
  }
  
  public var body: some View {
    GeometryReader { geo in
      ZStack {
        Path { path in
          let cardWidth: CGFloat = 282
          let cardHeight: CGFloat = 363
          let arcRadius: CGFloat = 38
          
          let topLeft = CGPoint(x: (geo.size.width - cardWidth) / 2, y: (geo.size.height - cardHeight) / 2)
          let topRight = CGPoint(x: topLeft.x + cardWidth, y: topLeft.y)
          let bottomRight = CGPoint(x: topRight.x, y: topLeft.y + cardHeight)
          let bottomLeft = CGPoint(x: topLeft.x, y: topLeft.y + cardHeight)
          let arcCenter = CGPoint(x: geo.size.width / 2, y: topLeft.y + cardHeight)
          
          path.move(to: topLeft)
          path.addLine(to: topRight)
          path.addLine(to: bottomRight)
          path.addArc(
            center: arcCenter,
            radius: arcRadius,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 180),
            clockwise: true
          )
          path.addLine(to: bottomLeft)
          
          path.closeSubpath()
        }
        .fill(.red)
        
        Path { path in
          let lineTopLeft = CGPoint(x: ((geo.size.width - 282) / 2) + 28, y: ((geo.size.height - 363) / 2) + 130)
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
          let lineVerticalStart = CGPoint(x: ((geo.size.width - 282) / 2) + 129, y: ((geo.size.height - 363) / 2) + 130)
          let lineVerticalEnd = CGPoint(x: lineVerticalStart.x, y: lineVerticalStart.y + 363 - 130 - 43)
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
          let lineSecondLeft = CGPoint(x: ((geo.size.width - 282) / 2) + 129, y: ((geo.size.height - 363) / 2) + 191)
          let lineSecondRight = CGPoint(x: lineSecondLeft.x + 282 - 18 - 129, y: lineSecondLeft.y)
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
          let lineThirdLeft = CGPoint(x: ((geo.size.width - 282) / 2) + 129, y: ((geo.size.height - 363) / 2) + 252)
          let lineThirdRight = CGPoint(x: lineThirdLeft.x + 282 - 18 - 129, y: lineThirdLeft.y)
          path.move(to: lineThirdLeft)
          path.addLine(to: lineThirdRight)
        }
        .stroke(
          LinearGradient(
            gradient: Gradient(colors: [.white, .clear]),
            startPoint: .leading,
            endPoint: .trailing),
          lineWidth: 1)
        
        VStack(spacing: 0) {
          // MARK: WINE NAME
          HStack {
            Text(wineType)
              .wineyFont(.cardTitle)  // TODO: 임시 폰트
              .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
            
            Spacer()
          }
          .padding(.leading, ((geo.size.width - 282) / 2) + 28)
          .padding(.top, ((geo.size.height - 363) / 2) + 23)
          
          // MARK: WINE NAME
          HStack {
            Text(wineName)
              .wineyFont(.captionM1)  // TODO: 임시 폰트
              .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
            
            Spacer()
          }
          .padding(.leading, ((geo.size.width - 282) / 2) + 28)
          .padding(.top, -8)
          
          // MARK: NATIONAL ANTHEMS
          VStack(spacing: 0) {
            HStack {
              Text("national anthems")
                .wineyFont(.cardCategory)
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, ((geo.size.width - 282) / 2) + 145)
            .padding(.top, 33)
            
            HStack {
              Text(nationalAnthems)
                .wineyFont(.captionM1)  // TODO: 임시 폰트
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, ((geo.size.width - 282) / 2) + 145)
            .padding(.top, 4.32)
          }
          
          // MARK: Varieties
          VStack(spacing: 0) {
            HStack {
              Text("Varieties")
                .wineyFont(.cardCategory)
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, ((geo.size.width - 282) / 2) + 145)
            .padding(.top, 30.12)
            
            HStack {
              Text(varities)
                .wineyFont(.captionM1)  // TODO: 임시 폰트
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, ((geo.size.width - 282) / 2) + 145)
            .padding(.top, 4.32)
          }
          
          // MARK: Purchase Price
          VStack(spacing: 0) {
            HStack {
              Text("Purchase Price")
                .wineyFont(.cardCategory)
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, ((geo.size.width - 282) / 2) + 145)
            .padding(.top, 30.12)
            
            HStack {
              Text("\(String(format: "%.2f", purchasePrice))")
                .wineyFont(.captionM1)  // TODO: 임시 폰트
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, ((geo.size.width - 282) / 2) + 145)
            .padding(.top, 4.32)
          }

          
          Spacer()
        }
      }
    }
  }
}
