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
  case shared = "공유하기"
  case remove = "삭제하기"
  case modify = "수정하기"
}

// Bottom Sheet 구분
public enum NoteDetailBottomSheet: String {
  case shared
  case setting
  case remove
}

public struct NoteDetail: Reducer {
  public struct State: Equatable {
    
    let noteId: Int
    let country: String
    let isMine: Bool
    
    public var noteCardData: NoteDetailDTO?
    public var selectOption: NoteDetailOption?
    
    public init(noteId: Int, country: String, isMine: Bool = true) {
      self.noteId = noteId
      self.country = country
      self.isMine = isMine
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedSettingButton
    case tappedOption(NoteDetailOption)
    case tappedNoteDelete(Int)
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _patchNote
    case _activateBottomSheet(mode: NoteDetailBottomSheet, data: NoteDetail.State)
    
    // MARK: - Inner SetState Action
    case _setDetailNotes(data: NoteDetailDTO)
    case _failureSocialNetworking(Error)  // 추후 경고 처리
    
    // MARK: - Child Action
  }
  
  @Dependency(\.note) var noteService
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case ._viewWillAppear:
        let id = state.noteId
        print("일단 들어오긴 함? \(id)")
        return .run { send in
          print("Run 되나?")
          switch await noteService.noteDetail(id) {
          case let .success(data):
            print("성공 \(data)")
            await send(._setDetailNotes(data: data))
          case let .failure(error):
            print("실패 \(error.localizedDescription)")
            await send(._failureSocialNetworking(error))
          }
        }
        
      case let ._setDetailNotes(data: data):
        state.noteCardData = data
        return .none
        
      case .tappedSettingButton:
        return .send(._activateBottomSheet(mode: .setting, data: state))
        
      case .tappedOption(let option):
        state.selectOption = option
        
        switch option {
        case .shared:
        // TODO: - 공유하기 기능 만들기
          return .send(._activateBottomSheet(mode: .shared, data: state))
          
        case .modify:
          CreateNoteManager.shared.mode = .patch
          
          if let noteData = state.noteCardData {
            CreateNoteManager.shared.fetchData(noteData: noteData)
            CreateNoteManager.shared.noteId = state.noteId
            
            return .run { send in
              await CreateNoteManager.shared.loadNoteImage()
              await send(._patchNote)
            }
          } else {
            return .none
          }
          
        case .remove:
          return .send(._activateBottomSheet(mode: .remove, data: state))
        }
        
      case .tappedNoteDelete(let noteId):
        return .run { send in
          switch await noteService.deleteNote(noteId) {
          case .success:
            NoteManager.shared.noteList = nil
            await send(.tappedBackButton)
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        }
        
      default:
        return .none
      }
    }
  }
}
