//
//  SettingTaste.swift
//  Winey
//
//  Created by 정도현 on 11/29/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import UserInfoData
import SwiftUI

@Reducer
public struct SettingTaste {
  
  @ObservableState
  public struct State: Equatable {
    public var sweetness: Int = 0
    public var acidity: Int = 0
    public var body: Int = 0
    public var tannin: Int = 0
    public var alcohol: Int = 0
    public var sparkling: Int = 0
    public var finish: Int = 0
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedNextButton
    case tappedHelpButton
  
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _moveNextPage
    case _moveBackPage
    case _moveHelpPage(wineId: Int)
    
    // MARK: - Inner SetState Action
    case _setSweetness(Int)
    case _setAcidity(Int)
    case _setBody(Int)
    case _setTannin(Int)
    case _setAlcohol(Int)
    case _setSparkling(Int)
    case _setFinish(Int)
    
    // MARK: - Child Action
  }
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._viewWillAppear:
        state.sweetness = CreateNoteManager.shared.sweetness ?? 0
        state.acidity = CreateNoteManager.shared.acidity ?? 0
        state.body = CreateNoteManager.shared.body ?? 0
        state.tannin = CreateNoteManager.shared.tannin ?? 0
        state.alcohol = CreateNoteManager.shared.alcohol ?? 0
        state.sparkling = CreateNoteManager.shared.sparkling ?? 0
        state.finish = CreateNoteManager.shared.finish ?? 0
        return .none
        
      case .tappedBackButton:
        if CreateNoteManager.shared.mode == .create {
          AmplitudeProvider.shared.track(event: .TASTE_INPUT_BACK_CLICK)
        }
        
        return .send(._moveBackPage)
        
      case .tappedHelpButton:
        guard let wineId = CreateNoteManager.shared.wineId else {
          return .none
        }
        
        if CreateNoteManager.shared.mode == .create {
          AmplitudeProvider.shared.track(event: .TASTE_HELP_CLICK)
        }
        
        return .send(._moveHelpPage(wineId: wineId))
        
      case ._setSweetness(let value):
        state.sweetness = value
        return .none
        
      case ._setAcidity(let value):
        state.acidity = value
        return .none
        
      case ._setBody(let value):
        state.body = value
        return .none
        
      case ._setTannin(let value):
        state.tannin = value
        return .none
        
      case ._setAlcohol(let value):
        state.alcohol = value
        return .none
        
      case ._setSparkling(let value):
        state.sparkling = value
        return .none
        
      case ._setFinish(let value):
        state.finish = value
        return .none
        
      case .tappedNextButton:
        CreateNoteManager.shared.sweetness = state.sweetness
        CreateNoteManager.shared.acidity = state.acidity
        CreateNoteManager.shared.body = state.body
        CreateNoteManager.shared.tannin = state.tannin
        CreateNoteManager.shared.alcohol = state.alcohol
        CreateNoteManager.shared.sparkling = state.sparkling
        CreateNoteManager.shared.finish = state.finish
        
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
