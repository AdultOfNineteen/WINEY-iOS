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
  public var wineType: WineType
  public var borderColor: Color
  
  public var body: some View {
    VStack(spacing: -10) {
      HStack(spacing: 3) {
        Text(wineType.typeName)
          .wineyFont(.cardTitle)
        
        Spacer()
      }
      .padding(.leading, 19)
      .padding(.top, 14)
      
      wineType.illustImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding(.bottom, 4)
    }
    .background(
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
        .background(
          RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.ultraThinMaterial)
            .background(
              ZStack {
                Circle()
                  .fill(
                    LinearGradient(
                      colors: [
                        wineType.backgroundColor.firstCircleStart,
                        wineType.backgroundColor.firstCircleEnd.opacity(0.4),
                        .clear
                      ],
                      startPoint: .top,
                      endPoint: .bottom
                    )
                  )
                  .frame(height: 80)
                  .padding(.trailing, 45)
                  .padding(.bottom, 60)
                
                Circle()
                  .fill(wineType.backgroundColor.secondCircle)
                  .frame(height: 94)
                  .padding(.leading, 24)
                  .padding(.top, 40)
              }
            )
        )
    )
    .frame(height: 163)
  }
}

#Preview {
  SmallWineCard(
    wineType: .red,
    borderColor: Color(red: 150/255, green: 113/255, blue: 1)
  )
}
