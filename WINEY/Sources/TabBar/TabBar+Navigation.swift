//
//  TabBar+Navigation.swift
//  WINEY
//
//  Created by 박혜운 on 10/4/24.
//

import ComposableArchitecture
import UserInfoPresentation

@Reducer
public struct TabBarPath {
  
  @ObservableState
  public enum State: Equatable {
    // MARK: - Analysis
    case analysis(WineAnalysis.State)
    case loading(WineAnalysisLoading.State)
    case result(WineAnalysisResult.State)
    
    // MARK: - Main
    case detailWine(WineDetail.State)
    case tipCardList(TipCardList.State)
    case tipDetail(TipCardDetail.State)
    
    // MARK: - NoteMain
    case noteDetail(NoteDetail.State)
    case otherNoteList(OtherNoteList.State)
    
    // MARK: - Create/Edit Note
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
    
    // MARK: - UserInfo
    case userSetting(UserSetting.State)
    case changeNickname(ChangeNickname.State)
    case signOut(SignOut.State)
    case signOutConfirm(SignOutConfirm.State)
  }
  
  public enum Action {
    // MARK: - Analysis
    case analysis(WineAnalysis.Action)
    case loading(WineAnalysisLoading.Action)
    case result(WineAnalysisResult.Action)
    
    // MARK: - Main
    case detailWine(WineDetail.Action)
    case tipCardList(TipCardList.Action)
    case tipDetail(TipCardDetail.Action)
    
    // MARK: - NoteMain
    case noteDetail(NoteDetail.Action)
    case otherNoteList(OtherNoteList.Action)
    
    // MARK: - Create/Edit Note
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
    
    // MARK: - UserInfo
    case userSetting(UserSetting.Action)
    case changeNickname(ChangeNickname.Action)
    case signOut(SignOut.Action)
    case signOutConfirm(SignOutConfirm.Action)
  }
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.analysis, action: \.analysis) { WineAnalysis() }
    Scope(state: \.loading, action: \.loading) { WineAnalysisLoading() }
    Scope(state: \.result, action: \.result) { WineAnalysisResult() }
    
    Scope(state: \.detailWine, action: \.detailWine) { WineDetail() }
    
    Scope(state: \.tipCardList, action: \.tipCardList) { TipCardList() }
    Scope(state: \.tipDetail, action: \.tipDetail) { TipCardDetail() }
    
    Scope(state: \.noteDetail, action: \.noteDetail, child: { NoteDetail() })
    Scope(state: \.otherNoteList, action: \.otherNoteList, child: { OtherNoteList() })
    
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
    
    Scope(state: \.userSetting, action: \.userSetting) { UserSetting() }
    Scope(state: \.changeNickname, action: \.changeNickname) { ChangeNickname() }
    Scope(state: \.signOut, action: \.signOut) { SignOut() }
    Scope(state: \.signOutConfirm, action: \.signOutConfirm) { SignOutConfirm() }
  }
}

extension TabBar {
  public var pathReducer: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .main(.tabDelegate(.analysis)):
        state.path.append(.analysis(.init(isPresentedBottomSheet: false)))
        return .none
      case let .main(.tabDelegate(.detailWine(id, data))):
        state.path.append(.detailWine(.init(windId: id, wineCardData: data)))
        return .none
      case .main(.tabDelegate(.tipCardList)):
        state.path.append(.tipCardList(.init()))
        return .none
        
      case .note(.tabDelegate(.analysis)):
        state.path.append(.analysis(.init(isPresentedBottomSheet: false)))
        return .none
      case let .note(.tabDelegate(.noteDetail(noteId, country))):
        state.path.append(.noteDetail(.init(noteMode: .mynote, noteId: noteId, country: country)))
        return .none
      case .note(.tabDelegate(.wineSearch)):
        state.path.append(.wineSearch(.init()))
        return .none
        
      case let .userInfo(.tabDelegate(.userSetting(id))):
        state.path.append(.userSetting(.init(userId: id)))
        return .none
        
