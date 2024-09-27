//
//  TipCardList.swift
//  Winey
//
//  Created by 정도현 on 2023/09/21.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import UserInfoData
import SwiftUI
import WineyKit

@Reducer
public struct TipCardList {
  
  @ObservableState
  public struct State: Equatable {
    public var isShowNavigationBar: Bool = true
    
    public var tipCard: IdentifiedArrayOf<TipCard.State> = []
    
    public var searchPage: Int = 0
    public var searchSize: Int = 10
    
    public var isLast = false
    public var totalCnt = 0
    
    public init(isShowNavigationBar: Bool = true, searchPage: Int = 0, searchSize: Int = 10) {
      self.isShowNavigationBar = isShowNavigationBar
      self.searchPage = searchPage
      self.searchSize = searchSize
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedTipCard(url: String)
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _moveDetailTipCard(url: String)
    case _checkPagination(data: WineTipContent)
    case _fetchNextTipCardPage
    case _appendNextTipCardData
    
    // MARK: - Inner SetState Action
    case _setTipCards(data: WineTipDTO)
    case _failureSocialNetworking(Error) // 후에 경고창 처리
    case _appendTipData(newData: WineTipDTO)
    
    // MARK: - Child Action
    case tipCard(IdentifiedActionOf<TipCard>)
  }
  
  @Dependency(\.wine) var wineService
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
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
        
      case let .tappedTipCard(url):
        AmplitudeProvider.shared.track(event: .TIP_POST_CLICK)
        return .send(._moveDetailTipCard(url: url))
        
      case let ._setTipCards(data):
        let contents = data.contents
        
        let identifiedData: IdentifiedArrayOf<TipCard.State> = IdentifiedArrayOf(
          uniqueElements: contents
            .enumerated()
            .map {
              TipCard.State(
                data: $0.element
              )
            }
        )
        
        state.totalCnt = data.totalCnt
        state.isLast = data.isLast
        state.tipCard = identifiedData
        
        return .none
        
      case ._fetchNextTipCardPage:
        if state.isLast {
          return .none
        } else {
          return .send(._appendNextTipCardData)
        }
        
      case let ._checkPagination(data):
        guard let lastData = state.tipCard.last else {
          return .none
        }
        
        let checkData = TipCard.State(data: data)
        
        if lastData == checkData {
          if state.isLast {
            return .none
          } else {
            return .send(._fetchNextTipCardPage)
          }
        } else {
          return .none
        }
        
      case ._appendNextTipCardData:
        
        state.searchPage += 1
        
        let searchPage = state.searchPage
        let searchSize = state.searchSize
        
        return .run(operation: { send in
          switch await wineService.wineTips(searchPage, searchSize) {
          case let .success(data):
            await send(._appendTipData(newData: data))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        })
        
      case let ._appendTipData(newData):
        var originTipData = state.tipCard
        
        originTipData.append(
          contentsOf: newData.contents
            .enumerated()
            .map {
              TipCard.State(
                data: $0.element
              )
            }
        )
        
        state.isLast = newData.isLast
        state.tipCard = originTipData
        return .none
        
      default:
        return .none
      }
    }
    .forEach(\.tipCard, action: \.tipCard) {
      TipCard()
    }
  }
}
