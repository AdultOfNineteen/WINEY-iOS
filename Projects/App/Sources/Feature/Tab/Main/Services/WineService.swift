//
//  WineService.swift
//  Winey
//
//  Created by 박혜운 on 2023/10/12.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Dependencies
import Foundation
import WineyNetwork

public struct WineService {
  public var todaysWines: () async -> Result<[WineCardData], Error>
  public var winesDetail: (_ wineId: String) async -> Result<WineDTO, Error>
}

extension WineService {
  static let live = {
    return Self(
      todaysWines: {
        let dtoResult = await Provider<WineAPI>
          .init()
          .request(
            WineAPI.todaysRecommendations,
            type: [RecommendWineDTO].self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(
            dto
              .map {
                WineCardData(
                  id: $0.wineId,
                  wineType: WineType.changeType(at: $0.type),
                  wineName: $0.name,
                  nationalAnthems: $0.country,
                  varities: $0.varietal.first ?? "", // ... 요기는 잠시 생각
                  purchasePrice: Double($0.price)
                )
              }
          )
        case let .failure(error):
          return .failure(error)
        }
      },
      winesDetail: { windId in
        return await Provider<WineAPI>
          .init()
          .request(
            WineAPI.wineDetailInfo(windId: windId),
            type: WineDTO.self
          )
      }
    )
  }()
  
  static let mock = {
    return Self(
      todaysWines: {
        return .success(
          [ WineCardData(
            id: 0,
            wineType: .port,
            wineName: "mock1",
            nationalAnthems: "랄라라",
            varities: "훔훔훔",
            purchasePrice: 0.0
          ),
            WineCardData(
              id: 1,
              wineType: .rose,
              wineName: "mock2",
              nationalAnthems: "랄ㄹ라라",
              varities: "용ㅇ요요",
              purchasePrice: 0.0
            )
          ]
        )
      }, 
      winesDetail: { wineId in
        return .success(
          WineDTO(
            wineId: Int(wineId) ?? 0,
            type: "PORT",
            name: "mock1",
            country: "mock1",
            varietal: "랄라라",
            sweetness: 3,
            acidity: 2,
            body: 3,
            tannins: 4,
            wineSummary: WineSummary(
              avgPrice: 1.0,
              avgSweetness: 2,
              avgAcidity: 3,
              avgBody: 2,
              avgTannins: 1
            )
          )
        )
      }
    )
  }()
//  static let unimplemented = Self(…)
}

extension WineService: DependencyKey {
  public static var liveValue = Self.live
  public static var previewValue = Self.mock
}

extension DependencyValues {
  var wine: WineService {
    get { self[WineService.self] }
    set { self[WineService.self] = newValue }
  }
}
