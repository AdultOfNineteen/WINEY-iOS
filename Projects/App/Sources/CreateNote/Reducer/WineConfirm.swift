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
    case _viewWillAppear
    case _moveNextPage
    case _moveBackPage
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case ._viewWillAppear:
        return .none
        
      case .tappedBackButton:
        return .send(._moveBackPage)
        
      case .tappedWritingButton:
        CreateNoteManager.shared.wineId = state.wineData.wineId
        AmplitudeProvider.shared.track(event: .WINE_SELECT_BUTTON_CLICK)
        return .send(._moveNextPage)
        
      default:
        return .none
      }
    }
  }
}
