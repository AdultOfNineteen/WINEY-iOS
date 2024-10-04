//
//  UserSetting.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/29/23.
//

import ComposableArchitecture
import UIKit

@Reducer
public struct UserSetting {
  
  @ObservableState
  public struct State: Equatable {
    public var userId: Int
    public var isPresentedBottomSheet: Bool = false
    
    @Presents public var destination: UserInfoPath.State?
    
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
    case destination(PresentationAction<UserInfoPath.Action>)
    
    // MARK: - Delegate
    case delegate(Delegate)
    
    public enum Delegate {
      case toChangeUserNickNameView
      case toSignOutView(userId: Int)
      case dismiss
      case logOut
    }
  }
  
  @Dependency(\.user) var userService
  @Dependency(\.userDefaults) var userDefaultsService
  
  public init() { }
  
  public var body: some Reducer<State, Action> {
    
    Reduce<State, Action> { state, action in
      switch action {
        
      case .tappedChangeNickname:
        return .send(.delegate(.toChangeUserNickNameView))
        
      case let .tappedSignOut(userId):
        return .send(.delegate(.toSignOutView(userId: userId)))
        
      case .tappedLogout:
        return .send(._presentBottomSheet(true))
        
      case .tappedBottomSheetYesOption:
        return .run { send in
          switch await userService.logout(UIDevice.current.identifierForVendor!.uuidString) {
          case .success:
            await send(._removeUserInfo)
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        }
        
      case ._removeUserInfo:
        userDefaultsService.deleteValue(.accessToken)
        userDefaultsService.deleteValue(.refreshToken)
        userDefaultsService.deleteValue(.userID)
        return .send(.delegate(.logOut))
        
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
}
