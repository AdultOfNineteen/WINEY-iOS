//
//  OtherNoteView.swift
//  WINEY
//
//  Created by 정도현 on 10/5/24.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct OtherNoteView: View {
  @Bindable var store: StoreOf<OtherNote>
  
  public init(store: StoreOf<OtherNote>) {
    self.store = store
  }
  
  public var body: some View {
    HStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 0) {
        Text(store.noteData.userNickname)
          .wineyFont(.bodyB1)
          .foregroundStyle(.white)
        
        Text(store.noteData.noteDate)
          .wineyFont(.captionM2)
          .foregroundStyle(.wineyGray700)
      }
      .padding(.vertical, 3)
      
      Spacer()
      
      HStack(spacing: 0) {
        Text("\(store.noteData.starRating.description) / \(store.noteData.buyAgain ? "재구매" : "재구매X")")
          .wineyFont(.bodyM1)
          .foregroundStyle(.white)
        
        Image(.ic_arrow_rightW)
          .padding(12)
      }
    }
    .frame(height: 48)
    .background(.wineyMainBackground)
    .onTapGesture {
      store.send(.tappedCard)
    }
  }
}

#Preview {
  OtherNoteView(
    store: Store(
      initialState: OtherNote.State.init(
        noteData: NoteContent(
          noteId: 1,
          tastingNoteNo: 1,
          wineName: "test",
          country: "test",
          varietal: "test",
          starRating: 2,
          buyAgain: false,
          wineType: "test",
          userNickname: "테스터",
          noteDate: "test",
          public: false
        ), isMine: false
      ),
      reducer: {
        OtherNote()
      }
    )
  )
}
