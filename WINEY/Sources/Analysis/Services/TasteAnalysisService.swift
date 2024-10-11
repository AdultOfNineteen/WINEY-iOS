//
//  TasteAnalysisService.swift
//  Winey
//
//  Created by 박혜운 on 2023/10/18.
//  Copyright © 2023 com.winey. All rights reserved.
//

import Dependencies
import Foundation
import WineyNetwork

public struct TasteAnalysisService {
  public var myTasteAnalysis: () async -> Result<TasteAnalysisDTO, Error>
}

extension TasteAnalysisService {
  static let live = {
    return Self(
      myTasteAnalysis: {
        return await Provider<TastingNotesAPI>
          .init()
          .request(
            TastingNotesAPI.tasteAnalysis,
            type: TasteAnalysisDTO.self
          )
      }
    )
  }()
  
  static let mock = {
    return Self(
      myTasteAnalysis: {
        let result = TasteAnalysisDTO(
          recommendCountry: nil,
          recommendVarietal: nil,
          recommendWineType: nil,
          totalWineCnt: 0,
          buyAgainCnt: 0,
          topThreeTypes: [],
          topThreeCountries: [],
          topThreeVarieties: [],
          topSevenSmells: [],
          taste: Taste(
            sweetness: 0,
            acidity: 0,
            alcohol: 0,
            body: 0,
            tannin: 0,
            sparkling: 0,
            finish: 0
          ),
          avgPrice: 0
        )
        return .success(result)
      }
    )
  }()
}

extension TasteAnalysisService: DependencyKey {
  public static var liveValue = Self.live
  public static var previewValue = Self.mock
}

extension DependencyValues {
  var analysis: TasteAnalysisService {
    get { self[TasteAnalysisService.self] }
    set { self[TasteAnalysisService.self] = newValue }
  }
}
