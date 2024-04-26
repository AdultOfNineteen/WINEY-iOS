//
//  WineDetailInfoCore.swift
//  Winey
//
//  Created by 정도현 on 2023/09/06.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SwiftUI

public struct WineDetail: Reducer {
  public struct State: Equatable {
    let wineId: Int
    let wineCardData: RecommendWineData
    var windDetailData: WineDTO?
    
    public init(
      windId: Int,
      wineCardData: RecommendWineData
    ) {
      self.wineId = windId
      self.wineCardData = wineCardData
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    
    // MARK: - Inner SetState Action
    case _setDetailData(WineDTO)
    case _failureSocialNetworking(Error) // 후에 경고창 처리
    
    // MARK: - Child Action
  }
  
  @Dependency(\.wine) var wineService
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._viewWillAppear:
      let id = String(state.wineId)
      
      return .run(operation: { send in
        switch await wineService.winesDetail(id) {
        case let .success(dto):
          await send(._setDetailData(dto))
        case let .failure(error):
          await send(._failureSocialNetworking(error))
        }
      })
      
    case let ._setDetailData(data):
      state.windDetailData = data
      return .none
      
    case .tappedBackButton:
      return .none
      
    default:
      return .none
    }
  }
}
