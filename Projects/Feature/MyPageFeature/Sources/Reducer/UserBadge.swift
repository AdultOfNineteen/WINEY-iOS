//
//  UserBadge.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/28/23.
//

import ComposableArchitecture
import Foundation

public struct UserBadge: Reducer {
  public struct State: Equatable {
    var userId: Int
    
    var sommelierBadgeList: [Badge] = []
    var activityBadgeList: [Badge] = []
    var clickedBadgeInfo: Badge? = nil
    var isTappedBadge: Bool = false
    
    public init(userId: Int) {
      self.userId = userId
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedBadge(Badge)
    case tappedBadgeClosed
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    
    // MARK: - Inner SetState Action
    case _failureSocialNetworking(Error)  // 추후 경고 처리
    case _setBadgeList(BadgeListDTO)
    case _setBadgeDetail(Badge)
    
    // MARK: - Child Action
    
  }
  
  @Dependency(\.badge) var badgeService
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._viewWillAppear:
      let userId = state.userId
      
      return .run { send in
        switch await badgeService.badgeList(userId) {
        case let .success(data):
          await send(._setBadgeList(data))
        case let .failure(error):
          await send(._failureSocialNetworking(error))
        }
      }
      
    case ._setBadgeList(let data):
      state.sommelierBadgeList = data.sommelierBadgeList
      state.activityBadgeList = data.activityBadgeList
      return .none
      
    case .tappedBadge(let badge):
      let userId = state.userId
      let badgeId = badge.badgeId
      
      return .run { send in
        switch await badgeService.badgeDetail(userId, badgeId) {
        case let .success(data):
          await send(._setBadgeDetail(data))
        case let .failure(error):
          await send(._failureSocialNetworking(error))
        }
      }
      
    case ._setBadgeDetail(let data):
      state.clickedBadgeInfo = data
      state.isTappedBadge = true
      return .none
      
    case .tappedBadgeClosed:
      state.isTappedBadge = false
      
      let userId = state.userId
      
      return .run { send in
        switch await badgeService.badgeList(userId) {
        case let .success(data):
          await send(._setBadgeList(data))
        case let .failure(error):
          await send(._failureSocialNetworking(error))
        }
      }
      
    default:
      return .none
    }
  }
}
