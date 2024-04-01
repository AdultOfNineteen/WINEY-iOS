//
//  WineyPolicy.swift
//  Winey
//
//  Created by 정도현 on 4/1/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import Foundation

public struct WineyPolicy: Reducer {
  public struct State: Equatable {
    public var viewType: WineyPolicyViewType
    
    public init(viewType: WineyPolicyViewType) {
      self.viewType = viewType
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
      
    default:
      return .none
    }
  }
}
