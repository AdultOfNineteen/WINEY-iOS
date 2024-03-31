//
//  TipCardDetail.swift
//  Winey
//
//  Created by 정도현 on 2/4/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct TipCardDetail: Reducer {
  public struct State: Equatable {
    public var isEnterMainView: Bool = false
    public var url: String
    
    public init(isEnterMainView: Bool = false, url: String) {
      self.isEnterMainView = isEnterMainView
      self.url = url
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    case _moveToList
    case _moveToMain
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  @Dependency(\.wine) var wineService
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .tappedBackButton:
        if !state.isEnterMainView {
          return .send(._moveToList)
        } else {
          return .send(._moveToMain)
        }
        
      default:
        return .none
      }
    }
  }
}
