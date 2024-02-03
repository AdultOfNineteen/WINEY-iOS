//
//  TermsPolicy.swift
//  MyPageFeature
//
//  Created by 정도현 on 2/1/24.
//

import ComposableArchitecture
import Foundation

public struct TermsPolicy: Reducer {
  public struct State: Equatable {
    
    public init() { }
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
      
    default:
      return .none
    }
  }
}
