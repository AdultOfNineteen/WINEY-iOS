//
//  WinePreferTaste.swift
//  Winey
//
//  Created by 정도현 on 2023/09/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import SwiftUI

public struct WineTasteGraphData: Equatable {
  var name: String
  var value: CGFloat
  
  public init(name: String, value: CGFloat) {
    self.name = name
    self.value = value
  }
}

public struct WinePreferTaste: Reducer {
  public struct State: Equatable {
    
    let title = "선호하는 맛"
    
    var topTaste = ""
    var animation = 0.0
    
    let sweet: WineTasteGraphData
    let remain: WineTasteGraphData
    let alcohol: WineTasteGraphData
    let tannin: WineTasteGraphData
    let wineBody: WineTasteGraphData
    let acid: WineTasteGraphData
    
    public init(preferTastes taste: Taste) {
      self.sweet = WineTasteGraphData(name: "당도", value: taste.sweetness)
      self.remain = WineTasteGraphData(name: "여운", value: taste.finish)
      self.alcohol = WineTasteGraphData(name: "알코올", value: taste.alcohol)
      self.tannin = WineTasteGraphData(name: "탄닌", value: taste.tannin)
      self.wineBody = WineTasteGraphData(name: "바디", value: taste.body)
      self.acid = WineTasteGraphData(name: "산도", value: taste.acidity)
    }
  }
  
  public enum Action {
    // MARK: - User Action
    
    // MARK: - Inner Business Action
    case _onAppear
    case _calculateTopTaste
    
    // MARK: - Inner SetState Action
    case _setTopTaste(taste: String)
    
    // MARK: - Child Action
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._onAppear:
      state.animation = 1.0
      return .send(._calculateTopTaste)
      
    case ._calculateTopTaste:
      var topTaste: WineTasteGraphData = state.sweet
      
      let tasteArray = [state.sweet, state.acid, state.remain, state.wineBody, state.alcohol, state.tannin]
      
      for i in 1..<6 {
        if topTaste.value < tasteArray[i].value {
          topTaste = tasteArray[i]
        }
      }
      
      if topTaste.value == 0 {
        return .none
      } else {
        return .send(._setTopTaste(taste: topTaste.name))
      }
      
    case ._setTopTaste(let taste):
      state.topTaste = taste
      return .none
      
    default:
      return .none
    }
  }
}
