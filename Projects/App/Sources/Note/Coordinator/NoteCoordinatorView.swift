//
//  WritingNoteCoordinatorView.swift
//  Winey
//
//  Created by 정도현 on 2023/08/22.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct NoteCoordinatorView: View {
  private let store: StoreOf<NoteCoordinator>
  
  public init(store: StoreOf<NoteCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .analysis:
          CaseLet(
            /NoteScreen.State.analysis,
            action: NoteScreen.Action.analysis,
            then: WineAnalysisCoordinatorView.init
          )
          
        case .note:
          CaseLet(
            /NoteScreen.State.note,
             action: NoteScreen.Action.note,
             then: NoteView.init
          )
          
        case .noteDetail:
          CaseLet(
            /NoteScreen.State.noteDetail,
             action: NoteScreen.Action.noteDetail,
             then: NoteDetailView.init
          )
          
        case .filterDetail:
          CaseLet(
            /NoteScreen.State.filterDetail,
             action: NoteScreen.Action.filterDetail,
             then: FilterDetailView.init
          )
          
        case .creatNote:
          CaseLet(
            /NoteScreen.State.creatNote,
             action: NoteScreen.Action.createNote,
             then: WritingNoteCoordinatorView.init
          )
        }
      }
    }
  }
}
