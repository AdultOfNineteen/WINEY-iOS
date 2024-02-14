//
//  WineAnalysis.swift
//  Winey
//
//  Created by 정도현 on 2023/09/14.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation

public struct WineAnalysis: Reducer {
  public struct State: Equatable {
    public var isPresentedBottomSheet: Bool = false
    
    public init(
      isPresentedBottomSheet: Bool
    ) {
      self.isPresentedBottomSheet = isPresentedBottomSheet
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedAnalysis
    case tappedBackButton
    case tappedConfirmButton
    case tappedOutsideOfBottomSheet
    
    // MARK: - Inner Business Action
    case _presentBottomSheet(Bool)
    case _navigateLoading
    case _onAppear
    
    // MARK: - Inner SetState Action
    case _setNoteCheck(data: NoteCheckDTO)
    case _failureSocialNetworking(Error)
    
    // MARK: - Child Action
  }
  
  @Dependency(\.note) var noteService

  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._onAppear:
      return .run { send in
        switch await noteService.noteCheck() {
        case let .success(data):
          await send(._setNoteCheck(data: data))
        case let .failure(error):
          await send(._failureSocialNetworking(error))
        }
      }
      
    case let ._setNoteCheck(data: data):
      if data.tastingNoteExists {
        return .none
      } else {
        return .send(._presentBottomSheet(true))
      }
      
    case .tappedBackButton:
      return .none
      
    case .tappedConfirmButton:
      return .send(.tappedBackButton)
      
    case .tappedAnalysis:
      return .send(._navigateLoading)
      
    case ._presentBottomSheet(let bool):
      state.isPresentedBottomSheet = bool
      return .none
      
    default:
      return .none
    }
  }
}
