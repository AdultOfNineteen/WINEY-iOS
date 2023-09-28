//
//  TasteModel.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation

public struct FirstFlavorType: Equatable {
  var chocolate: ChocolateFlavor?
  var coffee: CoffeeFlavor?
  var fruit: FruitFlavor?
  
  public init(
    chocolate: ChocolateFlavor? = nil,
    coffee: CoffeeFlavor? = nil,
    fruit: FruitFlavor? = nil)
  {
    self.chocolate = chocolate
    self.coffee = coffee
    self.fruit = fruit
  }
}
