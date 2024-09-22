//
//  WineGradeService.swift
//  MyPageFeature
//
//  Created by 정도현 on 2/4/24.
//

import Dependencies
import Foundation
import WineyNetwork

public struct WineGradeService {
  public var myWineGrades: (_ userId: Int) async -> Result<MyWineGradeDTO, Error>
  public var wineGrades: () async -> Result<[WineGradeInfoDTO], Error>
}

public extension WineGradeService {
  static let live = {
    return Self(
      myWineGrades: { userId in
        let dtoResult = await Provider<WineGradeAPI>
          .init()
          .request(
            WineGradeAPI.myWineGrade(userId: userId),
            type: MyWineGradeDTO.self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(dto)
        case let .failure(error):
          return .failure(error)
        }
      },
      
      wineGrades: {
        let dtoResult = await Provider<WineGradeAPI>
          .init()
          .request(
            WineGradeAPI.wineGrades,
            type: [WineGradeInfoDTO].self
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
      myWineGrades: { userId in
        return .success(
          MyWineGradeDTO(currentGrade: "test", expectedNextMonthGrade: "test", threeMonthsNoteCount: 1)
        )
      },
      
      wineGrades: {
        return .success(
          []
        )
      }
    )
  }()
  //  static let unimplemented = Self(…)
}

extension WineGradeService: DependencyKey {
  public static var liveValue = Self.live
  public static var previewValue = Self.mock
}

public extension DependencyValues {
  var wineGrade: WineGradeService {
    get { self[WineGradeService.self] }
    set { self[WineGradeService.self] = newValue }
  }
}
