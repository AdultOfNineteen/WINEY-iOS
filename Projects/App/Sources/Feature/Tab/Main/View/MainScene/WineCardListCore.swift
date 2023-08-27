//
//  WineCardListCore.swift
//  Winey
//
//  Created by 정도현 on 2023/08/25.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation
import WineyKit

public struct WineCardListState: Equatable {
  var wineList: [WineData]
  
  public init(
    wineList: [WineData] = [
      WineData(
        wineType: .red,
        wineName: "캄포 마리나 프리미이도 디 만두리아",
        nationalAnthems: "이탈리아",
        varities: "프리미티보",
        purchasePrice: 8.8
      ),
      WineData(
        wineType: .white,
        wineName: "캄포 마리나 프리미이도 디 만두리아",
        nationalAnthems: "이탈리아",
        varities: "프리미티보",
        purchasePrice: 8.8
      ),
      WineData(
        wineType: .etc,
        wineName: "캄포 마리나 프리미이도 디 만두리아",
        nationalAnthems: "이탈리아",
        varities: "프리미티보",
        purchasePrice: 8.8
      )
    ]
  ) {
    self.wineList = wineList
  }
}

public enum WineCardListAction {
  // MARK: - User Action
  case userScroll
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
  
}

public struct WineCardListEnvironment {
  public init() { }
}

public let wineCardListReducer = Reducer.combine([
  Reducer<WineCardListState, WineCardListAction, WineCardListEnvironment> { state, action, env in
    return .none
  }
])
