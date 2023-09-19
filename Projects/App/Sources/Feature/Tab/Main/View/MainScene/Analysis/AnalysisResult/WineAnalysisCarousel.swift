//
//  WineAnalysisCarouselContainer.swift
//  Winey
//
//  Created by 정도현 on 2023/09/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation
import SwiftUI

public struct WineAnalysisCarousel: Reducer {
  public struct State: Equatable {
    
    let pageCount: Int = 6
    var pageIndex: Int = 0
    
    var wineCategory = WinePreferCategory.State.init()
    var wineTaste = WinePreferTaste.State.init()
    var wineSmell = WinePreferSmell.State.init()
    var winePrice = WinePrice.State.init()
    
    public init() { }
  }
  
  public enum Action {
    // MARK: - User Action
    case dragGesture(DragGesture.Value)
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    case winePreferNation(WinePreferNation.Action)
    case wineCategory(WinePreferCategory.Action)
    case wineTaste(WinePreferTaste.Action)
    case wineSmell(WinePreferSmell.Action)
    case winePrice(WinePrice.Action)
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .dragGesture(gesture):
        let dragThreshold: CGFloat = 50.0
        if gesture.translation.height > dragThreshold {
          state.pageIndex = max(state.pageIndex - 1, 0)
        } else if gesture.translation.height < -dragThreshold {
          state.pageIndex = min(state.pageIndex + 1, state.pageCount - 1)
        }
        return .none
        
      default:
        return .none
      }
    }
    
    Scope(state: \.wineCategory, action: /Action.wineCategory) {
      WinePreferCategory()
    }
    Scope(state: \.wineTaste, action: /Action.wineTaste) {
      WinePreferTaste()
    }
    Scope(state: \.wineSmell, action: /Action.wineSmell) {
      WinePreferSmell()
    }
    Scope(state: \.winePrice, action: /Action.winePrice) {
      WinePrice()
    }
  }
}
