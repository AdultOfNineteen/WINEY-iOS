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
    public var buttonState: Bool = false
    public var sweetness: Int = 0
    public var acidity: Int = 0
    public var body: Int = 0
    public var tannin: Int = 0
    public var alcohol: Int = 0
    public var finish: Int = 0
    
    public var originSweetness: Int = 2
    public var originAcidity: Int = 3
    public var originBody: Int = 1
    public var originTannin: Int = 0
  }
  
  public enum Action {
    // MARK: - User Action
    case tapPicker
    case selectAlcoholValue(Int)
    case tappedNextButton
    case tappedHelpButton
  
    // MARK: - Inner Business Action

    
    // MARK: - Inner SetState Action
    case _setSweetness(Int)
    case _setAcidity(Int)
    case _setBody(Int)
    case _setTannin(Int)
    case _setAlcohol(Int)
    case _setFinish(Int)
    case _setButtonState

    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case ._setButtonState:
        state.buttonState = true
        return .none
     
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
        
      case ._setFinish(let value):
        state.finish = value
        return .none
        
      default:
        return .none
      }
    }
  }
}
