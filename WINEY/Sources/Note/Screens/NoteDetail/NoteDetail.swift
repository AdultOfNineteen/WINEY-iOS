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
  case openMyNote
  case openOtherNote
}

@Reducer
public struct NoteDetail {
  
  @ObservableState
  public struct State: Equatable {
    
    let noteId: Int
    let country: String
    
    var otherNoteCount = 0
    
    public var userNickname: String = ""
    
    public var noteMode: NoteDetailSection
    public var noteCardData: NoteDetailDTO?
    public var selectOption: NoteDetailOption?
    public var otherNotes: IdentifiedArrayOf<OtherNote.State> = []
    
    @Presents var sheetDestination: NoteDetailSheetDestination.State?
    
    public init(noteMode: NoteDetailSection, noteId: Int, country: String) {
      self.noteMode = noteMode
      self.noteId = noteId
      self.country = country
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedSettingButton
    case tappedOption(NoteDetailOption)
    case tappedNoteDelete(Int)
    case tappedNoteMode(NoteDetailSection)
    case tappedMoreOtherNote
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _moveMoreOtherNote(wineId: Int)
    case _fetchUserInfo
    case _fetchNoteData
//    case _activateBottomSheet(mode: NoteDetailBottomSheet, data: NoteDetail.State)
    
    // MARK: - Inner SetState Action
    case _setDetailNotes(data: NoteDetailDTO)
    case _failureSocialNetworking(Error)  // 추후 경고 처리
    case _setOtherNotes(NoteDTO)
    case _setNoteMode(NoteDetailSection)
    case _setUserNickname(String)
    
    // MARK: - Child Action
    case sheetDestination(PresentationAction<NoteDetailSheetDestination.Action>)
    case otherNote(IdentifiedActionOf<OtherNote>)
    case delete
    
    case delegate(Delegate)
    
    public enum Delegate {
      case patchNote
    }
  }
  
  @Dependency(\.note) var noteService
  @Dependency(\.user) var userService
  @Dependency(\.kakaoShare) var kakaoShare
  
  public var body: some Reducer<State, Action> {
    
    sheetDestination
    
    Reduce<State, Action> { state, action in
      switch action {
      case ._viewWillAppear:
        return .run { send in
          await send(._fetchNoteData)
          await send(._fetchUserInfo)
        }
        
      case ._fetchNoteData:
        let id = state.noteId
        
        return .run { send in
          switch await noteService.noteDetail(id) {
          case let .success(data):
            await send(._setDetailNotes(data: data))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        }
        
      case ._fetchUserInfo:
        return .run { send in
          switch await userService.nickname() {
          case let .success(data):
            await send(._setUserNickname(data.nickname))
            
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        }
        
      case let ._setUserNickname(data):
        state.userNickname = data
        return .none
        
      case let ._setDetailNotes(data: data):
        state.noteCardData = data
        return .none
        
      case let .tappedNoteMode(mode):
        return .send(._setNoteMode(mode))
        
      case let ._setNoteMode(mode):
        state.noteMode = mode
        
        guard let cardData = state.noteCardData else {
          return .none
        }
        
        if mode == .otherNotes {
          return .run { send in
            switch await noteService.loadNotes(0, 5, 0, [], [], nil, cardData.wineId) {
            case let .success(data):
              await send(._setOtherNotes(data))
              
            case let .failure(error):
              print("데이터 가져오기 실패 \(error.localizedDescription)")
            }
          }
        } else {
          return .none
        }
        
      case let ._setOtherNotes(data):
        state.otherNoteCount = data.totalCnt
        state.otherNotes  = IdentifiedArrayOf(
          uniqueElements: data.contents
            .enumerated()
            .map {
              OtherNote.State(
                noteData: $0.element,
                isMine: state.userNickname == $0.element.userNickname
              )
            }
        )
        return .none
        
      case .tappedMoreOtherNote:
        guard let cardData = state.noteCardData else {
          return .none
        }
        
        return .send(._moveMoreOtherNote(wineId: cardData.wineId))
        
      default:
        return .none
      }
    }
    .ifLet(\.$sheetDestination, action: \.sheetDestination) {
      NoteDetailSheetDestination()
    }
    .forEach(\.otherNotes, action: \.otherNote) {
      OtherNote()
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
