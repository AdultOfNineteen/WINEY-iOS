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
    var wineCardListState: WineCardScroll.State?
    var tooltipState: Bool
    
    public init(
      tooltipState: Bool
    ) {
      self.tooltipState = tooltipState
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedAnalysisButton
    case mainTabTapped
    case userScroll
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _navigateToAnalysis
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case wineCardScroll(WineCardScroll.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._viewWillAppear:
        state.wineCardListState = WineCardScroll.State.init()
        return .none
        
      case .tappedAnalysisButton:
        print("Go to Analysis")
        return .send(._navigateToAnalysis)
        
      case .mainTabTapped:
        return .none
        
      case .wineCardScroll:
        state.wineCardListState = WineCardScroll.State.init()
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
