//
//  WritingNoteView.swift
//  Winey
//
//  Created by 정도현 on 2023/08/21.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct NoteView: View {
  private let store: StoreOf<Note>
  @ObservedObject var viewStore: ViewStoreOf<Note>
  
  public init(store: StoreOf<Note>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      // MARK: HEADER
      HStack {
        Text("WINEY")
          .wineyFont(.display2)
          .foregroundColor(WineyKitAsset.gray400.swiftUIColor)
        
        Spacer()
        
        RoundedRectangle(cornerRadius: 45)
          .fill(WineyKitAsset.main2.swiftUIColor)
          .frame(width: 95, height: 33)
          .shadow(color: WineyKitAsset.main2.swiftUIColor, radius: 7)
          .overlay(
            MainAnalysisButton(
              title: "분석하기", icon: WineyKitAsset.analysisIcon.swiftUIImage,
              action: {
                viewStore.send(.tappedAnalysisButton)
              }
            )
          )
      }
      .padding(.top, 17)
      .padding(.bottom, 10)
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    
      Spacer()
        .frame(height: 10)
      
      HStack(spacing: 0) {
        Text("\(viewStore.noteCardList.noteCards.count)개")
          .foregroundColor(WineyKitAsset.main3.swiftUIColor)
        Text("의 노트를 작성했어요!")
          .foregroundColor(.white)
      }
      .wineyFont(.headLine)
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      
      Spacer()
        .frame(height: 14)
      
      Divider()
        .overlay(WineyKitAsset.gray900.swiftUIColor)
      
      // MARK: Filter
      NoteFilterScrollView(
        store: self.store.scope(
          state: \.noteFilterScroll,
          action: Note.Action.noteFilterScroll
        )
      )
      .frame(height: 65)
      
      Divider()
        .overlay(WineyKitAsset.gray900.swiftUIColor)
        .padding(.bottom, 16)
      
      if viewStore.noteCardList.noteCards.isEmpty {
        NoteEmptyView()
      } else {
        NoteCardScrollView(
          store: self.store.scope(
            state: \.noteCardList,
            action: Note.Action.noteCardScroll
          )
        )
      }
      
      Spacer()
    }
    .background(WineyKitAsset.mainBackground.swiftUIColor)
    .onAppear(
      
    )
  }
}

struct NoteView_Previews: PreviewProvider {
  static var previews: some View {
    NoteView(store: Store(initialState: Note.State.init(), reducer: {
      Note()
    }))
  }
}
