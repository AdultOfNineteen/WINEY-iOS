//
//  TasteAnalysisDTO.swift
//  Winey
//
//  Created by 박혜운 on 2023/10/18.
//  Copyright © 2023 com.winey. All rights reserved.
//

import Foundation

public struct TasteAnalysisDTO: Codable, Equatable {
  /// 추천 국가
  let recommendCountry: String?
  /// 추천 품종
  let recommendVarietal: String?
  /// 추천 와인타입
  let recommendWineType: String?
  /// 총 마신 와인 병수
  let totalWineCnt: Int
  /// 재구매 의사가 있는 와인
  let buyAgainCnt: Int
  let topThreeTypes: [TopType]
  let topThreeCountries: [TopCountry]
  let topThreeVarieties: [TopVarietal]
  let topSevenSmells: [TopSmell]
  let taste: Taste
  /// 평균 와인 가격
  let avgPrice: Int
  
  enum CodingKeys: String, CodingKey {
    case topThreeTypes = "top3Type"
    case topThreeCountries = "top3Country"
    case topThreeVarieties = "top3Varietal"
    case topSevenSmells = "top7Smell"
    case recommendCountry
    case recommendVarietal
    case recommendWineType
    case totalWineCnt
    case buyAgainCnt
    case taste
    case avgPrice
  }
  
  public static func == (lhs: TasteAnalysisDTO, rhs: TasteAnalysisDTO) -> Bool {
    return lhs.recommendCountry == rhs.recommendCountry &&
    lhs.recommendVarietal == rhs.recommendVarietal &&
    lhs.recommendWineType == rhs.recommendWineType &&
    lhs.totalWineCnt == rhs.totalWineCnt &&
    lhs.buyAgainCnt == rhs.buyAgainCnt &&
    lhs.topThreeTypes == rhs.topThreeTypes &&
    lhs.topThreeCountries == rhs.topThreeCountries &&
    lhs.topThreeVarieties == rhs.topThreeVarieties &&
    lhs.topSevenSmells == rhs.topSevenSmells &&
    lhs.taste == rhs.taste &&
    lhs.avgPrice == rhs.avgPrice
  }
}

public struct TopType: Codable, Equatable, Identifiable {
  let type: String
  let percent: Int
  
  public var id: String {
    self.type
  }
}

public struct TopCountry: Codable, Equatable {
  let country: String
  let count: Int
}

public struct TopVarietal: Codable, Equatable {
  let varietal: String
  let percent: Int
}

public struct TopSmell: Codable, Equatable {
  let smell: String
  let percent: Int
}

public struct Taste: Codable, Equatable {
  let sweetness: Double
  let acidity: Double
  let alcohol: Double
  let body: Double
  let tannin: Double
  let finish: Double
}
