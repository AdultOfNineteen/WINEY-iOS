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
  
  public var body: some View {
    VStack(spacing: -6) {
      HStack(spacing: 0) {
        Text(wineType.typeName)
          .wineyFont(.cardTitle)
        
        Spacer()
      }
      
      Spacer()
        .frame(maxHeight: wineType.smallCardSpacer)
      
      wineType.illustImage
        .resizable()
        .scaledToFit()
    }
    .padding(.top, 14)
    .padding(
      .bottom, 
      wineType == .red || wineType == .etc ? 14 : wineType == .rose ? 8 : 4
    )
    .padding(.horizontal, 18)
    .frame(height: 163)
    .background(
      cardBackground()
    )
  }
}

private extension SmallWineCard {
  
  @ViewBuilder
  func cardBackground() -> some View {
    ZStack {
      backgroundStroke()
      
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
          .frame(height: 74)
          .padding(.trailing, 60)
          .padding(.bottom, 50)
        
        Circle()
          .fill(wineType.backgroundColor.secondCircle)
          .frame(height: 94)
          .padding(.leading, 24)
          .padding(.top, 36)
      }
      
      RoundedRectangle(cornerRadius: 10)
        .foregroundStyle(.ultraThinMaterial)
    }
    .frame(height: 163)
  }
  
  @ViewBuilder
  func backgroundStroke() -> some View {
    RoundedRectangle(cornerRadius: 10)
      .stroke(
        LinearGradient(
          colors: [
            .white.opacity(0.9),
            .white.opacity(0.1)
          ],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        ),
        style: .init(lineWidth: 1)
      )
  }
}

#Preview {
  HStack {
    SmallWineCard(
      wineType: .red
    )
    SmallWineCard(
      wineType: .port
    )
  }
}
