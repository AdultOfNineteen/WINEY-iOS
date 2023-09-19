//
//  WineAnalysisCarouselContainer.swift
//  Winey
//
//  Created by 정도현 on 2023/09/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation
import SwiftUI

public struct WineAnalysisCarouselContainer: Reducer {
  public struct State: Equatable {
    var count: Int = 6
    var pageIndex: Int = 0
    let dragThreshold: CGFloat = 30.0
    
    public init(
    ) {
      
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case dragGestureEnded(translation: CGFloat)
    
    
    // MARK: - Inner Business Action
    case _onAppear
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .dragGestureEnded(let translation):
      let dragThreshold: CGFloat = 30.0
      if translation > dragThreshold {
        state.pageIndex = max(state.pageIndex - 1, 0)
      } else if translation < -dragThreshold {
        state.pageIndex = min(state.pageIndex + 1, state.count - 1)
      }
      return .none
      
    case ._onAppear:
      return .none
    default:
      return .none
    }
  }
}
