//
//  HelpTaste.swift
//  Winey
//
//  Created by 정도현 on 11/30/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct HelpTaste {
  
  @ObservableState
  public struct State: Equatable {
    public var wineId: Int?
    public var wineDetailData: WineDTO?
    
    public init(wineId: Int) {
      self.wineId = wineId
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
    case _failFetchWineId
    
    // MARK: - Child Action
  }
  
  @Dependency(\.wine) var wineService
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._viewWillAppear:
        let wineId = CreateNoteManager.shared.wineId
        
        if let wineId = wineId {
          return .run(operation: { send in
            switch await wineService.winesDetail(wineId.description) {
            case let .success(dto):
              await send(._setDetailData(dto))
            case let .failure(error):
              await send(._failureSocialNetworking(error))
            }
          })
        } else {
          return .send(._failFetchWineId)
        }
        
      case let ._setDetailData(data):
        state.wineDetailData = data
        return .none
        
      default:
        return .none
      }
    }
  }
}
