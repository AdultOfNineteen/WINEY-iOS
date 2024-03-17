//
//  WineAnalysisLoading.swift
//  Winey
//
//  Created by 정도현 on 2023/09/16.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation

public struct WineAnalysisLoading: Reducer {
  public struct State: Equatable {
    public var userNickname: String
    
    public init(userNickname: String) {
      self.userNickname = userNickname
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    case _onAppear
    case _completeAnalysis(TasteAnalysisDTO)
    case _failureNetworking(Error) // 후에 경고창 처리
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  @Dependency(\.analysis) var analysisService

  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .tappedBackButton:
      return .none
      
    case ._onAppear:
      return .run { send in
        let result = await analysisService.myTasteAnalysis()
        
        switch result {
        case let .success(data):
          await send(._completeAnalysis(data))
        case let .failure(error):
          await send(._failureNetworking(error))
        }
      }
      
    default:
      return .none
    }
  }
}
