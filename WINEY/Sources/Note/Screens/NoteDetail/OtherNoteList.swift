//
//  OtherNoteList.swift
//  WINEY
//
//  Created by 정도현 on 10/5/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct OtherNoteList {
  
  @ObservableState
  public struct State: Equatable {
    
    public let wineId: Int
    
    var page: Int = 0
    var size: Int = 10
    var totalCnt: Int = 0
    var isLast: Bool = false
    
    public var otherNotes: IdentifiedArrayOf<OtherNote.State> = []
    
    public init(wineId: Int) {
      self.wineId = wineId
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _checkPagination(data: NoteContent)
    case _fetchNextOtherNote
    case _moveBack
    
    // MARK: - Inner SetState Action
    case _setOtherNotes(NoteDTO)
    case _appendOtherNotes(NoteDTO)
    
    // MARK: - Child Action
    case otherNote(IdentifiedActionOf<OtherNote>)
  }
  
  @Dependency(\.note) var noteService
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._viewWillAppear:
        
        state.page = 0
        
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
                noteData: $0.element
              )
            }
        )
        return .none
       
      case let ._checkPagination(data):
        guard let lastData = state.otherNotes.last else {
          return .none
        }
        
        let checkData = OtherNote.State(noteData: data)
        
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
                noteData: $0.element
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
