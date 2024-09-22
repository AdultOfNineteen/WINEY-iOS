//
//  WineyPolicy.swift
//  Winey
//
//  Created by 정도현 on 4/1/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct WineyPolicy {
  
  @ObservableState
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
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
        
      default:
        return .none
      }
    }
  }
}
