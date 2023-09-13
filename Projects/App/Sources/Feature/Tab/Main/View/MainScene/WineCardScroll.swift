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


public struct WineCardScroll: Reducer {
  public struct State: Equatable {
    var previousScrollIndex: Int
    var currentScrollIndex: Int
    var wineCards: IdentifiedArrayOf<WineCard.State>
    
    public init() {
      self.wineCards = [
        WineCard.State(
          index: 0,
          wineCardData: WineCardData(
            id: 0,
            wineType: .etc,
            wineName: "test1",
            nationalAnthems: "test test test",
            varities: "test", purchasePrice: 9.90
          )
        ),
        
        WineCard.State(
          index: 1,
          wineCardData: WineCardData(
            id: 1,
            wineType: .red,
            wineName: "test2",
            nationalAnthems: "test test test",
            varities: "test", purchasePrice: 9.90
          )
        ),
        
        WineCard.State(
          index: 2,
          wineCardData: WineCardData(
            id: 2,
            wineType: .rose,
            wineName: "test3",
            nationalAnthems: "test test test",
            varities: "test", purchasePrice: 9.90
          )
        ),
      ]
      
      self.previousScrollIndex = 0
      self.currentScrollIndex = 0
    }
  }
  
  public enum Action {
    // MARK: - User Action
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case wineCard(id: Int, action: WineCard.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }.forEach(\.wineCards, action: /WineCardScroll.Action.wineCard) {
      WineCard()
    }
  }
}
