//
//  TipCard.swift
//  Winey
//
//  Created by 정도현 on 2023/09/21.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation
import SwiftUI
import WineyKit

public struct TipCard: Reducer {
  public struct State: Equatable {
    public var tipCards: WineTipDTO?
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    
    // MARK: - Inner SetState Action
    case _setTipCards(data: WineTipDTO)
    case _failureSocialNetworking(Error) // 후에 경고창 처리
    
    // MARK: - Child Action
  }
  
  @Dependency(\.wine) var wineService
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
        
      case ._viewWillAppear:
        return .run(operation: { send in
          switch await wineService.wineTips(0, 10) {
          case let .success(data):
            await send(._setTipCards(data: data))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        })
        
      case let ._setTipCards(data: data):
        state.tipCards = data
        return .none
        
      default:
        return .none
      }
    }
  }
}
