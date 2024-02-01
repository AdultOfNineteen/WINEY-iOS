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
    var userId: Int? = nil
    
    public init() {}
  }
  
  public enum Action {
    // MARK: - User Action
    case userBadgeButtonTapped(Int?)
    case wineyRatingButtonTapped
    case wineyRatingClosedTapped
    case userSettingTapped(Int?)
    case tappedTermsPolicy
    case tappedPersonalInfoPolicy
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _presentBottomSheet(Bool)
    case _moveToBadgeTap(Int)
    case _moveToUserInfo(Int)
    
    // MARK: - Inner SetState Action
    case _failureSocialNetworking(Error)  // 추후 경고 처리
    case _setUserInfo(UserInfoDTO)
    
    // MARK: - Child Action
    
  }
  
  @Dependency(\.user) var userService
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._viewWillAppear:
      let userId = state.userId
      
      return .run { send in
        switch await userService.info() {
        case let .success(data):
          await send(._setUserInfo(data))
        case let .failure(error):
          await send(._failureSocialNetworking(error))
        }
      }
      
    case let ._setUserInfo(data):
      state.userId = data.userId
      return .none
      
    case .wineyRatingButtonTapped:
      return .send(._presentBottomSheet(true))
      
    case .wineyRatingClosedTapped:
      return .send(._presentBottomSheet(false))
      
    case let ._presentBottomSheet(value):
      state.isPresentedBottomSheet = value
      return .none
      
    case .userBadgeButtonTapped(let userId):
      if let userId = userId {
        return .send(._moveToBadgeTap(userId))
      } else {
        return .none  // TODO: 에러 분기처리
      }
      
    case .userSettingTapped(let userId):
      if let userId = userId {
        return .send(._moveToUserInfo(userId))
      } else {
        return .none  // TODO: 에러 분기처리
      }
      
    default:
      return .none
    }
  }
}
