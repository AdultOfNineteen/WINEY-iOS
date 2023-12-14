//
//  UserInfo.swift
//  MyPageFeature
//
//  Created by 박혜운 on 2023/12/07.
//

import ComposableArchitecture
import Foundation

public struct UserInfo: Reducer {
  public struct State: Equatable {
    public init() { }
  }
  
  public enum Action {
    // MARK: - User Action
    case userInfoTapTapped
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    default:
      return .none
    }
  }
}
