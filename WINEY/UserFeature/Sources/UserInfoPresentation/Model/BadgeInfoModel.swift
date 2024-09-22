//
//  BadgeInfoModel.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/29/23.
//

import Foundation

public struct BadgeInfoModel: Identifiable, Equatable {
  public var id: String
  let title: String
  let date: String
  let description: String
}
