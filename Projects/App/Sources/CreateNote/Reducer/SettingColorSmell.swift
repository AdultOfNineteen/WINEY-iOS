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
    
    public var selectedSmell: Set<String> = []
    
    public var colorIndicator: Color = Color(red: 89/255, green: 0, blue: 43/255)
    
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
    case _viewWillAppear
    case _moveNextPage
    case _moveBackPage
    
    // MARK: - Inner SetState Action
    case _setMaxValue(GeometryProxy)
    case _setScaleFactor(CGFloat)
    case _setCoordinateValue(CGFloat)
    case _setColorValue(CGFloat)
    case _setSliderValue
    
    // MARK: - Child Action
    case wineCard(id: Int, action: WineCard.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case ._viewWillAppear:
        if let storedColor = CreateNoteManager.shared.color {
          state.colorIndicator = Color.init(hex: storedColor)
          state.buttonState = true
        }
        
        if CreateNoteManager.shared.mode == .create {
          state.selectedSmell = CreateNoteManager.shared.smellKeywordList ?? []
        } else {
          state.selectedSmell = CreateNoteManager.shared.originalSmellKeywordList ?? []
          state.buttonState = true
        }
        
        return .none
        
        
      case .tappedBackButton:
        CreateNoteManager.shared.color = state.colorIndicator.toHex() == nil ? nil : "#" + state.colorIndicator.toHex()!
        CreateNoteManager.shared.smellKeywordList = state.selectedSmell
        return .send(._moveBackPage)
        
      case .tappedSmellButton(let smell):
        if state.selectedSmell.contains(smell) {
          return .send(._removeSmell(smell))
        } else {
          return .send(._addSmell(smell))
        }
        
      case ._setMaxValue(let value):
        let maxValue = value.size.width - 11
        state.maxValue = maxValue
        return .concatenate([
          .send(._setScaleFactor(maxValue / CGFloat(state.colorBarList.count))),
          .send(._setSliderValue)
        ])
        
      case ._setScaleFactor(let value):
        state.scaleFactor = value
        return .none
        
      case ._setSliderValue:
        if let storedColor = CreateNoteManager.shared.color {
          state.sliderValue = CGFloat(findNearestColorValue(colorList: state.colorBarList, targetColor: Color.init(hex: storedColor))) * (state.maxValue / CGFloat(state.colorBarList.count - 1))
        }
        return .none
        
      case ._addSmell(let smell):
        state.selectedSmell.insert(smell)
        return .none
        
      case ._removeSmell(let smell):
        state.selectedSmell.remove(smell)
        return .none
        
      case .dragSlider(let value):
        if !state.buttonState {
          state.buttonState = true
        }
        
        if abs(value.translation.width) < 0.1 {
          return .send(._setCoordinateValue(state.sliderValue))
        }
        
        if value.translation.width > 0 {
          let nextCoordinateValue = min(state.maxValue, state.lastCoordinateValue + value.translation.width)
          return .send(._setColorValue(nextCoordinateValue))
        } else {
          let nextCoordinateValue = max(0, state.lastCoordinateValue + value.translation.width)
          return .send(._setColorValue(nextCoordinateValue))
        }
        
      case ._setCoordinateValue(let translation):
        state.lastCoordinateValue = translation
        return .none
        
      case ._setColorValue(let value):
        state.sliderValue = value
        
        let widthPerItem = state.maxValue / CGFloat(state.colorBarList.count - 1)
        let index = Int(value / widthPerItem)
        
        if index < state.colorBarList.count - 1 {
          let firstColorComponent = UIColor(state.colorBarList[index]).cgColor.components
          let secondColorComponent = UIColor(state.colorBarList[index + 1]).cgColor.components
          let alphaValue = Float((value/widthPerItem)) - Float(index)
          
          let linearColorValue = getLinearColorValue(
            firstColor: firstColorComponent,
            secondColor: secondColorComponent,
            alpha: alphaValue
          )
          
          state.colorIndicator = Color(red: linearColorValue[0], green: linearColorValue[1], blue: linearColorValue[2])
        } else {
          state.colorIndicator = state.colorBarList[index]
        }
        
        return .none
        
      case .tappedNextButton:
        if CreateNoteManager.shared.mode == .create {
          CreateNoteManager.shared.smellKeywordList = state.selectedSmell
        } else {
          CreateNoteManager.shared.smellKeywordList = state.selectedSmell.subtracting(CreateNoteManager.shared.originalSmellKeywordList ?? [])
          CreateNoteManager.shared.deleteSmellKeywordList = CreateNoteManager.shared.originalSmellKeywordList?.subtracting(state.selectedSmell)
        }
        
        CreateNoteManager.shared.color = "#" + (state.colorIndicator.toHex() ?? "FFFFFF")
        
        return .send(._moveNextPage)
        
      default:
        return .none
      }
    }
  }
}

private func findNearestColorValue(colorList: [Color], targetColor: Color) -> CGFloat {
  var minDistance: Double = Double.infinity
  var nearestIndex: CGFloat = 0
  var alpha: CGFloat = 0
  
  for (index, color) in colorList.enumerated() {
    let targetColorComponent = UIColor(targetColor).cgColor.components
    let colorComponent = UIColor(color).cgColor.components
    
    if let colorComponent = colorComponent, let targetColorComponent = targetColorComponent {
      let targetRed = targetColorComponent[0]
      let targetGreen = targetColorComponent[1]
      let targetBlue = targetColorComponent[2]
      
      let redDiff = colorComponent[0] - targetRed
      let greenDiff = colorComponent[1] - targetGreen
      let blueDiff = colorComponent[2] - targetBlue
      
      let distance = sqrt(redDiff * redDiff + greenDiff * greenDiff + blueDiff * blueDiff)
      
      if distance < minDistance {
        minDistance = distance
        nearestIndex = CGFloat(index)
        
        if redDiff + greenDiff + blueDiff > 0 {
          alpha = -distance
        } else {
          alpha = distance
        }
      }
    } else {
      continue
    }
  }
  
  return nearestIndex + alpha
}

private func getLinearColorValue(firstColor: [CGFloat]?, secondColor: [CGFloat]?, alpha: Float) -> [Double] {
  let red = lerp(a: Float(firstColor?[0] ?? 0), b: Float(secondColor?[0] ?? 0), alpha: alpha)
  let green = lerp(a: Float(firstColor?[1] ?? 0), b: Float(secondColor?[1] ?? 0), alpha: alpha)
  let blue = lerp(a: Float(firstColor?[2] ?? 0), b: Float(secondColor?[2] ?? 0), alpha: alpha)
  
  return [red, green, blue]
}

private func lerp(a: Float, b: Float, alpha: Float) -> Double {
  return Double(a * (1 - alpha) + b * alpha)
}
