//
//  TabBarItem.swift
//  Winey
//
//  Created by 정도현 on 2023/08/22.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

public enum TabBarItem: Int, CaseIterable, Equatable {
  case main = 0
  case note = 1
  
  public var description: String {
    switch self {
    case .main:
      return "홈"
    case .note:
      return "노트"
    }
  }
  
  public var icon: Image {
    switch self {
    case .main:
      return WineyAsset.Assets.homeIcon.swiftUIImage
      
    case .note:
      return WineyAsset.Assets.noteIcon.swiftUIImage
    }
  }
}
