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
    var recommendWineData: RecommendWineData
    public var id: Int { self.index }
  }
  
  public enum Action {
    // MARK: - User Action
    case wineCardTapped
    
    // MARK: - Inner Business Action
    case _navigateToCardDetail(Int, RecommendWineData)
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .wineCardTapped:
      return .send(._navigateToCardDetail(state.recommendWineData.id, state.recommendWineData))
      
    case ._navigateToCardDetail:
      return .none
    default:
      return .none
    }
  }
}
