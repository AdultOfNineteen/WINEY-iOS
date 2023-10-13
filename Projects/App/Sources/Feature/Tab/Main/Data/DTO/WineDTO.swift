//
//  WineDTO.swift
//  Winey
//
//  Created by 박혜운 on 2023/10/12.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation

public struct WineDTO: Codable, Equatable {
  public static func == (lhs: WineDTO, rhs: WineDTO) -> Bool { // 임시 
    return true
  }
  
  let wineId: Int
  let type: String
  let name: String
  let country: String
  let varietal: String
  let sweetness: Int
  let acidity: Int
  let body: Int
  let tannins: Int
  let wineSummary: WineSummary
}

// MARK: - WineSummary
public struct WineSummary: Codable {
  let avgPrice: Double
  let avgSweetness: Int
  let avgAcidity: Int
  let avgBody: Int
  let avgTannins: Int
}
