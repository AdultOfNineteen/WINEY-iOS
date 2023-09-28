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

public enum ChocolateFlavor: FalvorInfoType {
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

public enum CoffeeFlavor: Int, FalvorInfoType {
  var title: String {
    switch self {
    case .americano:
      return "아메리카노"
    case .latte:
      return "카페 라떼"
    }
  }
  
  var subTitle: String {
    switch self {
    case .americano:
      return "깔끔하고 시원한"
    case .latte:
      return "진하고 풍미가득한"
    }
  }
  
  case americano
  case latte
}

public enum FruitFlavor: Int, FalvorInfoType {
  var title: String {
    switch self {
    case .sweet:
      return "복숭아 , 자두 , 망고"
    case .sour:
      return "파인애플 , 수박 , 멜론"
    }
  }
  
  var subTitle: String {
    switch self {
    case .sweet:
      return "달콤한 과즙이 맴도는"
    case .sour:
      return "상큼한 과즙으로 깔끔하게"
    }
  }
  
  case sweet
  case sour
}
