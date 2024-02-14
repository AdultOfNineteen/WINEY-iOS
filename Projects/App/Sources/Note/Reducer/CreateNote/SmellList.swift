//
//  SmellList.swift
//  Winey
//
//  Created by 정도현 on 1/18/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct SmellList: Reducer {
  public struct State: Equatable, Identifiable {
    public var id: String {
      self.title
    }
    public var title: String
    public var list: [String]
    public var isOpenList: Bool = false
    
    public init(title: String, list: [String]) {
      self.title = title
      self.list = list
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedButton
  
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    case _setListState
    
    // MARK: - Child Action
  }
  
  @Dependency(\.note) var noteService
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .tappedButton:
        return .send(._setListState)
        
      case ._setListState:
        withAnimation {
          state.isOpenList.toggle()
        }
        return .none
        
      default:
        return .none
      }
    }
  }
}
