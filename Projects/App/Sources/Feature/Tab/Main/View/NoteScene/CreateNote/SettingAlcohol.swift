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
    public var alcoholValue: Int = 12
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
    case tappedNextButton
  
    // MARK: - Inner Business Action
    case _setAlcoholValue(Int)
    case _setButtonState
    case _tooltipHide
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    
    Reduce { state, action in
      switch action {
      case .selectAlcoholValue(let value):
        return .send(._setAlcoholValue(value))
        
      case ._setAlcoholValue(let value):
        state.tooltipVisible = false
        state.alcoholValue = value
        return .send(._setButtonState)
        
      case ._setButtonState:
        state.buttonState = true
        return .none
        
      case .tappedNextButton:
        return .none
        
      case .tapPicker:
        return .send(._tooltipHide)
        
      case ._tooltipHide:
        state.tooltipVisible = false
        return .none
        
      default:
        return .none
      }
    }
  }
}
