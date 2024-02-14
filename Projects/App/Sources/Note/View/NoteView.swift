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
    ZStack {
      VStack(alignment: .leading, spacing: 0) {
        header()
        
        filteredNote()
      }
      
      VStack {
        Spacer()
        
        HStack {
          Spacer()
          
          Button(action: {
            viewStore.send(.tappedNoteWriteButton)
          }, label: {
            WineyAsset.Assets.pencilIcon.swiftUIImage
              .background(
                Circle()
                  .fill(WineyKitAsset.main2.swiftUIColor)
                  .frame(width: 60, height: 60)
              )
          })
          .padding(.trailing, 44)
        }
        .padding(.bottom, 120)
      }
    }
    .background(WineyKitAsset.mainBackground.swiftUIColor)
  }
}

extension NoteView {
  
  // MARK: Header
  @ViewBuilder
  private func header() -> some View {
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
  }
  
  // MARK: Note counter
  @ViewBuilder
  private func noteCounter() -> some View {
    HStack(spacing: 0) {
      Text("\(5)개")
        .foregroundColor(WineyKitAsset.main3.swiftUIColor)
      Text("의 노트를 작성했어요!")
        .foregroundColor(.white)
    }
    .wineyFont(.headLine)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .padding(.top, 10)
  }
  
  // MARK: Filter
  @ViewBuilder
  private func filteredNote() -> some View {
    FilteredNoteView(
      store: self.store.scope(
        state: \.filteredNote,
        action: Note.Action.filteredNote
      )
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
