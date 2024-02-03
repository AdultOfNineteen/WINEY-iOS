//
//  SignOutConfirm.swift
//  MyPageFeature
//
//  Created by 정도현 on 1/31/24.
//

import ComposableArchitecture
import Foundation
import UserDomain

public struct SignOutConfirm: Reducer {
  public struct State: Equatable {
    var userId: Int
    var selectedSignOutOption: SignOutOptions
    var userReason: String
    
    var isPresentedBottomSheet: Bool = false
    
    public init(userId: Int, selectedSignOutOption: SignOutOptions, userReason: String) {
      self.userId = userId
      self.selectedSignOutOption = selectedSignOutOption
      self.userReason = userReason
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedSignOutButton
    case tappedOutsideSheet
    case tappedConfirmButton
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    case _setSheetState(Bool)
    
    // MARK: - Child Action
    case _signOutUser(SignOutDTO)
    case _failureSocialNetworking(Error)  // 추후 경고 처리
  }
  
  @Dependency(\.user) var userService
  @Dependency(\.userDefaults) var userDefaultsService
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {

    case .tappedSignOutButton:
      let userId = state.userId
      let reason = state.selectedSignOutOption == .etc ? state.userReason : state.selectedSignOutOption.rawValue
      
      return .run { send in
        switch await userService.signOut(userId, reason) {
        case let .success(data):
          await send(._signOutUser(data))
        case let .failure(error):
          await send(._failureSocialNetworking(error))
        }
      }
    
    case .tappedOutsideSheet:
      return .send(._setSheetState(false))
      
    case .tappedConfirmButton:
      return .send(._setSheetState(false))
    
    case ._signOutUser(let data):
      userDefaultsService.deleteValue(.accessToken)
      userDefaultsService.deleteValue(.refreshToken)
      userDefaultsService.deleteValue(.userID)
      userDefaultsService.deleteValue(.socialLoginPath)
      return .send(._setSheetState(true))
      
    case ._setSheetState(let bool):
      state.isPresentedBottomSheet = bool
      return .none
      
    default:
      return .none
    }
  }
}
