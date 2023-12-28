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
    var isPresentedBottomSheet: Bool = false
    
    public init() {}
  }
  
  public enum Action {
    // MARK: - User Action
    case userBadgeButtonTapped
    case wineyRatingButtonTapped
    case wineyRatingClosedTapped
    case userSettingTapped
    
    // MARK: - Inner Business Action
    case _presentBottomSheet(Bool)
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .wineyRatingButtonTapped:
      return .send(._presentBottomSheet(true))
      
    case .wineyRatingClosedTapped:
      return .send(._presentBottomSheet(false))
      
    case let ._presentBottomSheet(value):
      state.isPresentedBottomSheet = value
      return .none
      
    default:
      return .none
    }
  }
}
