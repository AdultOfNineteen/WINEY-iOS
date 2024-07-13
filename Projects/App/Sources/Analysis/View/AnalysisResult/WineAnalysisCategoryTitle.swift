//
//  WineAnalysisCategoryTitle.swift
//  Winey
//
//  Created by 정도현 on 7/10/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI
import WineyKit

public struct WineAnalysisCategoryTitle: View {
  public let title: String
  
  public var body: some View {
    HStack(spacing: 1) {
      Circle()
        .frame(width: 7)
        .offset(y: -14)
        .foregroundColor(WineyKitAsset.main2.swiftUIColor)
      
      Text(title)
        .wineyFont(.title2)
        .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
    }
  }
}
