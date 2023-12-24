//
//  MainCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation

public struct Main: Reducer {
  public struct State: Equatable {
    public var wineCardListState: WineCardScroll.State?
    public var tipCards: WineTipDTO?
    public var tooltipState: Bool
    
    public init(
      tooltipState: Bool
    ) {
      self.tooltipState = tooltipState
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedAnalysisButton
    case tappedTipArrow
    case userScroll
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _navigateToAnalysis
    case _navigateToTipCard(data: WineTipDTO)
    case _tipCardWillAppear
    
    // MARK: - Inner SetState Action
    case _setTodaysWines(data: [RecommendWineData])
    case _failureSocialNetworking(Error) // 후에 경고창 처리
    case _setTipCards(data: WineTipDTO)
    
    // MARK: - Child Action
    case wineCardScroll(WineCardScroll.Action)
  }
  
  @Dependency(\.wine) var wineService
  
  public var body: some ReducerOf<Self> {
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
        state.wineCardListState = WineCardScroll.State.init(wineCards: wineCardState)
        
        return .none
        
      case ._tipCardWillAppear:
        return .run(operation: { send in
          switch await wineService.wineTips(0, 2) {
          case let .success(data):
            await send(._setTipCards(data: data))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        })
        
      case let ._setTipCards(data: data):
        state.tipCards = data
        return .none
        
        
      case .tappedAnalysisButton:
        print("Go to Analysis")
        return .send(._navigateToAnalysis)
        
      case .tappedTipArrow:
        if let data = state.tipCards {
          return .send(._navigateToTipCard(data: data))
        }
        return .none  // TODO: Error 처리
        
      case .wineCardScroll:
        return .none
        
      case .userScroll:
        state.tooltipState = false
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.wineCardListState, action: /Action.wineCardScroll) {
      WineCardScroll()
    }
  }
}
