//
//  OtherNoteList.swift
//  WINEY
//
//  Created by 정도현 on 10/5/24.
//

import ComposableArchitecture
import SwiftUI

@frozen public enum OtherNoteMode {
  case top5RecoomendWine
  case top5Note
  case allList
}

@Reducer
public struct OtherNoteList {
  
  @ObservableState
  public struct State: Equatable {
    
    public let wineId: Int
    public let mode: OtherNoteMode
    
    var page: Int = 0
    var size: Int
    var totalCnt: Int = 0
    var isLast: Bool = false
    
    var userNickname: String = ""
    
    public var otherNotes: IdentifiedArrayOf<OtherNote.State> = []
    
    public init(mode: OtherNoteMode, wineId: Int) {
      self.mode = mode
      self.wineId = wineId
      self.size = mode == .allList ? 10 : 5
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedMoreOtherNote
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _checkPagination(data: NoteContent)
    case _fetchNextOtherNote
    case _moveBack
    case _fetchUserInfo
    case _fetchOtherNote
    case _moveMoreOtherNote(wineId: Int)
    
    // MARK: - Inner SetState Action
    case _setOtherNotes(NoteDTO)
    case _appendOtherNotes(NoteDTO)
    case _setNickname(String)
    
    // MARK: - Child Action
    case otherNote(IdentifiedActionOf<OtherNote>)
  }
  
  @Dependency(\.note) var noteService
  @Dependency(\.user) var userService
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._viewWillAppear:
        return .run { send in
          await send(._fetchOtherNote)
          await send(._fetchUserInfo)
        }
        
      case .tappedMoreOtherNote:
        return .send(._moveMoreOtherNote(wineId: state.wineId))
        
      case ._fetchOtherNote:
        let wineId = state.wineId
        let page = state.page
        let size = state.size
        
        return .run { send in
          switch await noteService.loadNotes(page, size, 0, [], [], nil, wineId) {
          case let .success(data):
            await send(._setOtherNotes(data))
            
          case let .failure(error):
            print("데이터 가져오기 실패 \(error.localizedDescription)")
          }
        }
        
      case ._fetchUserInfo:
        return .run { send in
          switch await userService.nickname() {
          case let .success(data):
            await send(._setNickname(data.nickname))
            
          case let .failure(error):
            print("데이터 가져오기 실패 \(error.localizedDescription)")
          }
        }
        
      case let ._setNickname(data):
        state.userNickname = data
        return .none
        
      case .tappedBackButton:
        return .send(._moveBack)
        
      case let ._setOtherNotes(data):
        state.totalCnt = data.totalCnt
        state.isLast = data.isLast
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
       
      case let ._checkPagination(data):
        guard let lastData = state.otherNotes.last else {
          return .none
        }
        
        let checkData = OtherNote.State(noteData: data, isMine: state.userNickname == data.userNickname)
        
        if lastData == checkData {
          if state.isLast {
            return .none
          } else {
            return .send(._fetchNextOtherNote)
          }
        } else {
          return .none
        }
        
      case ._fetchNextOtherNote:
        state.page += 1
        
        let wineId = state.wineId
        let page = state.page
        let size = state.size
        
        return .run { send in
          switch await noteService.loadNotes(page, size, 0, [], [], nil, wineId) {
          case let .success(data):
            await send(._appendOtherNotes(data))
            
          case let .failure(error):
            print("데이터 가져오기 실패 \(error.localizedDescription)")
          }
        }
        
      case let ._appendOtherNotes(data):
        state.totalCnt = data.totalCnt
        state.isLast = data.isLast
        
        let nextData = IdentifiedArrayOf(
          uniqueElements: data.contents
            .enumerated()
            .map {
              OtherNote.State(
                noteData: $0.element,
                isMine: state.userNickname == $0.element.userNickname
              )
            }
        )
        
        state.otherNotes.append(contentsOf: nextData)
        
        return .none
        
      default:
        return .none
      }
    }
    .forEach(\.otherNotes, action: \.otherNote) {
      OtherNote()
    }
  }
}
