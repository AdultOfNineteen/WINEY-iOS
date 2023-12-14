//
//  NoteDetail.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public enum NoteDetailOption: String {
  case remove = "삭제하기"
  case modify = "수정하기"
}

public struct NoteDetail: Reducer {
  public struct State: Equatable {
    let noteCardData: NoteCardData
    
    public var selectOption: NoteDetailOption? = nil
    public var isPresentedBottomSheet: Bool = false
    public var isPresentedRemoveSheet: Bool = false
    
    public init(noteCardData: NoteCardData) {
      self.noteCardData = noteCardData
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedSettingButton
    case tappedOption(NoteDetailOption)
    case tappedOutsideOfBottomSheet
    
    // MARK: - Inner Business Action
    case _navigateToCardDetail(Int, NoteCardData)
    case _presentBottomSheet(Bool)
    case _presentRemoveSheet(Bool)
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .tappedSettingButton:
      return .send(._presentBottomSheet(true))
      
    case .tappedOption(let option):
      state.selectOption = option
      if option == .remove {
        return .send(._presentRemoveSheet(true))
      }
      else {
        return .send(._presentBottomSheet(false))
      }
    
    case ._presentBottomSheet(let bool):
      state.isPresentedBottomSheet = bool
      return .none
      
    case ._presentRemoveSheet(let bool):
      state.isPresentedRemoveSheet = bool
      return .send(._presentBottomSheet(false))
      
    default:
      return .none
    }
  }
}
