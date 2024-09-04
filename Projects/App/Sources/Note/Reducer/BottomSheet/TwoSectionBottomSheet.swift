//
//  TwoSectionBottomSheet.swift
//  Winey
//
//  Created by 정도현 on 5/22/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation

public enum TripleSectionBottomSheetMode: Equatable {
  case noteDetail(NoteDetail.State)
  
  public var firstTitle: String {
    return "삭제하기"
  }
  
  public var secondTitle: String {
    return "수정하기"
  }
  
  public var thirdTitle: String {
    return "공유하기"
  }
}

public struct TwoSectionBottomSheet: Reducer {
  public struct State: Equatable {
    
    public var noteDetail: NoteDetail.State?
    
    public var sheetMode: TripleSectionBottomSheetMode
    
    public init(sheetMode: TripleSectionBottomSheetMode) {
      self.sheetMode = sheetMode
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedFirstButton
    case tappedSecondButton
    case tappedThirdButton
    
    // MARK: - Inner Business Action
    case _onAppear
    case _onDisappear
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case noteDetail(NoteDetail.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._onAppear:
        switch state.sheetMode {
        case .noteDetail(let data):
          state.noteDetail = data
        }
        return .none
        
      case .tappedFirstButton:
        switch state.sheetMode {
        case .noteDetail:
          return .send(.noteDetail(.tappedOption(.remove)))
        }
        
      case .tappedSecondButton:
        switch state.sheetMode {
        case .noteDetail:
          return .send(.noteDetail(.tappedOption(.modify)))
        }
        
      case .tappedThirdButton:
        switch state.sheetMode {
        case .noteDetail:
          return .send(.noteDetail(.tappedOption(.shared)))
        }
        
      default:
        return .none
      }
    }
    .ifLet(\.noteDetail, action: /Action.noteDetail) {
      NoteDetail()
    }
  }
}
