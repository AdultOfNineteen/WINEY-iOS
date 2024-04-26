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
  
  let columns = [GridItem(.flexible(), spacing: 15), GridItem(.flexible())]
  
  public var body: some View {
    // MARK: Note List
    VStack(spacing: 0) {
      if viewStore.noteCards.totalCnt > 0 {
        ScrollView {
          LazyVGrid(columns: columns, spacing: 24) {
            ForEach(viewStore.noteCards.contents, id: \.noteId) { note in
              noteCard(noteData: note)
                .onTapGesture {
                  viewStore.send(.tappedNoteCard(noteId: note.noteId, country: note.country))
                }
                .onAppear {
                  if viewStore.noteCards.contents[viewStore.noteCards.contents.count - 1] == note 
                      && !viewStore.noteCards.isLast {
                    viewStore.send(._fetchNextNotePage)
                  }
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

extension NoteCardScrollView {
  
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
          .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
      }
    }
  }
  
  @ViewBuilder
  private func noteEmptyView() -> some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 72)
      
      WineyAsset.Assets.emptyNoteIcon.swiftUIImage
      
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
    .foregroundColor(WineyKitAsset.gray800.swiftUIColor)
  }
}
