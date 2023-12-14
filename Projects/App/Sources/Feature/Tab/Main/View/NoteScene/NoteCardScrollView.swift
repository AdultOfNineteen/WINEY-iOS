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
          ForEach(viewStore.noteCards, id: \.id) { note in
            noteCard(noteCard: note)
              .onTapGesture {
                viewStore.send(.tappedNoteCard(note))
              }
          }
        }
        .padding(.top, 2)
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
    }
  }
}

extension NoteCardScrollView {
  
  @ViewBuilder
  private func noteCard(noteCard: NoteCardData) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      SmallWineCard(
        wineData: WineCardData(
          id: noteCard.id,
          wineType: noteCard.wineType,
          name: noteCard.wineName,
          country: noteCard.region,
          varietal: noteCard.varietal,
          sweetness: Int(noteCard.myWineTaste.sweetness) ?? 0,  // 데이터 추후 수정
          acidity: Int(noteCard.myWineTaste.acidity) ?? 0,
          body: Int(noteCard.myWineTaste.body) ?? 0,
          tannins: Int(noteCard.myWineTaste.tannin) ?? 0,
          wineSummary: WineSummary(avgPrice: 0, avgSweetness: 0, avgAcidity: 0, avgBody: 0, avgTannins: 0)
        ),
        borderColor: Color(red: 150/255, green: 113/255, blue: 1)
      )
      
      VStack(alignment: .leading, spacing: 2) {
        Text(noteCard.wineName)
          .lineLimit(1)
          .wineyFont(.captionB1)
        
        Text("\(noteCard.region) / \(noteCard.star.description)점")
          .wineyFont(.captionM2)
          .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
      }
      .padding(.top, 10)
    }
  }
}
