//
//  Map.swift
//  Winey
//
//  Created by 정도현 on 2023/09/13.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation

public struct Map: Reducer {
  public struct State: Equatable {
    public init() { }
  }
  
  public enum Action {
    // MARK: - User Action
    case mapTapTapped
    
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
