//
//  SettingVintage.swift
//  Winey
//
//  Created by 정도현 on 11/29/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import UserInfoData
import SwiftUI

@Reducer
public struct SettingVintage {
  
  @ObservableState
  public struct State: Equatable {
    public var vintage: String = ""
    public var price: String = ""
    
    public var buttonState: Bool = false
    public var tooltipVisible: Bool = true
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedSkipButton
    case tappedNextButton
    case editVintage(String)
    case editPrice(String)
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _checkVintageValue(String)
    case _checkPriceValue(String)
    case _moveNextPage
    
    // MARK: - Inner SetState Action
    case _setButtonState
    case _setTooltipVisible(Bool)
    
    // MARK: - Child Action
  }
  
  @Dependency(\.continuousClock) var clock
  
  public var body: some Reducer<State, Action> {
    
    Reduce<State, Action> { state, action in
      switch action {
      case ._viewWillAppear:
        state.vintage = CreateNoteManager.shared.vintage ?? ""
        state.price = CreateNoteManager.shared.price ?? ""
        
        return .run { send in
          try await self.clock.sleep(for: .milliseconds(5000))
          await send(._setTooltipVisible(false))
        }
        
      case ._setTooltipVisible(let bool):
        withAnimation(.easeInOut(duration: 0.7)) {
          state.tooltipVisible = bool
        }
        return .none
        
      case .editVintage(let value):
        state.vintage = value
        return .none
        
      case .editPrice(let value):
        state.price = value
        return .none
        
      case ._checkVintageValue(let value):
        state.vintage = String(value.filter("0123456789".contains).prefix(4))
        return .send(._setButtonState)
        
      case ._checkPriceValue(let value):
        state.price = String(value.filter("0123456789".contains).prefix(9))
        return .send(._setButtonState)
        
      case ._setButtonState:
        state.buttonState = state.vintage.count == 4 || !state.price.isEmpty
        return .none
        
      case .tappedSkipButton:
        CreateNoteManager.shared.vintage = nil
        CreateNoteManager.shared.price = nil
        
        if CreateNoteManager.shared.mode == .create {
          AmplitudeProvider.shared.track(event: .VINTAGE_PRICE_INPUT_SKIP_CLICK)
        }
        
        return .send(._moveNextPage)
        
      case .tappedNextButton:
        CreateNoteManager.shared.vintage = state.vintage.isEmpty ? nil : state.vintage
        CreateNoteManager.shared.price = state.price.isEmpty ? nil : state.price
        
        if CreateNoteManager.shared.mode == .create {
          AmplitudeProvider.shared.track(event: .VINTAGE_PRICE_INPUT_NEXT_CLICK)
        }
        
        return .send(._moveNextPage)
        
      default:
        return .none
      }
    }
  }
}
