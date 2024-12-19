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
  case custom
  
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
    case .custom:
      return "직접 추가"
    }
  }
  
  public var list: [WineSmell] {
    switch self {
      
    case .fruit:
      return [
        WineSmell(korName: "과일향", codeName: "FRUIT"),
        WineSmell(korName: "레몬", codeName: "LEMON"),
        WineSmell(korName: "라임", codeName: "LIME"),
        WineSmell(korName: "배", codeName: "PEAR"),
        WineSmell(korName: "사과", codeName: "APPLE"),
        WineSmell(korName: "복숭아", codeName: "PEACH"),
        WineSmell(korName: "베리류", codeName: "BERRY"),
        WineSmell(korName: "자두", codeName: "PLUM"),
        WineSmell(korName: "열대과일", codeName: "TROPICALFRUIT")
      ]
    case .natural:
      return [
        WineSmell(korName: "꽃향", codeName: "FLOWER"),
        WineSmell(korName: "풀/나무", codeName: "GRASSWOOD"),
        WineSmell(korName: "아카시아", codeName: "ACACIA"),
        WineSmell(korName: "장미", codeName: "ROSE"),
        WineSmell(korName: "라벤더", codeName: "LAVENDER"),
        WineSmell(korName: "솔향", codeName: "PINE"),
        WineSmell(korName: "양파", codeName: "ONION"),
        WineSmell(korName: "옥수수", codeName: "CORN"),
        WineSmell(korName: "허브향", codeName: "HERB"),
        WineSmell(korName: "버섯", codeName: "MUSHROOM"),
        WineSmell(korName: "이끼", codeName: "MOSS")
      ]
    case .oak:
      return [
        WineSmell(korName: "오크향", codeName: "OAK"),
        WineSmell(korName: "향신료", codeName: "SPICE"),
        WineSmell(korName: "후추", codeName: "PEPPERSPICE"),
        WineSmell(korName: "계피", codeName: "CINNAMON"),
        WineSmell(korName: "견과류", codeName: "NUTS"),
        WineSmell(korName: "바닐라", codeName: "VANILLA"),
        WineSmell(korName: "캐러멜", codeName: "CARAMEL"),
        WineSmell(korName: "초콜릿", codeName: "CHOCOLATE"),
        WineSmell(korName: "토스트", codeName: "TOAST"),
        WineSmell(korName: "커피", codeName: "COFFEE"),
        WineSmell(korName: "코코넛", codeName: "COCONUT"),
        WineSmell(korName: "연기", codeName: "SMOKE")
      ]
    case .etc:
      return [
        WineSmell(korName: "부싯돌", codeName: "FLINT"),
        WineSmell(korName: "빵", codeName: "BREAD"),
        WineSmell(korName: "고무", codeName: "RUBBER"),
        WineSmell(korName: "땀", codeName: "SWEAT"),
        WineSmell(korName: "가죽", codeName: "LEATHER"),
        WineSmell(korName: "식초", codeName: "VINEGAR"),
        WineSmell(korName: "리무버", codeName: "REMOVER"),
        WineSmell(korName: "담배", codeName: "CIGARETTE"),
        WineSmell(korName: "꿀", codeName: "HONEY"),
        WineSmell(korName: "버터", codeName: "BUTTER"),
        WineSmell(korName: "흙/재", codeName: "EARTHASH"),
        WineSmell(korName: "약품", codeName: "MEDICINE")
      ]
      
    case .custom:
      return []
    }
  }
}

public struct WineSmell {
  public var korName: String
  public var codeName: String
}
