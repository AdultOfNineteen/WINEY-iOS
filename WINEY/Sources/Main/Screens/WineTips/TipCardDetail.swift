//
//  TipCardDetail.swift
//  Winey
//
//  Created by 정도현 on 2/4/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

@Reducer
public struct TipCardDetail {
  
  @ObservableState
  public struct State: Equatable {
    public var url: String
    
    public init(url: String) {
      self.url = url
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  @Dependency(\.wine) var wineService
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      default:
        return .none
      }
    }
  }
}
