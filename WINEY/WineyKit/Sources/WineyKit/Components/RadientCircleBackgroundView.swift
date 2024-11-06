//
//  RadientCircleBackgroundView.swift
//  WineyKit
//
//  Created by 박혜운 on 2023/08/31.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public enum RadialCircleType {
  case splash
  case login
  case forceUpdate
  
  public var centerColor: Color {
    switch self {
    case .splash:
      return .wineyMain1.opacity(0.5)
      
    case .login:
      return Color(red: 80/255, green: 53/255, blue: 162/255)
        .opacity(0.5)
      
    case .forceUpdate:
      return Color(red: 48/255, green: 22/255, blue: 127/255)
        .opacity(0.5)
      
    }
  }
  
  public var borderColor: Color {
    return Color(red: 34/255, green: 3/255, blue: 49/255).opacity(0.0)
  }
  
  public var circleSize: CGFloat {
    switch self {
    case .splash:
      return CGFloat(608)
      
    case .login:
      return CGFloat(726)
      
    case .forceUpdate:
      return CGFloat(892)
    }
  }
}

public struct RadientCircleBackgroundView: View {
  
  public let backgroundType: RadialCircleType
  
  public init(backgroundType: RadialCircleType) {
    self.backgroundType = backgroundType
  }
  
  public var body: some View {
    RadialGradient(
      gradient: Gradient(stops: [
        .init(color: backgroundType.centerColor, location: 0.04),
        .init(color: backgroundType.borderColor, location: 1.0)
      ]),
      center: .center,
      startRadius: 0,
      endRadius: backgroundType.circleSize / 2.8
    )
    .clipShape(Circle())  // 원 형태로 잘라내기
    .frame(width: backgroundType.circleSize, height: backgroundType.circleSize)  // 프레임 크기 설정
  }
}
