//
//  SettingVintage.swift
//  Winey
//
//  Created by 정도현 on 11/29/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct SettingVintage: Reducer {
  public struct State: Equatable {
    public var wineId: Int
    public var officialAlcohol: Int
    
    public var vintage: String = ""
    public var price: String = ""
    
    public var buttonState: Bool = false
    
    public init(wineId: Int, officialAlcohol: Int) {
      self.wineId = wineId
      self.officialAlcohol = officialAlcohol
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case editVintage(String)
    case editPrice(String)
    case tappedNextButton
    
    // MARK: - Inner Business Action
    case _checkVintageValue(String)
    case _checkPriceValue(String)
    case _moveNextPage(wineId: Int, officialAlcohol: Int, vintage: Int, price: Int)
    
    // MARK: - Inner SetState Action
    case _setButtonState
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    
    Reduce { state, action in
      switch action {
        
      case .editVintage(let value):
        state.vintage = value
        // state.settingAlcohol.tooltipVisible = false
        return .none
        
      case .editPrice(let value):
        state.price = value
        // state.settingAlcohol.tooltipVisible = false
        return .none
        
      case ._checkVintageValue(let value):
        state.vintage = String(value.filter("0123456789".contains).prefix(4))
        return .send(._setButtonState)
        
      case ._checkPriceValue(let value):
        state.price = value.filter("0123456789".contains)
        return .send(._setButtonState)
        
      case ._setButtonState:
        state.buttonState = !state.vintage.isEmpty && !state.price.isEmpty
        return .none
        
      case .tappedNextButton:
        return .send(
          ._moveNextPage(
            wineId: state.wineId,
            officialAlcohol: state.officialAlcohol,
            vintage: Int(state.vintage) ?? 0,
            price: Int(state.price) ?? 0
          )
        )
        
      default:
        return .none
      }
    }
  }
}
