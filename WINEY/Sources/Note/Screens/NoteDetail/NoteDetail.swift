//
//  NoteDetail.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@frozen public enum NoteDetailOption: String {
  case shared = "공유하기"
  case remove = "삭제하기"
  case modify = "수정하기"
}

// Bottom Sheet 구분
@frozen public enum NoteDetailBottomSheet: String {
  case shared
  case setting
  case remove
}

// 노트 작성 열람 구분 (내 노트, 다른 사람 노트 리스트, 다른 사름 노트)
@frozen public enum NoteDetailSection: String {
  case mynote = "My Note"
  case otherNotes = "Other Notes"
  case otherNoteDetail
}

@Reducer
public struct NoteDetail {
  
  @ObservableState
  public struct State: Equatable {
    
    let noteId: Int
    let country: String
    let isMine: Bool
    
    public var noteMode: NoteDetailSection
    
    public var noteCardData: NoteDetailDTO?
    public var selectOption: NoteDetailOption?
    
    @Presents var sheetDestination: NoteDetailSheetDestination.State?
    
    public init(noteMode: NoteDetailSection, noteId: Int, country: String, isMine: Bool = true) {
      self.noteMode = noteMode
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
    case tappedNoteMode(NoteDetailSection)
    
    // MARK: - Inner Business Action
    case _viewWillAppear
//    case _activateBottomSheet(mode: NoteDetailBottomSheet, data: NoteDetail.State)
    
    // MARK: - Inner SetState Action
    case _setDetailNotes(data: NoteDetailDTO)
    case _failureSocialNetworking(Error)  // 추후 경고 처리
    case _setNoteMode(NoteDetailSection)
    
    // MARK: - Child Action
    case sheetDestination(PresentationAction<NoteDetailSheetDestination.Action>)
    case delete
    
    case delegate(Delegate)
    
    public enum Delegate {
      case patchNote
    }
  }
  
  @Dependency(\.note) var noteService
  @Dependency(\.kakaoShare) var kakaoShare
  
  public var body: some Reducer<State, Action> {
    
    sheetDestination
    
    Reduce<State, Action> { state, action in
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
        
      case let .tappedNoteMode(mode):
        return .send(._setNoteMode(mode))
        
      case let ._setNoteMode(mode):
        state.noteMode = mode
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.$sheetDestination, action: \.sheetDestination) {
      NoteDetailSheetDestination()
    }
  }
  
  func makeKakaoShareMessage(from state: State) -> KakaoShareMessage? {
    guard let noteCardData = state.noteCardData else { return nil }
    return KakaoShareMessage(
      title: "[\(noteCardData.userNickname)] 님의 [\(noteCardData.wineName)] 테이스팅 노트를 확인해보세요!",
      id: "\(state.noteId)"
    )
  }
}
