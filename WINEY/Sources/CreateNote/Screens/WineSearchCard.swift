//
//  WineSearchCard.swift
//  WINEY
//
//  Created by 정도현 on 9/29/24.
//

import Foundation

import ComposableArchitecture
import SwiftUI

@Reducer
public struct WineSearchCard {
  
  @ObservableState
  public struct State: Equatable, Identifiable {
    public var id: Int
    public var data: WineSearchContent
    public var searchString: String
    
    public init(data: WineSearchContent, searchString: String) {
      self.id = data.wineId
      self.data = data
      self.searchString = searchString
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedWineCard
    
    // MARK: - Inner Business Action
    case _moveNextPage(WineSearchContent)
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .tappedWineCard:
        if state.data.type == WineType.sparkl.rawValue {
          CreateNoteManager.shared.isSparkling = true
        } else {
          CreateNoteManager.shared.isSparkling = false
        }
        
        return .send(._moveNextPage(state.data))
        
      default:
        return .none
      }
    }
  }
}
