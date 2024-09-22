//
//  RecommendWineData.swift
//  Winey
//
//  Created by 정도현 on 12/13/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import SwiftUI

public struct RecommendWineData: Hashable, Identifiable {
  public let id: Int
  public let wineType: WineType
  public let name: String
  public let country: String
  public let varietal: String
  public let price: Int
  
  public init(
    id: Int,
    wineType: WineType,
    name: String,
    country: String,
    varietal: String,
    price: Int
  ) {
    self.id = id
    self.wineType = wineType
    self.name = name
    self.country = country
    self.varietal = varietal
    self.price = price
  }
}
