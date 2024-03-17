//
//  CustomCamera.swift
//  Winey
//
//  Created by 정도현 on 3/10/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct CustomCamera: Reducer {
  public struct State: Equatable {
    
  }
  
  public enum Action: Equatable {
    case savePhoto(UIImage)
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
