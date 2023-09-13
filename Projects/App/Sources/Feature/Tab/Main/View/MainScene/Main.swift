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
    var wineCardListState = WineCardScroll.State()
    
    public init() {}
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedAnalysisButton
    case mainTabTapped
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case wineCardScrollAction(WineCardScroll.Action)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .tappedAnalysisButton:
      return .none
    case .mainTabTapped:
      return .none
    case .wineCardScrollAction:
      return .none
    }
  } 
}
