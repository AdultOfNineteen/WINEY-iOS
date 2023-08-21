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
        .lineSpacing(39) // 행간
      
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
        .lineSpacing(25) // 행간
      
    case .headLine:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 18)
        )
        .lineSpacing(23) // 행간
      
    case .subhead:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .medium
            .swiftUIFont(size: 15)
        )
        .lineSpacing(20) // 행간
      
    case .bodyB1:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 17)
        )
        .lineSpacing(24) // 행간
      
    case .bodyM1:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .medium
            .swiftUIFont(size: 17)
        )
        .lineSpacing(24) // 행간
      
    case .bodyB2:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 14)
        )
        .lineSpacing(19) // 행간
      
    case .bodyM2:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .medium
            .swiftUIFont(size: 14)
        )
        .lineSpacing(19) // 행간
      
    case .captionB1:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 13)
        )
        .lineSpacing(17) // 행간
      
    case .captionM1:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .medium
            .swiftUIFont(size: 13)
        )
        .lineSpacing(17) // 행간
      
    case .captionM2:
      return self
        .font(
          WineyKitFontFamily
            .Pretendard
            .medium
            .swiftUIFont(size: 11)
        )
        .lineSpacing(18) // 행간
    }
  }
}
