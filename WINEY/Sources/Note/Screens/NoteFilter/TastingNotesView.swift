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

public struct TastingNotesView: View {
  private let store: StoreOf<TastingNotes>
  
  public init(store: StoreOf<TastingNotes>) {
    self.store = store
  }
  
  let columns = [GridItem(.flexible(), spacing: 15), GridItem(.flexible())]
  
  public var body: some View {
    // MARK: Note List
    VStack(spacing: 0) {
      if store.noteListInfo.totalCnt > 0 {
        ScrollView {
          LazyVGrid(columns: columns, spacing: 24) {
            ForEach(store.noteListInfo.contents, id: \.noteId) { note in
              noteCard(noteData: note)
                .onAppear {
                  if store.noteListInfo.contents[store.noteListInfo.contents.count - 1] == note
                      && !store.noteListInfo.isLast {
                    store.send(._fetchNextNotePage)
                  }
                }
                .onTapGesture {
                  store.send(.tappedNoteCard(noteId: note.noteId))
                }
            }
          }
          .padding(.top, 2)
          .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
          .padding(.bottom, 106)
        }
      } else {
        noteEmptyView()
      }
    }
  }
}

extension TastingNotesView {
  @ViewBuilder
  private func noteCard(noteData: NoteContent) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      SmallWineCard(
        wineType: WineType.changeType(at: noteData.wineType)
      )
      
      VStack(alignment: .leading, spacing: 4) {
        Text(noteData.wineName)
          .lineLimit(1)
          .wineyFont(.captionB1)
        
        Text("\(noteData.country) / \(noteData.starRating.description)점")
          .wineyFont(.captionM2)
          .foregroundColor(.wineyGray700)
      }
    }
  }
  
  @ViewBuilder
  private func noteEmptyView() -> some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 72)
      
      Image(.emptyNoteIconW)
      
      Spacer()
        .frame(height: 13)
      
      VStack(spacing: 2) {
        Text("아직 노트가 없어요!")
        Text("노트를 작성해주세요 :)")
      }
      
      Spacer()
    }
    .frame(maxWidth: .infinity)
    .wineyFont(.headLine)
    .foregroundColor(.wineyGray800)
  }
}

#Preview {
  TastingNotesView(
    store: .init(
      initialState: .init(noteCards: NoteDTO.mock ),
      reducer: { TastingNotes() }
    )
  )
}
