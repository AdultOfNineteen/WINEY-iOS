//
//  WineTipDTO.swift
//  Winey
//
//  Created by 정도현 on 12/21/23.
//  Copyright © 2023 Winey. All rights reserved.
//

import SwiftUI

public struct WineTipDTO: Codable, Equatable {
  public static func == (lhs: WineTipDTO, rhs: WineTipDTO) -> Bool {
    return lhs.isLast == rhs.isLast && lhs.totalCnt == rhs.totalCnt && lhs.contents == rhs.contents
  }
  
  var isLast: Bool
  var totalCnt: Int
  var contents: [WineTipContent]
}

public struct WineTipContent: Codable, Equatable {
  let wineTipId: Int
  let thumbNail: String
  let title: String
  let url: String
}
