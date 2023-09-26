//
//  WineAnalysis.swift
//  Winey
//
//  Created by 정도현 on 2023/09/14.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation

public struct WineAnalysis: Reducer {
  public struct State: Equatable {
    var isPresentedBottomSheet: Bool = false
    
    public init(
      isPresentedBottomSheet: Bool
    ) {
      self.isPresentedBottomSheet = isPresentedBottomSheet
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedAnalysis
    case tappedBackButton
    case tappedConfirmButton
    case tappedOutsideOfBottomSheet
    
    // MARK: - Inner Business Action
    case _presentBottomSheet(Bool)
    case _navigateLoading
    case _onAppear
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }

  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .tappedBackButton:
      print("Tapped Back Button")
      return .none
      
    case .tappedConfirmButton:
      print("Tapped Confirm Button")
      return .send(._navigateLoading)
      
    case .tappedAnalysis:
      print("Tapped Analysis Button")
      return .send(._presentBottomSheet(true))
      
    case ._presentBottomSheet(let bool):
      state.isPresentedBottomSheet = bool
      return .none
      
    case ._onAppear:
      state.isPresentedBottomSheet = false
      return .none
    default:
      return .none
    }
  }
}