      case let .path(action):
        switch action {
          // MARK: - 노트 분석 화면 내 로직
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
          
          // MARK: - 추천 와인 공유 노트 로직
        case let .element(id: _, action: .detailWine(.otherNoteList(.otherNote(.element(id: _, action: ._moveNoteDetail(data, isMine)))))):
          state.path.append(.noteDetail(.init(noteMode: isMine ? .openMyNote : .openOtherNote, noteId: data.noteId, country: data.country)))
          return .none
          
        case let .element(_, action: .detailWine(.otherNoteList(._moveMoreOtherNote(wineId)))):
          state.path.append(.otherNoteList(.init(mode: .all, wineId: wineId)))
          return .none
          
          // MARK: - 팁 리스트 내 로직
        case let .element(id, action: .tipCardList(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
        case let .element(_, action: .tipCardList(.tipCard(.element(id: _, action: ._navigateToDetail(url))))):
          state.path.append(.tipDetail(.init(url: url)))
          return .none
          
        case let .element(id, action: .tipDetail(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
          // MARK: - 노트 수정 화면 내 로직
        case .element(id: _, action: .noteDetail(.delegate(.patchNote))):
          state.path.append(.setAlcohol(.init()))
          return .none
          
        case let .element(id, action: .noteDetail(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
          // MARK: - 노트 공유 리스트 로직
        case let .element(id: _, action: .noteDetail(.otherNoteList(._moveMoreOtherNote(wineId)))):
          state.path.append(.otherNoteList(.init(mode: .all, wineId: wineId)))
          return .none
          
        case let .element(_, action: .otherNoteList(.otherNote(.element(id: _, action: ._moveNoteDetail(data, isMine))))):
          state.path.append(.noteDetail(.init(noteMode: isMine ? .openMyNote : .openOtherNote, noteId: data.noteId, country: data.country)))
          return .none
          
        case let .element(id, action: .otherNoteList(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
        case let .element(id: _, action: .noteDetail(.otherNoteList(.otherNote(.element(id: _, action: ._moveNoteDetail(data, isMine)))))):
          state.path.append(.noteDetail(.init(noteMode: isMine ? .openMyNote : .openOtherNote, noteId: data.noteId, country: data.country)))
          return .none
          
          // MARK: - 노트 작성 화면 내 로직
        case let .element(_, action: .wineSearch(.searchCard(.element(id: _, action: ._moveNextPage(data))))):
          state.path.append(.wineConfirm(.init(wineData: data)))
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
          
        case .element(_, action: .setMemo(._backToNoteDetail)):
          state.path.pop(to: state.path.ids.first!)
          return .none
          
        case .element(_, action: .noteDone(.tappedButton)):
          state.path.removeAll()
          return .none
          
          // MARK: - 유저 설정 화면
        case .element(id: _, action: .userSetting(.delegate(.toChangeUserNickNameView))):
          state.path.append(.changeNickname(.init()))
          return .none
          
        case let .element(id: _, action: .userSetting(.delegate(.toSignOutView(userId)))):
          state.path.append(.signOut(.init(userId: userId)))
          return .none
          
        case let .element(id: _, action: .signOut(.delegate(.toSignOutConfirmView(userId, selectedOption, userReason)))):
          state.path.append(.signOutConfirm(.init(userId: userId, selectedSignOutOption: selectedOption, userReason: userReason)))
          return .none
          
        case let .element(id: id, action: .userSetting(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
        case .element(id: _, action: .changeNickname(.delegate(.dismiss))):
          state.path.removeLast()
          return .none
          
        case .element(id: _, action: .signOut(.delegate(.dismiss))):
          state.path.removeLast()
          return .none
          
        case .element(id: _, action: .signOutConfirm(.delegate(.dismiss))):
          state.path.removeLast()
          return .none
          
          // MARK: - delegate 상위 전달 로직
        case .element(id: _, action: .userSetting(.delegate(.logOut))):
          return .send(.delegate(.logout))
          
        case .element(id: _, action: .signOutConfirm(.delegate(.signOut))):
          return .send(.delegate(.signOut))
          
          // MARK: - 하위 정보 하위로 전달
        case let .element(id: _, action: .changeNickname(.delegate(.changeNickName(newNickName)))):
          return .send(.userInfo(._changeNickname(newNickName)))
          
        default: return .none
        }
        
      default: return .none
      }
    }
    .forEach(\.path, action: \.path) {
      TabBarPath()
    }
  }
}
