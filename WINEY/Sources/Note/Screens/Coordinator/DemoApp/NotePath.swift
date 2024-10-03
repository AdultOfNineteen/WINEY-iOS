//
//  Note+Path.swift
//  WINEY
//
//  Created by 박혜운 on 10/4/24.
//

import ComposableArchitecture

// MARK: - 데모앱 생성 시 사용 

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
