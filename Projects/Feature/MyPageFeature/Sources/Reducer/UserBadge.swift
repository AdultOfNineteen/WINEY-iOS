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
    var sommelierBadgeList: [Badge] = []
    var activityBadgeList: [Badge] = []
    var clickedBadgeInfo: Badge? = nil
    var isTappedBadge: Bool = false
    
    public init() { }
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
    
    // MARK: - Child Action
    
  }
  
  @Dependency(\.badge) var badgeService
  @Dependency(\.uuid) var uuid
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._viewWillAppear:
      return .run { send in
        switch await badgeService.badgeList(22) {
        case let .success(data):
          print("success!!")
          await send(._setBadgeList(data))
        case let .failure(error):
          print("fail")
          await send(._failureSocialNetworking(error))
        }
      }
      
    case ._setBadgeList(let data):
      state.sommelierBadgeList = data.sommelierBadgeList
      state.activityBadgeList = data.activityBadgeList
      return .none
      
    case .tappedBadge(let badge):
      state.clickedBadgeInfo = badge
      state.isTappedBadge = true
      return .none
      
    case .tappedBadgeClosed:
      state.isTappedBadge = false
      return .none
      
    default:
      return .none
    }
  }
}
