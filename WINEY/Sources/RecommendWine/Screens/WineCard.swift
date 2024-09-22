//
//  WineCardCore.swift
//  Winey
//
//  Created by 정도현 on 2023/09/12.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import UserInfoData

@Reducer
public struct WineCard {
  @ObservableState
  public struct State: Equatable, Identifiable {
    public var id: Int { self.index }
    private(set) var index: Int
    private(set) var recommendWineData: RecommendWineData
    
    public init(index: Int, recommendWineData: RecommendWineData) {
      self.index = index
      self.recommendWineData = recommendWineData
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case wineCardTapped
    
    // MARK: - Inner Business Action
    case _navigateToCardDetail(Int, RecommendWineData)
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .wineCardTapped:
        AmplitudeProvider.shared.track(event: .WINE_DETAIL_CLICK)
        return .send(._navigateToCardDetail(state.recommendWineData.id, state.recommendWineData))
        
      case ._navigateToCardDetail:
        return .none
      }
    }
  }
}
