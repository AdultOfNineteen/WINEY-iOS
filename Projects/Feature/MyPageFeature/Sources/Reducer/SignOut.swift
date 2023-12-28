//
//  SignOut.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/29/23.
//

import ComposableArchitecture
import Foundation

public struct SignOut: Reducer {
  public struct State: Equatable {
    var isPresentedBottomSheet: Bool = false
    
    public init() {}
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedLogout
    case tappedSignOut
    
    // MARK: - Inner Business Action
    case _presentBottomSheet(Bool)
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .tappedLogout:
      return .send(._presentBottomSheet(true))
      
    case let ._presentBottomSheet(value):
      state.isPresentedBottomSheet = value
      return .none
      
    default:
      return .none
    }
  }
}
