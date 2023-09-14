//
//  WineCardCore.swift
//  Winey
//
//  Created by 정도현 on 2023/09/12.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation

public struct WineCard: Reducer {
  public struct State: Equatable, Identifiable {
    var index: Int
    var wineCardData: WineCardData
    public var id: Int { self.index }
  }
  
  public enum Action {
    // MARK: - User Action
    case wineCardTapped
    
    // MARK: - Inner Business Action
    case _navigateToCardDetail(Int, WineCardData)
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .wineCardTapped:
      print("CARD TAPPED")
      return .send(._navigateToCardDetail(state.wineCardData.id, state.wineCardData))
    case ._navigateToCardDetail:
      return .none
    default:
      return .none
    }
  }
}
