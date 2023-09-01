//
//  RadientCircleBackgroundView.swift
//  WineyKit
//
//  Created by 박혜운 on 2023/08/31.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public struct RadientCircleBackgroundView: View {
  
  public init() {}
  
  public var body: some View {
    RadialGradient(
      gradient: Gradient(
        colors: [
          WineyKitAsset.main1.swiftUIColor.opacity(0.5),
          WineyKitAsset.main1.swiftUIColor.opacity(0.25),
          WineyKitAsset.main1.swiftUIColor.opacity(0)
        ]
      ),
      center: .center,
      startRadius: 10,
      endRadius: 250
    )
    .clipShape(Circle())  // 원 형태로 잘라내기
    .frame(width: 506, height: 506)  // 프레임 크기 설정
  }
}
