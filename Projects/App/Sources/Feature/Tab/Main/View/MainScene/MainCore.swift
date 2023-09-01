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

public struct MainState: Equatable {
  var wineCardListState = WineCardScrollState()
  
  public init() {
    
  }
}

public enum MainAction {
  // MARK: - User Action
  case tappedAnalysisButton
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
  case wineCardScrollAction(WineCardScrollAction)
}

public struct MainEnvironment {
  public init() { }
}

public let mainReducer: Reducer<MainState, MainAction, MainEnvironment> =
Reducer { state, action, environment in
  switch action {
  case .tappedAnalysisButton:
    return .none
  case .wineCardScrollAction:
    return .none
  }
}
