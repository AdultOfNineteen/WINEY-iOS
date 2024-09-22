//
//  SignOutConfirm.swift
//  MyPageFeature
//
//  Created by 정도현 on 1/31/24.
//

import ComposableArchitecture
import UserInfoData

@Reducer
public struct SignOutConfirm {
  
  @ObservableState
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
    
    // MARK: - Delegate
    case delegate(Delegate)
    
    // MARK: - Child Action
    case _signOutUser(SignOutDTO)
    case _failureSocialNetworking(Error)  // 추후 경고 처리
    
    public enum Delegate {
      case dismiss
      case signOut
    }
  }
  
  @Dependency(\.user) var userService
  @Dependency(\.userDefaults) var userDefaultsService
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .tappedBackButton:
        return .send(.delegate(.dismiss))
        
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
        return .send(.delegate(.signOut))
        
      case ._signOutUser:
        userDefaultsService.deleteValue(.accessToken)
        userDefaultsService.deleteValue(.refreshToken)
        userDefaultsService.deleteValue(.userID)
        userDefaultsService.deleteValue(.socialLoginPath)
        userDefaultsService.saveFlag(.hasLaunched, true)
        return .send(._setSheetState(true))
        
      case ._setSheetState(let bool):
        state.isPresentedBottomSheet = bool
        return .none
        
      default:
        return .none
      }
    }
  } 
}
