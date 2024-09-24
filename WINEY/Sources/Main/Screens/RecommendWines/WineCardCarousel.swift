//
//  WineCardCarousel.swift
//  Winey
//
//  Created by 정도현 on 2023/08/25.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct WineCardCarousel {
  
  @ObservableState
  public struct State: Equatable {
    var previousScrollIndex: Int
    var currentScrollIndex: Int
    var wineCards: IdentifiedArrayOf<WineCard.State> = []
    
    public init() {
      self.previousScrollIndex = 0
      self.currentScrollIndex = 0
    }
  }
  
  public enum Action {
    // MARK: - User Action
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    
    // MARK: - Inner SetState Action
    case _setTodaysWines(data: [RecommendWineData])
    case _failureSocialNetworking(Error)
    
    // MARK: - Child Action
    case wineCard(IdentifiedActionOf<WineCard>)
  }
  
  @Dependency(\.wine) var wineService
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._viewWillAppear:
        return .run(operation: { send in
          switch await wineService.todaysWines() {
          case let .success(data):
            await send(._setTodaysWines(data: data))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        })
        
      case let ._setTodaysWines(data):
        let wineCardState: IdentifiedArrayOf<WineCard.State> = IdentifiedArrayOf(
          uniqueElements: data
            .enumerated()
            .map{
              WineCard.State(
                index: $0.offset,
                recommendWineData: $0.element
              )
            }
        )
        
        state.wineCards = wineCardState
        
        return .none
        
      default:
        return .none
      }
    }
    .forEach(\.wineCards, action: \.wineCard) {
      WineCard()
    }
  }
}
