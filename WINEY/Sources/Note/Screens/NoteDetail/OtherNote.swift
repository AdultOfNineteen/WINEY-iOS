//
//  OtherNote.swift
//  WINEY
//
//  Created by 정도현 on 10/5/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct OtherNote {
  
  @ObservableState
  public struct State: Equatable, Identifiable {
    public var id: Int
    public var noteData: NoteContent
    public let isMine: Bool
    
    public init(noteData: NoteContent, isMine: Bool) {
      self.id = noteData.noteId
      self.noteData = noteData
      self.isMine = isMine
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedCard
    
    // MARK: - Inner Business Action
    case _moveNoteDetail(data: NoteContent, isMine: Bool)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .tappedCard:
        return .send(._moveNoteDetail(data: state.noteData, isMine: state.isMine))
        
      default:
        return .none
      }
    }
  }
}
