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
  private let store: Store<NoteCoordinatorState, NoteCoordinatorAction>
  
  public init(store: Store<NoteCoordinatorState, NoteCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) {
        CaseLet(
          state: /NoteScreenState.note,
          action: NoteScreenAction.note,
          then: NoteView.init
        )
      }
    }
  }
}
