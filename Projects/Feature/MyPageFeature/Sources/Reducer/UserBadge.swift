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
    var sommelierBadgeList: IdentifiedArrayOf<BadgeInfoModel> = []
    var activityBadgeList: IdentifiedArrayOf<BadgeInfoModel> = []
    var clickedBadgeInfo: BadgeInfoModel = .init(id: "", title: "", date: "", description: "")
    //      .init(title: "배지 이름", date: "취득일", description: "노트를 작성할 때 와인의 향을 신경쓰시네요.\n역시 와인을 진정으로 즐기고 음미할 줄 아시는군요!"),
    //      .init(title: "배지 이름", date: "취득일", description: "노트를 작성할 때 와인의 향을 신경쓰시네요.\n역시 와인을 진정으로 즐기고 음미할 줄 아시는군요!")
    var isTappedBadge: Bool = false
    
    public init() { }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedBadge(BadgeInfoModel)
    case tappedBadgeClosed
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    
  }
  
  @Dependency(\.uuid) var uuid
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._viewWillAppear:
      // 네트워킹 코드 추가
      state.sommelierBadgeList = IdentifiedArrayOf(uniqueElements: [.init(id: uuid().uuidString, title: "배지 이름", date: "취득일", description: "노트를 작성할 때 와인의 향을 신경쓰시네요.\n역시 와인을 진정으로 즐기고 음미할 줄 아시는군요!")])
      
      state.activityBadgeList = IdentifiedArrayOf(uniqueElements: [
        .init(id: uuid().uuidString, title: "배지 이름", date: "취득일", description: "노트를 작성할 때 와인의 향을 신경쓰시네요.\n역시 와인을 진정으로 즐기고 음미할 줄 아시는군요!"),
        .init(id: uuid().uuidString, title: "배지 이름", date: "취득일", description: "노트를 작성할 때 와인의 향을 신경쓰시네요.\n역시 와인을 진정으로 즐기고 음미할 줄 아시는군요!"),
        .init(id: uuid().uuidString, title: "배지 이름", date: "취득일", description: "노트를 작성할 때 와인의 향을 신경쓰시네요.\n역시 와인을 진정으로 즐기고 음미할 줄 아시는군요!")
      ])
      
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
