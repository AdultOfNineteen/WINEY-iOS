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
  
  public init(store: StoreOf<WineCard>) {
    self.store = store
  }
  
  public var body: some View {
    
    GeometryReader { geo in
      
      ZStack {
        WineCardBackground(
          wineBackgroundComponent:  store.recommendWineData.wineType.backgroundColor
        )
        
        RoundedRectangle(cornerRadius: 5.4)
          .foregroundStyle(.ultraThinMaterial)
        
        RoundedRectangle(cornerRadius: 5.4)
          .fill(
            .white.opacity(
               store.recommendWineData.wineType == .red || 
               store.recommendWineData.wineType == .rose ? 0.00 : 0.12
            )
          )
        
        RoundedRectangle(cornerRadius: 5.4)
          .strokeBorder(
            LinearGradient(
              colors: [
                .white.opacity(0.8),
                .white.opacity(0.1)
              ],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: 1
          )
        
        Path { path in
          let lineTopLeft = CGPoint(x: 30, y: 145)
          let lineTopRight = CGPoint(x: geo.size.width - 30, y: lineTopLeft.y)
          path.move(to: lineTopLeft)
          path.addLine(to: lineTopRight)
        }
        .stroke( store.recommendWineData.wineType.lineColor, lineWidth: 1)
        
        Path { path in
          let lineVerticalStart = CGPoint(
            x: 107,
            y: 145
          )
          let lineVerticalEnd = CGPoint(x: lineVerticalStart.x, y: lineVerticalStart.y + 382 - 205)
          path.move(to: lineVerticalStart)
          path.addLine(to: lineVerticalEnd)
        }
        .stroke( store.recommendWineData.wineType.lineColor, lineWidth: 1)
        
        Path { path in
          let lineSecondLeft = CGPoint(x: 107, y: 203)
          let lineSecondRight = CGPoint(x: geo.size.width - 30, y: lineSecondLeft.y)
          path.move(to: lineSecondLeft)
          path.addLine(to: lineSecondRight)
        }
        .stroke( store.recommendWineData.wineType.lineColor, lineWidth: 1)
        
        Path { path in
          let lineThirdLeft = CGPoint(x: 107, y: 261)
          let lineThirdRight = CGPoint(x: geo.size.width - 30, y: lineThirdLeft.y)
          path.move(to: lineThirdLeft)
          path.addLine(to: lineThirdRight)
        }
        .stroke( store.recommendWineData.wineType.lineColor, lineWidth: 1)
        
         store.recommendWineData.wineType.illustImage
          .position(x: 30 + 33, y: 181 + 59)
        
        VStack(spacing: 0) {
          
          // MARK: WINE TYPE
          HStack {
            Text( store.recommendWineData.wineType.typeName)
              .wineyFont(.display1)
              .foregroundColor(.wineyGray50)
              .frame(height: 54, alignment: .topLeading)
            
            Spacer()
            
            Image(.ic_arrow_rightW)
              .padding(.top, 12)
              .padding(.trailing, 23)
          }
          .padding(.leading, 30)
          .padding(.top, 26)
          
          // MARK: WINE NAME45
          HStack {
            Text( store.recommendWineData.name.useNonBreakingSpace())
              .wineyFont(.captionM1)
              .foregroundColor(.wineyGray50)
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
              Text("Countries")
                .wineyFont(.captionM3)
                .foregroundColor(.white)
              
              Spacer()
            }
            .padding(.leading, 120)
            
            HStack {
              Text( store.recommendWineData.country)
                .wineyFont(.captionB1)
                .foregroundColor(.wineyGray50)
              
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
                .foregroundColor(.wineyGray50)
              
              Spacer()
            }
            .padding(.leading, 120)
            
            HStack {
              Text( store.recommendWineData.varietal)
                .lineLimit(1)
                .wineyFont(.captionB1)
                .foregroundColor(.wineyGray50)
              
              Spacer()
            }
            .padding(.leading, 120)
            .padding(.top, 4)
          }
          .padding(.trailing, 26)
          .padding(.top, 24)
          
          // MARK: Purchase Price
          VStack(spacing: 0) {
            HStack {
              Text("Purchase Price")
                .wineyFont(.captionM3)
                .foregroundColor(.wineyGray50)
              
              Spacer()
            }
            .padding(.leading, 120)
            
            HStack {
              Text("\( store.recommendWineData.price)")
                .wineyFont(.captionB1)
                .foregroundColor(.wineyGray50)
              
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
         store.send(.wineCardTapped)
      }
      .frame(width: geo.size.width, height: 393)
    }
  }
}

// For Text alignment - Justified
extension String {
  func useNonBreakingSpace() -> String {
    return self.replacingOccurrences(of: " ", with: "\u{202F}\u{202F}")
  }
}

#Preview {
  WineCardView(
    store: StoreOf<WineCard>(
      initialState: .init(
        index: 1,
        recommendWineData: RecommendWineData(
          id: 1,
          wineType: .red,
          name: "test",
          country: "test",
          varietal: "Test",
          price: 1000
        )
      ),
      reducer: { WineCard() }
    )
  )
}
