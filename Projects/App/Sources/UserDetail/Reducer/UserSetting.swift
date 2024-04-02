//
//  UserSetting.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/29/23.
//

import ComposableArchitecture
import Foundation
import UIKit
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
    case tappedChangeNickname
    case tappedLogout
    case tappedSignOut(userId: Int)
    case tappedBottomSheetYesOption
    case tappedBottomSheetNoOption
    
    // MARK: - Inner Business Action
    case _presentBottomSheet(Bool)
    case _moveToHome
    
    // MARK: - Inner SetState Action
    case _removeUserInfo
    case _failureSocialNetworking(Error)
    
    // MARK: - Child Action
    
  }
  
  @Dependency(\.user) var userService
  @Dependency(\.userDefaults) var userDefaultsService
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .tappedLogout:
      return .send(._presentBottomSheet(true))
      
    case .tappedBottomSheetYesOption:
      return .run { send in
        switch await userService.logout(UIDevice.current.identifierForVendor!.uuidString) {
        case let .success(data):
          await send(._removeUserInfo)
        case let .failure(error):
          await send(._failureSocialNetworking(error))
        }
      }
      
    case ._removeUserInfo:
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
