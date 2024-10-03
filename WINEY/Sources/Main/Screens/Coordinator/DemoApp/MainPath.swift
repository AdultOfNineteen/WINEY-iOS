//
//  MainPath.swift
//  WINEY
//
//  Created by 박혜운 on 10/4/24.
//

import ComposableArchitecture

// MARK: - Main 데모 앱 생성 시 활용 

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
