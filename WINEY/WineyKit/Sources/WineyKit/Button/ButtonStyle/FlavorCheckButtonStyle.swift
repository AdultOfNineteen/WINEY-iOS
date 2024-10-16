//
//  TasteCheckButtonStyle.swift
//  WineyKit
//
//  Created by 박혜운 on 2023/08/01.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

struct FlavorCheckButtonStyle: ButtonStyle {
  let mainTitle: String
  let subTitle: String
  let isSelected: Bool
  
  init(
    mainTitle: String,
    subTitle: String,
    isSelected: Bool
  ) {
    self.mainTitle = mainTitle
    self.subTitle = subTitle
    self.isSelected = isSelected
  }
  
  func makeBody(configuration: Self.Configuration) -> some View {
    GeometryReader { geometry in
      ZStack{
        // Label에 해당하는 TextView
        VStack(spacing: 6) {
          Text(subTitle)
            .wineyFont(.captionM1)
            .foregroundColor(.wineyGray700)
          
          Text(mainTitle)
            .wineyFont(.bodyB2)
            .foregroundColor(
              configuration.isPressed || isSelected ?
              .wineyMain2 :
                .wineyGray500
            )
        }
        
        // 외곽선 및 터치영역 정의
        configuration
          .label
          .wineyFont(.headLine)
          .multilineTextAlignment(.center)
          .lineLimit(1)
          .frame(maxWidth: .infinity)
          .frame(height: 162)
          .clipShape(RoundedRectangle(cornerRadius: 5))
          .overlay(
            RoundedRectangle( cornerRadius: 11)
              .stroke(
                configuration.isPressed || isSelected ?
                .wineyMain2 : .wineyGray800,
                lineWidth: 2
              )
              .opacity(configuration.isPressed ? 0.7 : 1)
          )
          .contentShape(RoundedRectangle( cornerRadius: 11))
        
      }
    }
  }
}

// MARK: - 사용법

struct FlavorCheckButtonStyle_Previews: PreviewProvider {
  @State static var buttonState = true
  
  static var previews: some View {
    Button("", action: {})
      .buttonStyle(
        FlavorCheckButtonStyle(
          mainTitle: "밀크 초콜릿",
          subTitle: "안달면 초콜릿을 왜 먹어?",
          isSelected: true
        )
      )
  }
}
