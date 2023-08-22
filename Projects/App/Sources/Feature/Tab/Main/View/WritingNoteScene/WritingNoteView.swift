//
//  WritingNoteView.swift
//  Winey
//
//  Created by 정도현 on 2023/08/21.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct WritingNoteView: View {
  private let store: Store<WritingNoteState, WritingNoteAction>
  
  public init(store: Store<WritingNoteState, WritingNoteAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        Text("WritingNote View")
      }
    }
  }
}
