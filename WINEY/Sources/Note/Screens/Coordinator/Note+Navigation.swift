//
//  Note+Navigation.swift
//  WINEY
//
//  Created by 박혜운 on 9/17/24.
//

import ComposableArchitecture

@Reducer
public struct NoteDestination {
  @ObservableState
  public enum State: Equatable {
    case detailFilter(FilterDetail.State)
  }
  
  public enum Action {
    case detailFilter(FilterDetail.Action)
  }
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.detailFilter, action: \.detailFilter, child: { FilterDetail() })
  }
}

extension Note {
  var destinationReducer: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .filteredNote(.tappedFilterButton):
        state.destination = .detailFilter(.init(filterOptionsBuffer: state.filteredNote.filterOptions))
        return .none
        
      case .destination(.presented(.detailFilter(.tappedBackButton))):
        return .send(.destination(.dismiss))
        
      default: return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      NoteDestination()
    }
  }
}

extension Note {
  var pathReducer: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
        // MARK: - 분석화면 시작
      case .tappedAnalysisButton:
        return .send(.tabDelegate(.analysis))
        
        // MARK: - 노트 작성 시작
      case ._moveToNoteWrite:
        return .send(.tabDelegate(.wineSearch))
        
        // MARK: - 노트 상세 화면 시작
      case let .filteredNote(.tastingNotes(.tappedNoteCard(noteId))):
        return .send(.tabDelegate(.noteDetail(noteId: noteId)))

      default: return .none
      }
    }
  }
}
