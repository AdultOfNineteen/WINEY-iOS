//
//  CustomCamera.swift
//  Winey
//
//  Created by 정도현 on 3/10/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct CustomCamera {
  public struct State: Equatable {
    
  }
  
  public enum Action: Equatable {
    case savePhoto(UIImage)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
