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
  public let id: Int
  public let wineType: WineType
  public let wineName: String
  public let nationalAnthems: String
  public let varities: String
  public let purchasePrice: Double
  
  public init (
    id: Int,
    wineType: WineType,
    wineName: String,
    nationalAnthems: String,
    varities: String,
    purchasePrice: Double
  ) {
    self.id = id
    self.wineType = wineType
    self.wineName = wineName
    self.nationalAnthems = nationalAnthems
    self.varities = varities
    self.purchasePrice = purchasePrice
  }
}

struct WineBackgroundColor {
  var backgroundColor: Color
  var firstCircleStart: Color
  var firstCircleEnd: Color
  var secondCircle: Color
}

// MARK: WINE TYPE
public enum WineType: String {
  case red
  case white
  case rose
  case sparkl
  case port
  case etc
  
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
  
  var cirlcleBorderColor: Color {
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
      return  WineyAsset.Assets.redIllust.swiftUIImage
    case .white:
      return  WineyAsset.Assets.whiteIllust.swiftUIImage
    case .rose:
      return  WineyAsset.Assets.roseIllust.swiftUIImage
    case .sparkl:
      return  WineyAsset.Assets.sparklIllust.swiftUIImage
    case .port:
      return  WineyAsset.Assets.portIllust.swiftUIImage
    case .etc:
      return  WineyAsset.Assets.etcIllust.swiftUIImage
    }
  }
}
