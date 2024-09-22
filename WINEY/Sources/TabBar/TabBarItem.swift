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
  case map = 1
  case note = 2
  case userInfo = 3
  
  public var description: String {
    switch self {
    case .main:
      return "홈"
    case .map:
      return "지도"
    case .note:
      return "노트"
    case .userInfo:
      return "MY"
    }
  }
  
  public var defaultIcon: Image {
    switch self {
    case .main:
      return Image(.home_iconW)
    case .map:
      return Image(.map_iconW)
    case .note:
      return Image(.note_iconW)
    case .userInfo:
      return Image(.mypage_iconW)
    }
  }
  
  public var selectedIcon: Image {
    switch self {
    case .main:
      return Image(.selected_home_iconW)
    case .map:
      return Image(.selected_map_iconW)
    case .note:
      return Image(.selected_note_iconW)
    case .userInfo:
      return Image(.selected_mypage_iconW)
    }
  }
}
