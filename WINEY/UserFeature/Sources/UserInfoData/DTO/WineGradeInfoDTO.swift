//
//  WineGradeInfoDTO.swift
//  MyPageFeature
//
//  Created by 정도현 on 2/4/24.
//

import Foundation

public struct WineGradeInfoDTO: Codable, Identifiable, Equatable {
  public var id: String { self.name }
  
  public var name: String
  public var minCount: Int
  public var maxCount: Int
}
