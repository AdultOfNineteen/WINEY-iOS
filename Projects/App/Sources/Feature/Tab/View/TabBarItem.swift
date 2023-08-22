//
//  TabBarItem.swift
//  Winey
//
//  Created by 정도현 on 2023/08/22.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

public enum TabBarItem: Int, CaseIterable, Equatable {
  case main = 0
  case writingNote = 1
  
  public var description: String {
    switch self {
    case .main:
      return "Main"
    case .writingNote:
      return "WritingNote"
    }
  }
}
