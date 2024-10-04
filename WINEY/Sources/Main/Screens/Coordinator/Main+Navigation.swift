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
        return .send(.tabDelegate(.analysis))
        
        // MARK: - 와인 팁 리스트 시작
      case .tappedTipDetailButton:
        return .send(.tabDelegate(.tipCardList))
        
        // MARK: - 와인 디테일 화면 시작
      case let .scrollWine(.wineCard(.element(id: _, action: ._navigateToCardDetail(id, wineData)))):
        return .send(.tabDelegate(.detailWine(id: id, data: wineData)))

      default:
        return .none
      }
    }
  }
}
