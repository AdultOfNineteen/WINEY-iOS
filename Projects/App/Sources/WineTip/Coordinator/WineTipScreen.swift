//
//  WineTipScreen.swift
//  Winey
//
//  Created by 정도현 on 3/31/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct WineTipScreen: Reducer {
  public enum State: Equatable {
    case tipCardList(TipCard.State)
    case tipCardDetail(TipCardDetail.State)
  }

  public enum Action {
    case tipCardList(TipCard.Action)
    case tipCardDetail(TipCardDetail.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.tipCardList, action: /Action.tipCardList) {
      TipCard()
    }
    Scope(state: /State.tipCardDetail, action: /Action.tipCardDetail) {
      TipCardDetail()
    }
  }
}
