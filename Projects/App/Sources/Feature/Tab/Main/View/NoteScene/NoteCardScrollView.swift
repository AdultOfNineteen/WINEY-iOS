//
//  NoteCardScrollView.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct NoteCardScrollView: View {
  private let store: StoreOf<NoteCardScroll>
  @ObservedObject var viewStore: ViewStoreOf<NoteCardScroll>
  
  public init(store: StoreOf<NoteCardScroll>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  let columns = [GridItem(.flexible()), GridItem(.flexible())]
  
  public var body: some View {
    // MARK: Note List
    VStack(spacing: 0) {
      
      ScrollView {
        LazyVGrid(columns: columns, spacing: 20) {
          ForEach(viewStore.noteCards.indices, id: \.self) { index in
            NoteCardView(
              store: self.store.scope(
                state: \.noteCards[index],
                action: { .noteCard(id: index, action: $0) }
              )
            )
          }
        }
        .padding(.top, 2)
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
    }
  }
}
