//
//  NoteDetail+SheetDestination.swift
//  WINEY
//
//  Created by 박혜운 on 9/22/24.
//

import ComposableArchitecture

@Reducer
public struct NoteDetailSheetDestination {
  public enum State: Equatable {
    case tripleSectionSheet(TripleSectionBottomSheet.State)
    case noteRemoveSheet(NoteRemoveBottomSheet.State)
  }
  
  public enum Action {
    case tripleSectionSheet(TripleSectionBottomSheet.Action)
    case noteRemoveSheet(NoteRemoveBottomSheet.Action)
  }
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.tripleSectionSheet, action: \.tripleSectionSheet, child: { TripleSectionBottomSheet() })
    Scope(state: \.noteRemoveSheet, action: \.noteRemoveSheet, child: { NoteRemoveBottomSheet() })
  }
}

extension NoteDetail {
  var sheetDestination: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .tappedSettingButton:
        state.sheetDestination = .tripleSectionSheet(.init())
        return .none
        
      case .sheetDestination(.presented(.tripleSectionSheet(.tappedFirstButton))):
        return .send(.tappedOption(.shared))
        
      case .sheetDestination(.presented(.tripleSectionSheet(.tappedSecondButton))):
        return .send(.tappedOption(.remove))
        
      case .sheetDestination(.presented(.tripleSectionSheet(.tappedThirdButton))):
        return .send(.tappedOption(.modify))
        
      case .tappedOption(let option):
        state.selectOption = option
        
        switch option {
        case .shared:
          let state = state
          guard let kakaoMessage = makeKakaoShareMessage(from: state) else { return .none }
          
          return .run { send in
            do {
              try await kakaoShare.share(kakaoMessage)
//              await send(._activateBottomSheet(mode: .shared, data: state))
            } catch {
              print("🐛 \(error)")
            }
          }
          
        case .modify:
          CreateNoteManager.shared.mode = .patch
          
          state.sheetDestination = nil
          
          if let noteData = state.noteCardData {
            CreateNoteManager.shared.fetchData(noteData: noteData)
            CreateNoteManager.shared.noteId = state.noteId
            
            return .run { send in
              await CreateNoteManager.shared.loadNoteImage()
              await send(.sheetDestination(.dismiss))
              await send(.delegate(.patchNote))
            }
          } else {
            return .none
          }
          
        case .remove:
          state.sheetDestination = nil
          state.sheetDestination = .noteRemoveSheet(.init(noteId: state.noteId))
          return .none
        }
        
      case let .sheetDestination(.presented(.noteRemoveSheet(.tappedYesButton(noteId)))):
        return .send(.tappedNoteDelete(noteId))
        
      case .sheetDestination(.presented(.noteRemoveSheet(.tappedNoButton))):
        state.sheetDestination = nil
        return .none
        
      case .tappedNoteDelete(let noteId):
        return .run { send in
          switch await noteService.deleteNote(noteId) {
          case .success:
            await send(.sheetDestination(.dismiss))
            await send(.tappedBackButton)
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        }
        
      default: return .none
      }
    }
  }
}
