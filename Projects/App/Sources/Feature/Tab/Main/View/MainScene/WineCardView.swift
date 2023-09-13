//
//  WineCard.swift
//  WineyKit
//
//  Created by 정도현 on 2023/08/22.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WineCardView: View {
  private let store: StoreOf<WineCard>
  @ObservedObject var viewStore: ViewStoreOf<WineCard>
  
  public init(store: StoreOf<WineCard>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    
    GeometryReader { geo in
      let cardWidth: CGFloat = geo.size.width
      
      ZStack {
        WineCardBackground(wineBackgroundComponent: viewStore.wineCardData.wineType.backgroundColor)
          .offset(x: 17.5, y: 21)
        
        // Wine Card Border
        Path { path in
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
            let cardWidth: CGFloat = geo.size.width
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
          let lineTopLeft = CGPoint(x: 30, y: 145)
          let lineTopRight = CGPoint(x: geo.size.width - 30, y: lineTopLeft.y)
          path.move(to: lineTopLeft)
          path.addLine(to: lineTopRight)
        }
        .stroke(viewStore.wineCardData.wineType.lineColor, lineWidth: 1)
        
        Path { path in
          let lineVerticalStart = CGPoint(
            x: 107,
            y: 145
          )
          let lineVerticalEnd = CGPoint(x: lineVerticalStart.x, y: lineVerticalStart.y + 382 - 205)
          path.move(to: lineVerticalStart)
          path.addLine(to: lineVerticalEnd)
        }
        .stroke(viewStore.wineCardData.wineType.lineColor, lineWidth: 1)
        
        Path { path in
          let lineSecondLeft = CGPoint(x: 107, y: 203)
          let lineSecondRight = CGPoint(x: geo.size.width - 30, y: lineSecondLeft.y)
          path.move(to: lineSecondLeft)
          path.addLine(to: lineSecondRight)
        }
        .stroke(viewStore.wineCardData.wineType.lineColor, lineWidth: 1)
        
        Path { path in
          let lineThirdLeft = CGPoint(x: 107, y: 261)
          let lineThirdRight = CGPoint(x: geo.size.width - 30, y: lineThirdLeft.y)
          path.move(to: lineThirdLeft)
          path.addLine(to: lineThirdRight)
        }
        .stroke(viewStore.wineCardData.wineType.lineColor, lineWidth: 1)
        
        viewStore.wineCardData.wineType.illustImage
          .position(x: 30 + 33, y: 181 + 59)
        
        VStack(spacing: 0) {
          // MARK: WINE TYPE
          HStack {
            Text(viewStore.wineCardData.wineType.typeName)
              .wineyFont(.display1)
              .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
              .frame(height: 54, alignment: .topLeading)
            
            WineyAsset.Assets.star1.swiftUIImage
              .padding(.top, 14)
            
            Spacer()
            
            WineyAsset.Assets.icArrowRight.swiftUIImage
              .padding(.top, 12)
              .padding(.trailing, 23)
          }
          .padding(.leading, 30)
          .padding(.top, 26)
          
          // MARK: WINE NAME45
          HStack {
            Text(viewStore.wineCardData.wineName.useNonBreakingSpace())
              .wineyFont(.captionM1)
              .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
              .lineLimit(2)
              .frame(height: 40, alignment: .topLeading)
              .padding(.top, 4)
            
            Spacer()
          }
          .padding(.leading, 30)
          .padding(.trailing, 30)
          .padding(.top, 12)
          
          // MARK: NATIONAL ANTHEMS
          VStack(spacing: 0) {
            HStack {
              Text("national an thems")
                .wineyFont(.captionM3)
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, 120)
            
            HStack {
              Text(viewStore.wineCardData.nationalAnthems)
                .wineyFont(.captionB1)
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, 120)
            .padding(.top, 4)
          }
          .padding(.top, 18)
          
          // MARK: Varieties
          VStack(spacing: 0) {
            HStack {
              Text("Varieties")
                .wineyFont(.captionM3)
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, 120)
            
            HStack {
              Text(viewStore.wineCardData.varities)
                .wineyFont(.captionB1)
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, 120)
            .padding(.top, 4)
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
            .padding(.leading, 120)
            
            HStack {
              Text("\(String(format: "%.2f", viewStore.wineCardData.purchasePrice))")
                .wineyFont(.captionB1)
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, 120)
            .padding(.top, 4)
          }
          .padding(.top, 24)
          
          Spacer()
        }
      }
      .onTapGesture {
        viewStore.send(.wineCardTapped)
      }
    }
  }
}


// For Text alignment - Justified
extension String {
  func useNonBreakingSpace() -> String {
    return self.replacingOccurrences(of: " ", with: "\u{202F}\u{202F}")
  }
}
