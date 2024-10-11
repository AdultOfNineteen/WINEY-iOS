//
//  WineData.swift
//  WineyKit
//
//  Created by 정도현 on 2023/08/24.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

// MARK: WINEDATA
public struct WineCardData: Hashable, Identifiable {
  public static func == (lhs: WineCardData, rhs: WineCardData) -> Bool {
    return true
  }
  
  public let id: Int
  public let wineType: WineType
  public let name: String
  public let country: String
  public let varietal: String
  public let sweetness: Int
  public let acidity: Int
  public let body: Int
  public let tannins: Int
  public let wineSummary: WineSummary
  
  public init(
    id: Int,
    wineType: WineType,
    name: String,
    country: String,
    varietal: String,
    sweetness: Int,
    acidity: Int,
    body: Int,
    tannins: Int,
    wineSummary: WineSummary
  ) {
    self.id = id
    self.wineType = wineType
    self.name = name
    self.country = country
    self.varietal = varietal
    self.sweetness = sweetness
    self.acidity = acidity
    self.body = body
    self.tannins = tannins
    self.wineSummary = wineSummary
  }
}

struct WineBackgroundColor {
  var backgroundColor: Color
  var firstCircleStart: Color
  var firstCircleEnd: Color
  var secondCircle: Color
}

// MARK: WINE TYPE
@frozen public enum WineType: String, CaseIterable {
  case red = "RED"
  case white = "WHITE"
  case rose = "ROSE"
  case sparkl = "SPARKLING"
  case port = "FORTIFIED"
  case etc = "OTHER"
  
  var typeName: String {
    switch self {
    case .red:
      return "RED"
    case .white:
      return "WHITE"
    case .rose:
      return "ROSE"
    case .sparkl:
      return "SPARKL"
    case .port:
      return "PORT"
    case .etc:
      return "ETC"
    }
  }
  
  var korName: String {
    switch self {
    case .red:
      return "레드"
    case .white:
      return "화이트"
    case .rose:
      return "로제"
    case .sparkl:
      return "스파클링"
    case .port:
      return "포르투"
    case .etc:
      return "기타"
    }
  }
  
  var lineColor: Color {
    switch self {
    case .red:
      return Color(red: 168/255, green: 117/255, blue: 117/255)
    case .white:
      return Color(red: 193/255, green: 186/255, blue: 158/255)
    case .rose:
      return Color(red: 201/255, green: 164/255, blue: 161/255)
    case .sparkl:
      return Color(red: 167/255, green: 176/255, blue: 147/255)
    case .port:
      return Color(red: 176/255, green: 154/255, blue: 134/255)
    case .etc:
      return Color(red: 118/255, green: 129/255, blue: 105/255)
    }
  }
  
  var circleBorderColor: Color {
    switch self {
    case .red:
      return Color(red: 184/255, green: 74/255, blue: 74/255)
    case .white:
      return Color(red: 123/255, green: 116/255, blue: 80/255)
    case .rose:
      return Color(red: 250/255, green: 177/255, blue: 177/255)
    case .sparkl:
      return Color(red: 180/255, green: 175/255, blue: 135/255)
    case .port:
      return Color(red: 122/255, green: 99/255, blue: 72/255)
    case .etc:
      return Color(red: 145/255, green: 177/255, blue: 126/255)
    }
  }
  
  var backgroundColor: WineBackgroundColor {
    switch self {
    case .red:
      return WineBackgroundColor(
        backgroundColor: Color(red: 68/255, green: 16/255, blue: 16/255),
        firstCircleStart: Color(red: 191/255, green: 54/255, blue: 54/255),
        firstCircleEnd: Color(red: 143/255, green: 3/255, blue: 79/255),
        secondCircle: Color(red: 100/255, green: 13/255, blue: 13/255)
      )
      
    case .white:
      return WineBackgroundColor(
        backgroundColor: Color(red: 122/255, green: 112/255, blue: 109/255),
        firstCircleStart: Color(red: 174/255, green: 171/255, blue: 153/255),
        firstCircleEnd: Color(red: 117/255, green: 74/255, blue: 9/255),
        secondCircle: Color(red: 137/255, green: 132/255, blue: 114/255)
      )
      
    case .rose:
      return WineBackgroundColor(
        backgroundColor: Color(red: 143/255, green: 108/255, blue: 100/255),
        firstCircleStart: Color(red: 170/255, green: 103/255, blue: 143/255),
        firstCircleEnd: Color(red: 210/255, green: 146/255, blue: 99/255),
        secondCircle: Color(red: 168/255, green: 122/255, blue: 113/255)
      )
      
    case .sparkl:
      return WineBackgroundColor(
        backgroundColor: Color(red: 79/255, green: 81/255, blue: 68/255),
        firstCircleStart: Color(red: 130/255, green: 125/255, blue: 107/255),
        firstCircleEnd: Color(red: 186/255, green: 197/255, blue: 156/255),
        secondCircle: Color(red: 119/255, green: 113/255, blue: 81/255)
      )
      
    case .port:
      return WineBackgroundColor(
        backgroundColor: Color(red: 58/255, green: 47/255, blue: 47/255),
        firstCircleStart: Color(red: 74/255, green: 36/255, blue: 1/255),
        firstCircleEnd: Color(red: 119/255, green: 80/255, blue: 58/255),
        secondCircle: Color(red: 79/255, green: 63/255, blue: 40/255)
      )
      
    case .etc:
      return WineBackgroundColor(
        backgroundColor: Color(red: 35/255, green: 49/255, blue: 36/255),
        firstCircleStart: Color(red: 60/255, green: 61/255, blue: 18/255),
        firstCircleEnd: Color(red: 70/255, green: 92/255, blue: 24/255),
        secondCircle: Color(red: 45/255, green: 67/255, blue: 40/255)
      )
    }
  }
  
  var illustImage: Image {
    switch self {
    case .red:
      return Image(.red_illustW)
    case .white:
      return  Image(.white_illustW)
    case .rose:
      return  Image(.rose_illustW)
    case .sparkl:
      return  Image(.sparkl_illustW)
    case .port:
      return  Image(.port_illustW)
    case .etc:
      return  Image(.etc_illustW)
    }
  }
  
  static func changeType(at type: String) -> Self {
    let type = type.uppercased()
    switch type {
    case "RED":
      return .red
    case "WHITE":
      return .white
    case "ROSE":
      return .rose
    case "SPARKLING":
      return .sparkl
    case "PORT":
      return .port
    case "ETC":
      fallthrough
    default:
      return .etc
    }
  }
  
  var smallCardSpacer: CGFloat {
    switch self {
    case .red, .port:
      return 10
    case .rose:
      return 0
    case .etc:
      return 12
    default:
      return 6
    }
  }
}

public func filterRequestString(forValue value: String) -> String {
  return filterTranslate[value] ?? value
}

public var filterTranslate: [String: String] {
  return [
    "레드": "RED",
    "화이트": "WHITE",
    "로제": "ROSE",
    "스파클링": "SPARKLING",
    "포르투": "FORTIFIED",
    "기타": "OTHER"
  ]
}
