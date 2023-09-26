//
//  WineAnalysisLoading.swift
//  Winey
//
//  Created by 정도현 on 2023/09/16.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation

public struct WineAnalysisLoading: Reducer {
  public struct State: Equatable {
    let userName: String
    
    public init(
      userName: String
    ) {
      self.userName = userName
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    case _onAppear
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }

  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .tappedBackButton:
      return .none
    case ._onAppear:
      return .none
    default:
      return .none
    }
  }
}
