//
//  MyWineGradeDTO.swift
//  MyPageFeature
//
//  Created by 정도현 on 2/4/24.
//

import Foundation

public struct MyWineGradeDTO: Codable, Equatable {
  public var currentGrade: String
  public var expectedNextMonthGrade: String
  public var threeMonthsNoteCount: Int
}
