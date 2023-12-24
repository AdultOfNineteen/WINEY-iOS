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
  public var todaysWines: () async -> Result<[RecommendWineData], Error>
  public var winesDetail: (_ wineId: String) async -> Result<WineDTO, Error>
  public var wineTips: (_ page: Int, _ size: Int) async -> Result<WineTipDTO, Error>
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
                RecommendWineData(
                  id: $0.wineId,
                  wineType: WineType.changeType(at: $0.type),
                  name: $0.name,
                  country: $0.country,
                  varietal: $0.varietal.first ?? "", // ... 요기는 잠시 생각
                  price: $0.price
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
      },
      wineTips: { page, size in
        let dtoResult = await Provider<WineAPI>
          .init()
          .request(
            WineAPI.wineTip(page: page, size: size),
            type: WineTipDTO.self
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
      todaysWines: {
        return .success(
          [
            RecommendWineData(
              id: 1,
              wineType: .red,
              name: "mock1",
              country: "test",
              varietal: "test",
              price: 4
            ),
            RecommendWineData(
              id: 1,
              wineType: .red,
              name: "mock1",
              country: "test",
              varietal: "test",
              price: 4
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
      },
      wineTips: { page, size in
        return .success(
          WineTipDTO(
            isLast: false,
            totalCnt: 1,
            contents: [
              WineTipContent(
                wineTipId: 1,
                thumbNail: "test",
                title: "test",
                url: "test"
              )
            ]
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
