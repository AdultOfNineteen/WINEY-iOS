//
//  WineCardListCore.swift
//  Winey
//
//  Created by 정도현 on 2023/08/25.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct WineCardScroll {
  
  @ObservableState
  public struct State: Equatable {
    var previousScrollIndex: Int
    var currentScrollIndex: Int
    var wineCards: IdentifiedArrayOf<WineCard.State>
    
    public init(wineCards: IdentifiedArrayOf<WineCard.State>) {
      self.wineCards = wineCards
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
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      default:
        return .none
      }
    }
    .forEach(\.wineCards, action: /WineCardScroll.Action.wineCard) {
      WineCard()
    }
  }
}
