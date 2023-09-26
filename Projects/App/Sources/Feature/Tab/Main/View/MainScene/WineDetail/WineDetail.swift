//
//  WineDetailInfoCore.swift
//  Winey
//
//  Created by 정도현 on 2023/09/06.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SwiftUI

public struct WineDetail: Reducer {
  public struct State: Equatable {
    let wineCardData: WineCardData
    
    public init(
      wineCardData: WineCardData
    ) {
      self.wineCardData = wineCardData
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .tappedBackButton:
      return .none
    }
  }
}
