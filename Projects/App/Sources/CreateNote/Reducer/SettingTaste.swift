//
//  SettingTaste.swift
//  Winey
//
//  Created by 정도현 on 11/29/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct SettingTaste: Reducer {
  public struct State: Equatable {
    public var sweetness: Int = 0
    public var acidity: Int = 0
    public var body: Int = 0
    public var tannin: Int = 0
    public var alcohol: Int = 0
    public var finish: Int = 0
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedNextButton
    case tappedHelpButton(wineId: Int)
  
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _moveNextPage
    case _moveBackPage
    
    // MARK: - Inner SetState Action
    case _setSweetness(Int)
    case _setAcidity(Int)
    case _setBody(Int)
    case _setTannin(Int)
    case _setAlcohol(Int)
    case _setFinish(Int)
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case ._viewWillAppear:
        state.sweetness = CreateNoteManager.shared.sweetness ?? 0
        state.acidity = CreateNoteManager.shared.acidity ?? 0
        state.body = CreateNoteManager.shared.body ?? 0
        state.tannin = CreateNoteManager.shared.tannin ?? 0
        state.alcohol = CreateNoteManager.shared.alcohol ?? 0
        state.finish = CreateNoteManager.shared.finish ?? 0
        return .none
        
      case .tappedBackButton:
        if CreateNoteManager.shared.mode == .create {
          AmplitudeProvider.shared.track(event: .TASTE_INPUT_BACK_CLICK)
        }
        
        return .send(._moveBackPage)
        
        
      case ._setSweetness(let value):
        state.sweetness = value
        CreateNoteManager.shared.sweetness = state.sweetness
        return .none
        
      case ._setAcidity(let value):
        state.acidity = value
        CreateNoteManager.shared.acidity = state.acidity
        return .none
        
      case ._setBody(let value):
        state.body = value
        CreateNoteManager.shared.body = state.body
        return .none
        
      case ._setTannin(let value):
        state.tannin = value
        CreateNoteManager.shared.tannin = state.tannin
        return .none
        
      case ._setAlcohol(let value):
        state.alcohol = value
        CreateNoteManager.shared.alcohol = state.alcohol
        return .none
        
      case ._setFinish(let value):
        state.finish = value
        CreateNoteManager.shared.finish = state.finish
        return .none
        
      case .tappedNextButton:
        if CreateNoteManager.shared.mode == .create {
          AmplitudeProvider.shared.track(event: .TASTE_INPUT_NEXT_CLICK)
        }
        
        return .send(._moveNextPage)
        
      default:
        return .none
      }
    }
  }
}
