//
//  NoteCard.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI


public struct NoteCard: Reducer {
  public struct State: Equatable, Identifiable {
    public var index: Int
    var noteCardData: NoteCardData
    public var id: Int { self.index }
  }
  
  public enum Action {
    // MARK: - User Action
    case noteCardTapped
    
    // MARK: - Inner Business Action
    case _navigateToCardDetail(Int, NoteCardData)
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .noteCardTapped:
      print("navigate to note detail")
      return .none
      
    case ._navigateToCardDetail:
      return .none
      
    default:
      return .none
    }
  }
}
