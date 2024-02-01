//
//  UserSetting.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/29/23.
//

import ComposableArchitecture
import Foundation
import UserDomain

public struct UserSetting: Reducer {
  public struct State: Equatable {
    var userId: Int
    var isPresentedBottomSheet: Bool = false
    
    public init(userId: Int) {
      self.userId = userId
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedLogout
    case tappedSignOut(userId: Int)
    case tappedBottomSheetYesOption
    case tappedBottomSheetNoOption
    
    // MARK: - Inner Business Action
    case _presentBottomSheet(Bool)
    case _moveToHome
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    
  }
  
  @Dependency(\.userDefaults) var userDefaultsService
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .tappedLogout:
      return .send(._presentBottomSheet(true))
      
    case .tappedBottomSheetYesOption:
      userDefaultsService.deleteValue(.accessToken)
      userDefaultsService.deleteValue(.refreshToken)
      userDefaultsService.deleteValue(.userID)
      return .send(._moveToHome)
      
    case .tappedBottomSheetNoOption:
      return .send(._presentBottomSheet(false))
      
    case let ._presentBottomSheet(value):
      state.isPresentedBottomSheet = value
      return .none
      
    default:
      return .none
    }
  }
}
