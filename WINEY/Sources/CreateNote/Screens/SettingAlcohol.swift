//
//  SettingAlcohol.swift
//  Winey
//
//  Created by 정도현 on 11/29/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import UserInfoData

@Reducer
public struct SettingAlcohol {
  
  @ObservableState
  public struct State: Equatable {
    public var officialAlcohol: Double? = nil  // 유저가 실제로 선택한 값.
    
    public var alcoholValue: Int = 12
    public var alcoholValueRange: Array = Array(0...20)
    
    public var alcoholPointValue: Int = 0
    public var alcoholPointValueRange: Array = Array(0...9)
    
    public var pickerHeight: CGFloat = 150
    public var viewHeight: CGFloat = 362
    
    public var buttonState: Bool = false
    public var tooltipVisible: Bool = true
    
    public var isPresentedBottomSheet: Bool = false
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tapPicker
    case selectAlcoholValue(Int)
    case selectAlcoholPointValue(Int)
    case tappedSkipButton
    case tappedNextButton
    case tappedOutsideOfBottomSheet
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _setAlcoholValue(Int)
    case _setAlcoholPointValue(Int)
    case _setButtonState(Bool)
    case _tooltipHide
    case _moveNextPage
    case _backToNoteDetail
    case _backToWineSearch
    case _deleteNote
    case _presentBottomSheet(Bool)
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    
    Reduce { state, action in
      switch action {
      case ._viewWillAppear:
        state.officialAlcohol = CreateNoteManager.shared.officialAlcohol ?? 12.0
        
        if let officialAlcohol = state.officialAlcohol {
          state.alcoholValue = Int(officialAlcohol)
          state.alcoholPointValue = Int(modf(officialAlcohol).1 * 10)
        }
        
        if CreateNoteManager.shared.officialAlcohol != nil {
          return .send(._setButtonState(true))
        } else {
          return .none
        }
        
      case .tappedBackButton:
        return .send(._presentBottomSheet(true))
        
      case .tappedSkipButton:
        if CreateNoteManager.shared.mode == .create {
          AmplitudeProvider.shared.track(event: .ALCOHOL_INPUT_SKIP_CLICK)
        }
        return .send(._moveNextPage)
        
      case .selectAlcoholValue(let value):
        return .send(._setAlcoholValue(value))
        
      case .selectAlcoholPointValue(let value):
        return .send(._setAlcoholPointValue(value))
        
      case ._setAlcoholValue(let value):
        state.tooltipVisible = false
        state.alcoholValue = value
        return .send(._setButtonState(true))
        
      case ._setAlcoholPointValue(let value):
        state.tooltipVisible = false
        state.alcoholPointValue = value
        return .send(._setButtonState(true))
        
      case ._setButtonState(let bool):
        state.buttonState = bool
        return .none
        
      case ._presentBottomSheet(let bool):
        state.isPresentedBottomSheet = bool
        return .none
        
      case .tappedNextButton:
        let combinedAlcohol = Double(state.alcoholValue) + Double(state.alcoholPointValue) / 10.0
        state.officialAlcohol = combinedAlcohol
        
        CreateNoteManager.shared.officialAlcohol = state.officialAlcohol
        
        if CreateNoteManager.shared.mode == .create {
          AmplitudeProvider.shared.track(event: .ALCOHOL_INPUT_NEXT_CLICK)
        }
        
        return .send(._moveNextPage)
        
      case ._deleteNote:
        let mode = CreateNoteManager.shared.mode
        
        CreateNoteManager.shared.initData()
        
        switch mode {
        case .create:
          return .send(._backToWineSearch)
        case .patch:
          return .send(._backToNoteDetail)
        }
        
      case .tapPicker:
        return .send(._tooltipHide)
        
      case ._tooltipHide:
        withAnimation {
          state.tooltipVisible = false
        }
        return .none
        
      default:
        return .none
      }
    }
  }
}
