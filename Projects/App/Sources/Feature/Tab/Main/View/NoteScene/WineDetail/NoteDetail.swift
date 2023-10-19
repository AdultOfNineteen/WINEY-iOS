//
//  NoteDetail.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct NoteDetail: Reducer {
  public struct State: Equatable {
    let wineId: Int
    let noteCardData: NoteCardData
    
    public init(wineId: Int, noteCardData: NoteCardData) {
      self.wineId = wineId
      self.noteCardData = noteCardData
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    case _navigateToCardDetail(Int, NoteCardData)
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
      
    default:
      return .none
    }
  }
}
