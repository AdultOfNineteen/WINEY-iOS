//
//  WineSearchDTO.swift
//  Winey
//
//  Created by 정도현 on 12/19/23.
//  Copyright © 2023 Winey. All rights reserved.
//

import Foundation

public struct WineSearchDTO: Codable, Equatable {
  public static func == (lhs: WineSearchDTO, rhs: WineSearchDTO) -> Bool {
    return lhs.isLast == rhs.isLast && lhs.totalCnt == rhs.totalCnt && lhs.contents == rhs.contents
  }
  
  let isLast: Bool
  let totalCnt: Int
  let contents: [WineSearchContent]
}

public struct WineSearchContent: Codable, Equatable {
  let wineId: Int
  let type: String
  let country: String
  let name: String
  let varietal: String
}
