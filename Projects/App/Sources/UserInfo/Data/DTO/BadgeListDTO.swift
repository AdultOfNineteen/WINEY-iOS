//
//  BadgeListDTO.swift
//  MyPageFeatureInterface
//
//  Created by 정도현 on 1/25/24.
//

import Foundation

public struct BadgeListDTO: Codable {
  public var sommelierBadgeList: [Badge]
  public var activityBadgeList: [Badge]
}

public struct Badge: Codable, Equatable {
  public var badgeId: Int
  public var badgeType: String
  public var name: String
  public var acquisitionMethod: String
  public var description: String
  public var acquiredAt: String?
  public var isRead: Bool?
  public var badgeImage: String
  public var imgUrl: String?
  public var unActivatedImgUrl: String?
}
