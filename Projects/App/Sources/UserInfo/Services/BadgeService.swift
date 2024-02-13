//
//  BadgeService.swift
//  MyPageFeatureInterface
//
//  Created by 정도현 on 1/25/24.
//

import Dependencies
import Foundation
import WineyNetwork

public struct BadgeService {
  public var badgeList: (_ userId: Int) async -> Result<BadgeListDTO, Error>
  public var badgeDetail: (_ userId: Int, _ wineBadgeId: Int) async -> Result<Badge, Error>
}

extension BadgeService {
  static let live = {
    return Self(
      badgeList: { userId in
        let dtoResult = await Provider<BadgeAPI>
          .init()
          .request(
            BadgeAPI.badgeList(userId: userId),
            type: BadgeListDTO.self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(dto)
        case let .failure(error):
          return .failure(error)
        }
      },
      badgeDetail: { userId, wineBadgeId in
        let dtoResult = await Provider<BadgeAPI>
          .init()
          .request(
            BadgeAPI.badgeDetail(userId: userId, badgeId: wineBadgeId),
            type: Badge.self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(dto)
        case let .failure(error):
          return .failure(error)
        }
      }
    )
  }()
  
  static let mock = {
    return Self(
      badgeList: { userId in
        return .success(
          BadgeListDTO(
            sommelierBadgeList: [
              Badge(
                badgeId: 1,
                badgeType: "SOMMELIER",
                name: "Test",
                acquisitionMethod: "Test",
                description: "Test",
                acquiredAt: "test",
                isRead: false,
                badgeImage: ""
              )
            ],
            activityBadgeList: [
              Badge(
                badgeId: 2,
                badgeType: "ACTIVITY",
                name: "Test",
                acquisitionMethod: "Test",
                description: "Test",
                acquiredAt: "Test",
                isRead: false,
                badgeImage: ""
              )
            ]
          )
        )
      },
      badgeDetail: { userId, wineBadgeId in
        return .success(
          Badge(
            badgeId: 2,
            badgeType: "ACTIVITY",
            name: "Test",
            acquisitionMethod: "Test",
            description: "Test",
            acquiredAt: "Test",
            isRead: false,
            badgeImage: ""
          )
        )
      }
    )
  }()
  //  static let unimplemented = Self(…)
}

extension BadgeService: DependencyKey {
  public static var liveValue = Self.live
  public static var previewValue = Self.mock
}

extension DependencyValues {
  var badge: BadgeService {
    get { self[BadgeService.self] }
    set { self[BadgeService.self] = newValue }
  }
}
