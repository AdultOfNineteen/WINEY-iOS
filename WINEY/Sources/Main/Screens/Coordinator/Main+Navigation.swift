//
//  Main+Navigation.swift
//  WINEY
//
//  Created by 박혜운 on 9/22/24.
//

import ComposableArchitecture

@Reducer
public struct MainPath {
  
  @ObservableState
  public enum State: Equatable {
    case analysis(WineAnalysis.State)
    case loading(WineAnalysisLoading.State)
    case result(WineAnalysisResult.State)
  }
  
  public enum Action {
    case analysis(WineAnalysis.Action)
    case loading(WineAnalysisLoading.Action)
    case result(WineAnalysisResult.Action)
  }
  public var body: some Reducer<State, Action> {
    Scope(state: \.analysis, action: \.analysis) { WineAnalysis() }
    Scope(state: \.loading, action: \.loading) { WineAnalysisLoading() }
    Scope(state: \.result, action: \.result) { WineAnalysisResult() }
  }
}

extension Main {
  var pathReducer: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
        // MARK: - 분석화면 시작
      case .tappedAnalysisButton:
        state.path.append(.analysis(.init(isPresentedBottomSheet: false)))
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
          
        default: return .none
        }
      }
    }
    .forEach(\.path, action: \.path) {
      MainPath()
    }
  }
}
