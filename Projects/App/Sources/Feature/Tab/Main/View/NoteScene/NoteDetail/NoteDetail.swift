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
    let noteId: Int
    
    public var noteCardData: NoteDetailDTO?
    
    public var selectOption: NoteDetailOption? = nil
    public var isPresentedBottomSheet: Bool = false
    public var isPresentedRemoveSheet: Bool = false
    
    public init(noteId: Int) {
      self.noteId = noteId
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedSettingButton
    case tappedOption(NoteDetailOption)
    case tappedOutsideOfBottomSheet
    case tappedNoteDelete(Int)
    
    // MARK: - Inner Business Action
    case _navigateToCardDetail(Int, NoteCardData)
    case _presentBottomSheet(Bool)
    case _presentRemoveSheet(Bool)
    case _viewWillAppear
    
    // MARK: - Inner SetState Action
    case _setDetailNotes(data: NoteDetailDTO)
    case _failureSocialNetworking(Error)  // 추후 경고 처리
    
    // MARK: - Child Action
  }
  
  @Dependency(\.note) var noteService
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._viewWillAppear:
      let id = state.noteId
      
      return .run { send in
        switch await noteService.noteDetail(id) {
        case let .success(data):
          await send(._setDetailNotes(data: data))
        case let .failure(error):          
          await send(._failureSocialNetworking(error))
        }
      }
      
    case let ._setDetailNotes(data: data):
      state.noteCardData = data
      return .none
      
    case .tappedSettingButton:
      return .send(._presentBottomSheet(true))
      
    case .tappedOutsideOfBottomSheet:
      return .send(._presentBottomSheet(false))
      
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
      
    case .tappedNoteDelete(let noteId):
      return .run { send in
        switch await noteService.deleteNote(noteId) {
        case let .success(data):
          await send(.tappedBackButton)
          print("success")
        case let .failure(error):
          await send(._failureSocialNetworking(error))
          print("fail")
        }
      }
      
    default:
      return .none
    }
  }
}