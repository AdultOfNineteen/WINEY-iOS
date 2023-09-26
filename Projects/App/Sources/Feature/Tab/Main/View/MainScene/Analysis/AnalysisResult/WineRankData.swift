//
//  WineRankData.swift
//  Winey
//
//  Created by 정도현 on 2023/09/18.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

public struct WineRankData: Hashable, Identifiable {
  public let id: Int
  public let rank: WineRank
  public let wineName: String
  public let percentage: Int
  
  public init (
    id: Int,
    rank: WineRank,
    wineName: String,
    percentage: Int
  ) {
    self.id = id
    self.rank = rank
    self.wineName = wineName
    self.percentage = percentage
  }
}

public enum WineRank: Int {
  case rank1 = 1
  case rank2
  case rank3
  
  public var pieGraphColor: Color {
    switch self {
    case .rank1:
      return WineyKitAsset.main1.swiftUIColor
    case .rank2:
      return WineyKitAsset.gray800.swiftUIColor
    case .rank3:
      return WineyKitAsset.gray900.swiftUIColor
    }
  }
  
  public var circleGraphStartColor: Color {
    switch self {
    case .rank1:
      return Color(red: 119/255, green: 75/255, blue: 1)
    case .rank2:
      return Color(red: 142/255, green: 121/255, blue: 208/255)
    case .rank3:
      return Color(red: 148/255, green: 143/255, blue: 166/255)
    }
  }
  
  public var circleGraphEndColor: Color {
    switch self {
    case .rank1:
      return Color(red: 119/255, green: 75/255, blue: 1)
        .opacity(0.26)
    case .rank2:
      return Color(red: 83/255, green: 83/255, blue: 83/255).opacity(0)
    case .rank3:
      return Color(red: 83/255, green: 83/255, blue: 83/255).opacity(0)
    }
  }
  
  public var circleRadius: CGFloat {
    switch self {
    case .rank1:
      return 142
    case .rank2:
      return 104
    case .rank3:
      return 95
    }
  }
  
  public var circleFont: WineyFontType {
    switch self {
    case .rank1:
      return WineyFontType.bodyB1
    case .rank2:
      return WineyFontType.bodyB2
    case .rank3:
      return WineyFontType.captionB1
    }
  }
  
  public var offsetX: CGFloat {
    switch self {
    case .rank1:
      return -68
    case .rank2:
      return 68
    case .rank3:
      return -48
    }
  }
  
  public var offsetY: CGFloat {
    switch self {
    case .rank1:
      return -72
    case .rank2:
      return 0
    case .rank3:
      return 80
    }
  }
}
