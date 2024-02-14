//
//  WineGradeInfoDTO.swift
//  MyPageFeature
//
//  Created by 정도현 on 2/4/24.
//

import Foundation

public struct WineGradeInfoDTO: Codable {
  public var gradeList: [WineGrade]
}

public struct WineGrade: Codable {
  public var name: String
  public var minCount: Int
  public var maxCount: Int
}
