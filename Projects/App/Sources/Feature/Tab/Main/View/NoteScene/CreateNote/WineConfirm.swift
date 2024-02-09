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
    
    public var isPresentedBottomSheet: Bool = false
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedWritingButton
    case tappedOutsideOfBottomSheet
    
    // MARK: - Inner Business Action
    case _moveNextPage(wineId: Int)
    case _moveBackPage
    
    // MARK: - Inner SetState Action
    case _presentBottomSheet(Bool)
    case _deleteNote
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .tappedBackButton:
        return .send(._presentBottomSheet(true))
        
      case .tappedWritingButton:
        return .send(._moveNextPage(wineId: state.wineData.wineId))
        
      case ._presentBottomSheet(let bool):
        state.isPresentedBottomSheet = bool
        return .none
        
      case ._deleteNote:
        return .send(._moveBackPage)
        
      default:
        return .none
      }
    }
  }
}
