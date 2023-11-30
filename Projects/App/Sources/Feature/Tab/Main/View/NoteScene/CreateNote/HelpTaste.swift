//
//  HelpTaste.swift
//  Winey
//
//  Created by 정도현 on 11/30/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct HelpTaste: Reducer {
  public struct State: Equatable {
    public var originSweetness: Int = 2
    public var originAcidity: Int = 3
    public var originBody: Int = 1
    public var originTannin: Int = 0
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
  
    // MARK: - Inner Business Action

    // MARK: - Inner SetState Action

    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      default:
        return .none
      }
    }
  }
}
