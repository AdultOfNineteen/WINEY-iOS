//
//  FlavorInfoType.swift
//  Winey
//
//  Created by 박혜운 on 2023/09/11.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation

protocol FalvorInfoType {
  var title: String { get }
  var subTitle: String { get }
}

public enum ChocolateFlavor: String, FalvorInfoType {
  var title: String {
    switch self {
    case .milk:
      return "밀크 초콜릿"
    case .dark:
      return "다크 초콜릿"
    }
  }
  
  var subTitle: String {
    switch self {
    case .milk:
      return "안달면 초콜릿을 왜 먹어?"
    case .dark:
      return "카카오 본연의 맛이지!"
    }
  }
  
  case milk
  case dark
}

public enum CoffeeFlavor: String, FalvorInfoType {
  var title: String {
    switch self {
    case .americano:
      return "아메리카노"
    case .cafe_latte:
      return "카페 라떼"
    }
  }
  
  var subTitle: String {
    switch self {
    case .americano:
      return "깔끔하고 시원한"
    case .cafe_latte:
      return "진하고 풍미가득한"
    }
  }
  
  case americano
  case cafe_latte
}

public enum FruitFlavor: String, FalvorInfoType {
  var title: String {
    switch self {
    case .peach:
      return "복숭아 , 자두 , 망고"
    case .pineapple:
      return "파인애플 , 수박 , 멜론"
    }
  }
  
  var subTitle: String {
    switch self {
    case .peach:
      return "달콤한 과즙이 맴도는"
    case .pineapple:
      return "상큼한 과즙으로 깔끔하게"
    }
  }
  
  case peach
  case pineapple
}
