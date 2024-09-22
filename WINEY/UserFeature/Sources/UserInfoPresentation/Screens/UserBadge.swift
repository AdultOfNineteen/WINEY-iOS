//
//  UserBadge.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/28/23.
//

import ComposableArchitecture
import Foundation
import UserInfoData

@Reducer
public struct UserBadge {

  @ObservableState
  public struct State: Equatable {
    var userId: Int
    
    var sommelierBadgeList: [Badge] = []
    var activityBadgeList: [Badge] = []
    var clickedBadgeInfo: Badge? = nil
    var isTappedBadge = false
    
    var errorMsg: String = ""
    
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
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
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
        
      case ._failureSocialNetworking(let error):
        state.errorMsg = error.toProviderError()?.errorBody?.message ?? "서버 에러, 관리자에게 문의 바랍니다."
        return .none
        
      case .tappedBadge(let badge):
        let userId = state.userId
        let badgeId = badge.badgeId
        
        if badge.name == "YOUNG" {
          AmplitudeProvider.shared.track(event: .YOUNG_BADGE_CLICK)
        }
        
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
}

//extension StoreOf<UserBadge> {
//  subscript(hasBool bool: Bool) -> Bool {
//    get { state.isTappedBadge }
//    set {
//      send(.tappedBadgeClosed)
//    }
//  }
//}
