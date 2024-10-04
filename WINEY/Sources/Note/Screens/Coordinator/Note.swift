//
//  WritingNoteCore.swift
//  Winey
//
//  Created by 정도현 on 2023/08/21.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import UserInfoData

@Reducer
public struct Note {
  
  @ObservableState
  public struct State: Equatable {
    public var tooltipState: Bool = false

    public var filteredNote: FilteredNotes.State = .init()
    @Presents var destination: NoteDestination.State?

    public init() { }
  }
  
  public enum Action {
    // MARK: - User Action
    case _onAppear
    case tappedAnalysisButton
    case tappedNoteWriteButton
    
    // MARK: - Inner Business Action
    case _moveToNoteWrite

    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case filteredNote(FilteredNotes.Action)

    case destination(PresentationAction<NoteDestination.Action>)
    case tabDelegate(TabNavigationDelegate)
    
    public enum TabNavigationDelegate {
      case analysis
      case wineSearch
      case noteDetail(noteId: Int, country: String)
    }
  }
  
  @Dependency(\.note) var noteService
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.filteredNote, action: \.filteredNote) {
      FilteredNotes()
    }
    
    destinationReducer
    pathReducer
    
    Reduce<State, Action> { state, action in
      switch action {
      case let .destination(.presented(.detailFilter(.delegate(.editFilterOptions(to: newOptions))))):
        return .send(.filteredNote(.editFilterOptions(to: newOptions)))
        
      case .tappedNoteWriteButton:
        AmplitudeProvider.shared.track(event: .NOTE_CREATE_BUTTON_CLICK)
        return .send(._moveToNoteWrite)
        
      default:
        return .none
      }
    }
  }
}
