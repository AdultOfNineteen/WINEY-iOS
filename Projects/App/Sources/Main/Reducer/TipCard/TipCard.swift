//
//  TipCard.swift
//  Winey
//
//  Created by 정도현 on 2023/09/21.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import WineyKit

public struct TipCard: Reducer {
  public struct State: Equatable {
    public var tipCards: WineTipDTO?
    
    public var searchPage: Int = 0
    public var searchSize: Int = 10
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedTipCard(url: String)
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _fetchNextTipCardPage
    case _appendNextTipCardData(WineTipDTO)
    
    // MARK: - Inner SetState Action
    case _setTipCards(data: WineTipDTO)
    case _failureSocialNetworking(Error) // 후에 경고창 처리
    case _appendTipData(WineTipDTO, data: WineTipDTO)
    
    // MARK: - Child Action
  }
  
  @Dependency(\.wine) var wineService
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
        
      case ._viewWillAppear:
        
        let searchPage = state.searchPage
        let searchSize = state.searchSize
        
        return .run(operation: { send in
          switch await wineService.wineTips(searchPage, searchSize) {
          case let .success(data):
            await send(._setTipCards(data: data))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        })
        
      case let ._setTipCards(data: data):
        state.tipCards = data
        return .none
        
      case ._fetchNextTipCardPage:
        guard let tipCardData = state.tipCards else {
          return .none
        }
        
        if tipCardData.isLast {
          return .none
        } else {
          return .send(._appendNextTipCardData(tipCardData))
        }
      
      case let ._appendNextTipCardData(tipCardData):

        state.searchPage += 1
        
        let searchPage = state.searchPage
        let searchSize = state.searchSize
        
        return .run(operation: { send in
          switch await wineService.wineTips(searchPage, searchSize) {
          case let .success(data):
            await send(._appendTipData(tipCardData, data: data))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        })
        
      case let ._appendTipData(tipCardData, newData):
        var originTipData = tipCardData
        
        originTipData.contents.append(contentsOf: newData.contents)
        originTipData.isLast = newData.isLast
        originTipData.totalCnt = newData.totalCnt
        
        state.tipCards = originTipData
        
        return .none
        
      default:
        return .none
      }
    }
  }
}
