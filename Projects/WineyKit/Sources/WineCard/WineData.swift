//
//  WineData.swift
//  WineyKit
//
//  Created by 정도현 on 2023/08/24.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

struct WineBackgroundColor {
  var backgroundColor: Color
  var firstCircleStart: Color
  var firstCircleEnd: Color
  var secondCircle: Color
}

// MARK: WINEDATA
public struct WineData: Hashable {
  
  public init (
    wineType: WineType,
    wineName: String,
    nationalAnthems: String,
    varities: String,
    purchasePrice: Double
  ) {
    self.wineType = wineType
    self.wineName = wineName
    self.nationalAnthems = nationalAnthems
    self.varities = varities
    self.purchasePrice = purchasePrice
  }
  
  public let wineType: WineType
  public let wineName: String
  public let nationalAnthems: String
  public let varities: String
  public let purchasePrice: Double
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
        firstCircleStart: Color(red: 191/255, green: 54/255, blue: 54/255),
        firstCircleEnd: Color(red: 143/255, green: 3/255, blue: 79/255),
        secondCircle: Color(red: 100/255, green: 13/255, blue: 13/255)
      )
      
    case .sparkl:
      return WineBackgroundColor(
        backgroundColor: Color(red: 79/255, green: 81/255, blue: 68/255),
        firstCircleStart: Color(red: 191/255, green: 54/255, blue: 54/255),
        firstCircleEnd: Color(red: 143/255, green: 3/255, blue: 79/255),
        secondCircle: Color(red: 100/255, green: 13/255, blue: 13/255)
      )
      
    case .port:
      return WineBackgroundColor(
        backgroundColor: Color(red: 58/255, green: 47/255, blue: 47/255),
        firstCircleStart: Color(red: 191/255, green: 54/255, blue: 54/255),
        firstCircleEnd: Color(red: 143/255, green: 3/255, blue: 79/255),
        secondCircle: Color(red: 100/255, green: 13/255, blue: 13/255)
      )
      
    case .etc:
      return WineBackgroundColor(
        backgroundColor: Color(red: 35/255, green: 49/255, blue: 36/255),
        firstCircleStart: Color(red: 191/255, green: 54/255, blue: 54/255),
        firstCircleEnd: Color(red: 143/255, green: 3/255, blue: 79/255),
        secondCircle: Color(red: 100/255, green: 13/255, blue: 13/255)
      )
    }
  }
  
  
  var illustImage: Image {
    switch self {
    case .red:
      return  WineyKitAsset.redIllust.swiftUIImage
    case .white:
      return  WineyKitAsset.whiteIllust.swiftUIImage
    case .rose:
      return  WineyKitAsset.redIllust.swiftUIImage
    case .sparkl:
      return  WineyKitAsset.redIllust.swiftUIImage
    case .port:
      return  WineyKitAsset.redIllust.swiftUIImage
    case .etc:
      return  WineyKitAsset.redIllust.swiftUIImage
    }
  }
}
