//
//  SettingColorSmell.swift
//  Winey
//
//  Created by 정도현 on 11/28/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct SettingColorSmell: Reducer {
  public struct State: Equatable {
    public var colorBarList: [Color] = [
      Color(red: 89/255, green: 0, blue: 43/255),
      Color(red: 107/255, green: 48/255, blue: 54/255),
      Color(red: 133/255, green: 34/255, blue: 35/255),
      Color(red: 148/255, green: 31/255, blue: 37/255),
      Color(red: 203/255, green: 69/255, blue: 70/255),
      Color(red: 238/255, green: 103/255, blue: 107/255),
      Color(red: 241/255, green: 137/255, blue: 151/255),
      Color(red: 233/255, green: 180/255, blue: 167/255),
      Color(red: 242/255, green: 194/255, blue: 182/255),
      Color(red: 238/255, green: 198/255, blue: 147/255),
      Color(red: 245/255, green: 225/255, blue: 166/255),
      Color(red: 241/255, green: 235/255, blue: 203/255),
      Color(red: 213/255, green: 219/255, blue: 181/255)
    ]
    
    public var selectedSmell: [String] = []
    public var colorValue: Double = 0.0
    
    public var maxValue: CGFloat = 0
    public var scaleFactor: CGFloat = 0
    public var sliderValue: CGFloat = 0
    public var lastCoordinateValue: CGFloat = 0.0
    
    public var buttonState: Bool = false
  }
  
  public enum Action {
    
    // MARK: - User Action
    case tappedBackButton
    case tappedSmellButton(String)
    case tappedHelpSmellButton
    case dragSlider(DragGesture.Value)
    case tappedNextButton
    
    // MARK: - Inner Business Action
    case _addSmell(String)
    case _removeSmell(String)
    case _viewWillAppear(GeometryProxy)
    case _viewWillDisappear
    case _moveNextPage
    
    // MARK: - Inner SetState Action
    case _setMaxValue(CGFloat)
    case _setScaleFactor(CGFloat)
    case _setCoordinateValue(CGFloat)
    case _setColorValue(CGFloat)
    case _setSliderValue(CGFloat)
    
    // MARK: - Child Action
    case wineCard(id: Int, action: WineCard.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case ._viewWillAppear(let value):
        state.selectedSmell = CreateNoteManager.shared.smellKeywordList ?? []
        if !state.selectedSmell.isEmpty || state.colorValue != 0.0 {
          state.buttonState = true
        }
        return .send(._setMaxValue(value.size.width - 11))
        
      case ._viewWillDisappear:
        CreateNoteManager.shared.smellKeywordList = state.selectedSmell
        // TODO: 색상 추가 해야됨.
        return .none
        
      case .tappedSmellButton(let smell):
        if state.selectedSmell.contains(where: { $0 == smell }) {
          return .send(._removeSmell(smell))
        } else {
          return .send(._addSmell(smell))
        }
        
      case ._setMaxValue(let value):
        state.maxValue = value
        return .send(._setScaleFactor(value / 255))
        
      case ._setScaleFactor(let value):
        state.scaleFactor = value
        return .send(._setSliderValue(value))
        
      case ._setSliderValue(let value):
        state.sliderValue = state.colorValue * value
        return .none
        
      case ._addSmell(let smell):
        state.selectedSmell.append(smell)
        return .none
        
      case ._removeSmell(let smell):
        state.selectedSmell.removeAll(where: { $0 == smell })
        return .none
        
      case .dragSlider(let value):
        state.buttonState = true
        if abs(value.translation.width) < 0.1 {
          return .send(._setCoordinateValue(state.sliderValue))
        }
        
        if value.translation.width > 0 {
          let nextCoordinateValue = min(state.maxValue, state.lastCoordinateValue + value.translation.width)
          return .send(._setColorValue(nextCoordinateValue / state.scaleFactor))
        } else {
          let nextCoordinateValue = max(0, state.lastCoordinateValue + value.translation.width)
          return .send(._setColorValue(nextCoordinateValue / state.scaleFactor))
        }
        
      case ._setCoordinateValue(let translation):
        state.lastCoordinateValue = translation
        return .none
        
      case ._setColorValue(let value):
        state.colorValue = value
        state.sliderValue = value * state.scaleFactor
        return .none
        
      case .tappedNextButton:
        CreateNoteManager.shared.smellKeywordList = state.selectedSmell
        CreateNoteManager.shared.color = "#"+(Color(red: 255/255, green: state.colorValue/255, blue: state.colorValue/255).toHex() ?? "FFFFFF")
        return .send(._moveNextPage)
        
      default:
        return .none
      }
    }
  }
}
