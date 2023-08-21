//
//  TasteModel.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation

protocol FlavorInfoProviding: Hashable {
  static var flavorInfo: [Self: (title: String, subtitle: String)] { get }
}

extension ChocolateFlavor: FlavorInfoProviding {
  static var flavorInfo: [ChocolateFlavor: (title: String, subtitle: String)] = [
    .milk: ("밀크 초콜릿", "안달면 초콜릿을 왜 먹어?"),
    .dark: ("다크 초콜릿", "카카오 본연의 맛이지!")
  ]
}

extension CoffeeFlavor: FlavorInfoProviding {
  static var flavorInfo: [CoffeeFlavor: (title: String, subtitle: String)] = [
    .americano: ("아메리카노", "깔끔하고 시원한"),
    .latte: ("카페 라떼", "진하고 풍미가득한")
  ]
}

extension FruitFlavor: FlavorInfoProviding {
  static var flavorInfo: [FruitFlavor: (title: String, subtitle: String)] = [
    .sweet: ("복숭아 , 자두 , 망고", "달콤한 과즙이 맴도는"),
    .sour: ("파인애플 , 수박 , 멜론", "상큼한 과즙으로 깔끔하게")
  ]
}

struct FlavorInfoProvider<Flavor: FlavorInfoProviding> {
  var flavor: Flavor
  
  var title: String {
    return Flavor.flavorInfo[flavor]?.title ?? ""
  }
  
  var subtitle: String {
    return Flavor.flavorInfo[flavor]?.subtitle ?? ""
  }
}

public enum ChocolateFlavor {
  case milk, dark
}

public enum CoffeeFlavor: Int {
  case americano, latte
}

public enum FruitFlavor: Int {
  case sweet, sour
}

public struct FirstFlavorModel: Equatable {
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
