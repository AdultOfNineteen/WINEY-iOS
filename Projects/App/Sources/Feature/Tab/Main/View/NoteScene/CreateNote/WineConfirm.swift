//
//  WineConfirm.swift
//  Winey
//
//  Created by 정도현 on 12/12/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct WineConfirm: Reducer {
  public struct State: Equatable {
    public var wineData: WineSearchContent
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedWritingButton
    
    // MARK: - Inner Business Action
    case _moveNextPage(wineId: Int)
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .tappedWritingButton:
        return .send(._moveNextPage(wineId: state.wineData.wineId))
        
      default:
        return .none
      }
    }
  }
}
