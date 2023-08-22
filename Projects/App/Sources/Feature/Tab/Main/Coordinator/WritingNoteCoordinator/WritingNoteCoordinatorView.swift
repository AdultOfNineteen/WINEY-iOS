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

public struct WritingNoteCoordinatorView: View {
  private let store: Store<WritingNoteCoordinatorState, WritingNoteCoordinatorAction>
  
  public init(store: Store<WritingNoteCoordinatorState, WritingNoteCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) {
        CaseLet(
          state: /WritingNoteScreenState.writingNote,
          action: WritingNoteScreenAction.writingNote,
          then: WritingNoteView.init
        )
      }
    }
  }
}
