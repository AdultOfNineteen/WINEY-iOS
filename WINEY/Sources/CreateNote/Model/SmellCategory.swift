//
//  SmellCategory.swift
//  WINEY
//
//  Created by 박혜운 on 9/16/24.
//

import Foundation

public enum SmellCategory: CaseIterable {
  case fruit
  case natural
  case oak
  case etc
  
  public var title: String {
    switch self {
      
    case .fruit:
      return "과일향"
    case .natural:
      return "내추럴"
    case .oak:
      return "오크향"
    case .etc:
      return "기타"
    }
  }
  
  public var list: [WineSmell] {
    switch self {
      
    case .fruit:
      return [
        WineSmell(korName: "과일향", codeName: "FRUIT"),
        WineSmell(korName: "베리류", codeName: "BERRY"),
        WineSmell(korName: "레몬/라임", codeName: "LEMONANDLIME"),
        WineSmell(korName: "사과/배", codeName: "APPLEPEAR"),
        WineSmell(korName: "복숭아/자두", codeName: "PEACHPLUM")
      ]
    case .natural:
      return [
        WineSmell(korName: "꽃향", codeName: "FLOWER"),
        WineSmell(korName: "풀/나무", codeName: "GRASSWOOD"),
        WineSmell(korName: "허브향", codeName: "HERB")
      ]
    case .oak:
      return [
        WineSmell(korName: "오크향", codeName: "OAK"),
        WineSmell(korName: "향신료", codeName: "SPICE"),
        WineSmell(korName: "견과류", codeName: "NUTS"),
        WineSmell(korName: "바닐라", codeName: "VANILLA"),
        WineSmell(korName: "초콜릿", codeName: "CHOCOLATE")
      ]
    case .etc:
      return [
        WineSmell(korName: "부싯돌", codeName: "FLINT"),
        WineSmell(korName: "빵", codeName: "BREAD"),
        WineSmell(korName: "고무", codeName: "RUBBER"),
        WineSmell(korName: "흙/재", codeName: "EARTHASH"),
        WineSmell(korName: "약품", codeName: "MEDICINE")
      ]
    }
  }
}

public struct WineSmell {
  public var korName: String
  public var codeName: String
}
