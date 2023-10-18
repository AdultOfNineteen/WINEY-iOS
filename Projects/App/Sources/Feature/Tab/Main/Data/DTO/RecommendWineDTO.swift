//
//  RecommendWineDTO.swift
//  Winey
//
//  Created by 박혜운 on 2023/10/12.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation

public struct RecommendWineDTO: Codable {
  let wineId: Int
  let name: String
  let country: String
  let type: String
  let varietal: [String]
  let price: Int
}
