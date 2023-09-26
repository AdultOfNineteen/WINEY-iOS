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
      return WineyAsset.Assets.homeIcon.swiftUIImage
    case .map:
      return WineyAsset.Assets.mapIcon.swiftUIImage
    case .note:
      return WineyAsset.Assets.noteIcon.swiftUIImage
    case .userInfo:
      return WineyAsset.Assets.mypageIcon.swiftUIImage
    }
  }
  
  public var selectedIcon: Image {
    switch self {
    case .main:
      return WineyAsset.Assets.selectedHomeIcon.swiftUIImage
    case .map:
      return WineyAsset.Assets.selectedMapIcon.swiftUIImage
    case .note:
      return WineyAsset.Assets.selectedNoteIcon.swiftUIImage
    case .userInfo:
      return WineyAsset.Assets.selectedMypageIcon.swiftUIImage
    }
  }
}
