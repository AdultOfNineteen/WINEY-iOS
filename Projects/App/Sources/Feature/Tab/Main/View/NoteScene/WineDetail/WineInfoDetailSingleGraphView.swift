//
//  WineInfoDetailSingleGraphView.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

public struct WineInfoDetailSingleGraphView: View {
  public let value: Double
  public let category: String
  public var graphColor: Color
  public var isValid: Bool
  
  @State private var graphWidth: CGFloat = 0.0
  
  public init(
    value: Double,
    category: String,
    graphColor: Color,
    isValid: Bool
  ) {
    self.value = value
    self.category = category
    self.graphColor = graphColor
    self.isValid = isValid
  }
  
  public var body: some View {
    GeometryReader { geo in
      ZStack {
        VStack(alignment: .leading) {
          Text(category)
            .wineyFont(.bodyB2)
            .foregroundColor(isValid ? .white : WineyKitAsset.gray900.swiftUIColor)
            .padding(.bottom, 14)
          
          RoundedRectangle(cornerRadius: 10)
            .frame(width: graphWidth, height: 9)
            .foregroundColor(isValid ? graphColor : WineyKitAsset.gray900.swiftUIColor)
          
            .padding(.top, 7)
            .offset(y: -15)
            .onAppear {
              withAnimation(.easeOut(duration: 1.0)) {
                graphWidth = CGFloat(value) * geo.size.width / 6.5
              }
            }
          
          if isValid {
            Text(Int(value).description)
              .wineyFont(.bodyB2)
              .foregroundColor(isValid ? .white : WineyKitAsset.gray900.swiftUIColor)
              .background(
                Image(systemName: "drop.fill")
                  .resizable()
                  .rotationEffect(Angle(degrees: 180))
                  .frame(width: 22, height: 29)
                  .foregroundColor(isValid ? graphColor : WineyKitAsset.gray900.swiftUIColor)
                  .offset(y: 2)
              )
              .offset(x: graphWidth - 6, y: -56)
          }
        }
      }
    }
    .frame(height: 42)
  }
}

#Preview {
  VStack {
    WineInfoDetailSingleGraphView(
      value: 4,
      category: "test",
      graphColor: .red,
      isValid: true
    )
    WineInfoDetailSingleGraphView(
      value: 4,
      category: "test",
      graphColor: .red,
      isValid: false
    )
  }
}
