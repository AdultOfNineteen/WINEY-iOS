//
//  Main+Navigation.swift
//  WINEY
//
//  Created by 박혜운 on 9/22/24.
//

import ComposableArchitecture

@Reducer
public struct MainDestination {
  @ObservableState
  public enum State: Equatable {
    case tipDetail(TipCardDetail.State)
  }
  
  public enum Action {
    case tipDetail(TipCardDetail.Action)
  }
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.tipDetail, action: \.tipDetail) { TipCardDetail() }
  }
}

@Reducer
public struct MainPath {
  
  @ObservableState
  public enum State: Equatable {
    case analysis(WineAnalysis.State)
    case loading(WineAnalysisLoading.State)
    case result(WineAnalysisResult.State)
    
    case detailWine(WineDetail.State)
    
    case tipCardList(TipCardList.State)
    case tipDetail(TipCardDetail.State)
  }
  
  public enum Action {
    case analysis(WineAnalysis.Action)
    case loading(WineAnalysisLoading.Action)
    case result(WineAnalysisResult.Action)
    
    case detailWine(WineDetail.Action)
    
    case tipCardList(TipCardList.Action)
    case tipDetail(TipCardDetail.Action)
  }
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.analysis, action: \.analysis) { WineAnalysis() }
    Scope(state: \.loading, action: \.loading) { WineAnalysisLoading() }
    Scope(state: \.result, action: \.result) { WineAnalysisResult() }
    
    Scope(state: \.detailWine, action: \.detailWine) { WineDetail() }
    
    Scope(state: \.tipCardList, action: \.tipCardList) { TipCardList() }
    Scope(state: \.tipDetail, action: \.tipDetail) { TipCardDetail() }
  }
}

extension Main {
  var destinationReducer: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .wineTipList(.tipCard(.element(id: _, action: ._navigateToDetail(url)))):
        state.destination = .tipDetail(.init(url: url))
        return .none
        
      case .destination(.presented(.tipDetail(.tappedBackButton))):
        return .send(.destination(.dismiss))
        
      default: 
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      MainDestination()
    }
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
        
        // MARK: - 와인 디테일 화면 시작
      case let .scrollWine(.wineCard(.element(id: _, action: ._navigateToCardDetail(id, wineData)))):
        state.path.append(.detailWine(.init(windId: id, wineCardData: wineData)))
        return .none
        
        // MARK: - 와인 팁 리스트 시작
      case .tappedTipDetailButton:
        state.path.append(.tipCardList(.init()))
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
          
        case let .element(id, action: .detailWine(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
        // MARK: - 팁 리스트 내 로직
        case let .element(id, action: .tipCardList(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
        case let .element(id, action: .tipCardList(.tipCard(.element(id: _, action: ._navigateToDetail(url))))):
          state.path.append(.tipDetail(.init(url: url)))
          return .none
          
        case let .element(id, action: .tipDetail(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
        default:
          return .none
        }
        
      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path) {
      MainPath()
    }
  }
}
