//
//  SettingAlcohol.swift
//  Winey
//
//  Created by 정도현 on 11/29/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct SettingAlcohol: Reducer {
  public struct State: Equatable {
    public var officialAlcohol: Int? = nil  // 유저가 실제로 선택한 값.
    public var alcoholValue: Int = 12 // 초기 화면을 위해 12로 셋팅.
    public var alcoholValueRange: ClosedRange<Int> = 1...20
    
    public var pickerHeight: CGFloat = 150
    public var viewHeight: CGFloat = 362
    
    public var buttonState: Bool = false
    public var tooltipVisible: Bool = true
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tapPicker
    case selectAlcoholValue(Int)
    case tappedSkipButton
    case tappedNextButton
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _setAlcoholValue(Int)
    case _setButtonState(Bool)
    case _tooltipHide
    case _moveNextPage
    case _backToNoteDtail
    case _backToWineConfirm
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    
    Reduce { state, action in
      switch action {
      case ._viewWillAppear:
        state.alcoholValue = CreateNoteManager.shared.officialAlcohol ?? 12
        state.officialAlcohol = CreateNoteManager.shared.officialAlcohol
        
        if CreateNoteManager.shared.officialAlcohol != nil {
          return .send(._setButtonState(true))
        } else {
          return .none
        }
        
      case .tappedBackButton:
        switch CreateNoteManager.shared.mode {
        case .create:
          return .send(._backToWineConfirm)
        case .patch:
          CreateNoteManager.shared.initData()
          return .send(._backToNoteDtail)
        }
        
      case .tappedSkipButton:
        return .send(._moveNextPage)
        
      case .selectAlcoholValue(let value):
        return .send(._setAlcoholValue(value))
        
      case ._setAlcoholValue(let value):
        state.tooltipVisible = false
        state.alcoholValue = value
        state.officialAlcohol = value
        return .send(._setButtonState(true))
        
      case ._setButtonState(let bool):
        state.buttonState = bool
        return .none
        
      case .tappedNextButton:
        CreateNoteManager.shared.officialAlcohol = state.officialAlcohol
        return .send(._moveNextPage)
        
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
