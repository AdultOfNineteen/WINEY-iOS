//
//  TipCard.swift
//  WINEY
//
//  Created by 정도현 on 9/24/24.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

@Reducer
public struct TipCard {
  
  @ObservableState
  public struct State: Equatable, Identifiable {
    public var id: Int{
      return data.wineTipId
    }
    public let data: WineTipContent
    
    public init(data: WineTipContent) {
      self.data = data
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedCard
    
    // MARK: - Inner Business Action
    case _navigateToDetail(url: String)
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .tappedCard:
        return .send(._navigateToDetail(url: state.data.url))
        
      default:
        return .none
      }
    }
  }
}
