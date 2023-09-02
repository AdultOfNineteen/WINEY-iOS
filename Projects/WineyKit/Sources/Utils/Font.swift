//
//  Font+Utils.swift
//  Utils
//
//  Created by 박혜운 on 2023/08/01.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public enum WineyFontType {
  case largeTitle
  case title1
  case title2
  case headLine
  case subhead
  case bodyB1
  case bodyM1
  case bodyB2
  case bodyM2
  case captionB1
  case captionM1
  case captionM2
  case captionM3
  case display1
  case display2
}

// 깔끔하게 정리하기 보류
public extension View {
  func wineyFont(_ fontStyle: WineyFontType) -> some View {
    switch fontStyle {
      
    case .largeTitle:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 32)
        )
        .lineSpacing(3.9) // 행간
      
    case .title1:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 26)
        )
        .lineSpacing(3.2) // 행간
      
    case .title2:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 20)
        )
        .lineSpacing(2.5) // 행간
      
    case .headLine:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 18)
        )
        .lineSpacing(2.3) // 행간
      
    case .subhead:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .medium
            .swiftUIFont(size: 15)
        )
        .lineSpacing(2.0) // 행간
      
    case .bodyB1:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 17)
        )
        .lineSpacing(2.4) // 행간
      
    case .bodyM1:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .medium
            .swiftUIFont(size: 17)
        )
        .lineSpacing(2.4) // 행간
      
    case .bodyB2:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 14)
        )
        .lineSpacing(1.9) // 행간
      
    case .bodyM2:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .medium
            .swiftUIFont(size: 14)
        )
        .lineSpacing(1.9) // 행간
      
    case .captionB1:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 13)
        )
        .lineSpacing(1.7) // 행간
      
    case .captionM1:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .medium
            .swiftUIFont(size: 13)
        )
        .lineSpacing(1) // 행간
      
    case .captionM2:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .medium
            .swiftUIFont(size: 11)
        )

        .lineSpacing(18) // 행간
      
    case .captionM3:
      return self
        .font(
          WineyKitFontFamily
            .Chaviera
            .regular
            .swiftUIFont(size: 11)
        ).lineSpacing(18)
      
    case .display1:
      return self
        .font(
          WineyKitFontFamily
            .Chaviera
            .regular
            .swiftUIFont(size: 54)
        )
        .lineSpacing(54) // 행간
      
    case .display2:
      return self
        .font(
          WineyKitFontFamily
            .Chaviera
            .regular
            .swiftUIFont(size: 28)
        )
        .lineSpacing(28) // 행간
    }
  }
}
