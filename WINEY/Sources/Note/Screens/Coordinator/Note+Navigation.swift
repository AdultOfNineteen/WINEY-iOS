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

@Reducer
public struct NotePath {

  @ObservableState
  public enum State: Equatable {
    case analysis(WineAnalysis.State)
    case loading(WineAnalysisLoading.State)
    case result(WineAnalysisResult.State)
    
    
    case noteDetail(NoteDetail.State)
    
    case wineSearch(WineSearch.State)
    case wineConfirm(WineConfirm.State)
    case setAlcohol(SettingAlcohol.State)
    case setVintage(SettingVintage.State)
    case setColorSmell(SettingColorSmell.State)
    case helpSmell(HelpSmell.State)
    case setTaste(SettingTaste.State)
    case helpTaste(HelpTaste.State)
    case setMemo(SettingMemo.State)
    case noteDone(NoteDone.State)
  }

  public enum Action {
    case analysis(WineAnalysis.Action)
    case loading(WineAnalysisLoading.Action)
    case result(WineAnalysisResult.Action)

    
    case noteDetail(NoteDetail.Action)
    
    case wineSearch(WineSearch.Action)
    case wineConfirm(WineConfirm.Action)
    case setAlcohol(SettingAlcohol.Action)
    case setVintage(SettingVintage.Action)
    case setColorSmell(SettingColorSmell.Action)
    case helpSmell(HelpSmell.Action)
    case setTaste(SettingTaste.Action)
    case helpTaste(HelpTaste.Action)
    case setMemo(SettingMemo.Action)
    case noteDone(NoteDone.Action)
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.analysis, action: \.analysis) { WineAnalysis() }
    Scope(state: \.loading, action: \.loading) { WineAnalysisLoading() }
    Scope(state: \.result, action: \.result) { WineAnalysisResult() }
    
    
    Scope(state: \.noteDetail, action: \.noteDetail, child: { NoteDetail() })
    
    Scope(state: \.wineSearch, action: \.wineSearch) { WineSearch() }
    Scope(state: \.wineConfirm, action: \.wineConfirm) { WineConfirm() }
    Scope(state: \.setAlcohol, action: \.setAlcohol) { SettingAlcohol() }
    Scope(state: \.setVintage, action: \.setVintage) { SettingVintage() }
    Scope(state: \.setColorSmell, action: \.setColorSmell) { SettingColorSmell() }
    Scope(state: \.helpSmell, action: \.helpSmell) { HelpSmell() }
    Scope(state: \.setTaste, action: \.setTaste) { SettingTaste() }
    Scope(state: \.helpTaste, action: \.helpTaste) { HelpTaste() }
    Scope(state: \.setMemo, action: \.setMemo) { SettingMemo() }
    Scope(state: \.noteDone, action: \.noteDone) { NoteDone() }
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
        state.path.append(.analysis(.init(isPresentedBottomSheet: false)))
        return .none
        
        // MARK: - 노트 작성 시작
      case ._moveToNoteWrite:
        state.path.append(.wineSearch(.init()))
        return .none
        
        // MARK: - 노트 상세 화면 시작
      case let .filteredNote(.tastingNotes(.tappedNoteCard(noteId, country))):
        state.path.append(.noteDetail(.init(noteId: noteId, country: country)))
        return .none
        
        // MARK: - 경로 내 이동
      case let .path(action):
          // MARK: - 노트 분석 화면 내 로직
        switch action {
        case let .element(id: _, action: .analysis(._navigateLoading(nickName))):
          state.path.append(.loading(.init(userNickname: nickName)))
          return .none
          
        case let .element(id, action: .loading(._completeAnalysis(data))):
          state.path.pop(from: id)
          state.path.append(.result(.init(data: data)))
          return .none
          
        case let .element(id, action: .loading(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
        case let .element(id, action: .result(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
        case let .element(id, action: .analysis(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
      // MARK: - 노트 수정 화면 내 로직
        case .element(id: _, action: .noteDetail(.delegate(.patchNote))):
          state.path.append(.setAlcohol(.init()))
          return .none
          
        case let .element(id, action: .noteDetail(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
      // MARK: - 노트 작성 화면 내 로직
        case let .element(_, action: .wineSearch(.tappedWineCard(wineCard))):
          state.path.append(.wineConfirm(.init(wineData: wineCard)))
          return .none
          
        case .element(_, action: .wineConfirm(._moveNextPage)):
          state.path.append(.setAlcohol(.init()))
          return .none
          
        case .element(_, action: .setAlcohol(._moveNextPage)):
          state.path.append(.setVintage(.init()))
          return .none
          
        case .element(_, action: .setVintage(._moveNextPage)):
          state.path.append(.setColorSmell(.init()))
          return .none
          
        case .element(_, action: .setColorSmell(._moveNextPage)):
          state.path.append(.setTaste(.init()))
          return .none
          
        case .element(_, action: .setTaste(._moveNextPage)):
          state.path.append(.setMemo(.init()))
          return .none
          
        case .element(_, action: .setColorSmell(._moveSmellHelp)):
          state.path.append(.helpSmell(.init()))
          return .none
          
        case let .element(_, action: .setTaste(._moveHelpPage(wineId))):
          state.path.append(.helpTaste(.init(wineId: wineId)))
          return .none
          
        case .element(id: _, action: .setMemo(._moveNextPage)):
          state.path.append(.noteDone(.init()))
          return .none
          
        case let .element(id, action: .wineSearch(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
        case let .element(id, action: .wineConfirm(._moveBackPage)):
          state.path.pop(from: id)
          return .none
          
        case let .element(id, action: .setAlcohol(._backToWineSearch)):
          state.path.pop(from: id)
          return .none
          
        case let .element(id, action: .setVintage(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
        case let .element(id, action: .setColorSmell(._moveBackPage)):
          state.path.pop(from: id)
          return .none
          
        case let .element(id, action: .helpSmell(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
        case let .element(id, action: .setTaste(._moveBackPage)):
          state.path.pop(from: id)
          return .none

        case let .element(id, action: .helpTaste(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
        case let .element(id, action: .setMemo(._moveBackPage)):
          state.path.pop(from: id)
          return .none
          
        case let .element(id, action: .noteDone(.tappedButton)):
          state.path.removeAll()
          return .none

        default: return .none
        }
        
      default: return .none
      }
    }
    .forEach(\.path, action: \.path) {
      NotePath()
    }
  }
}
