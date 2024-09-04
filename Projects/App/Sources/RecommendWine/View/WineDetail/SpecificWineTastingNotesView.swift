//
//  RecommendWineTastingNotesListView.swift
//  Winey
//
//  Created by 박혜운 on 9/3/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct SpecificWineTastingNotesView: View {
  private let store: StoreOf<SpecificWineTastingNotes>
  @ObservedObject var viewStore: ViewStoreOf<SpecificWineTastingNotes>
  
  public init(store: StoreOf<SpecificWineTastingNotes>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Text("\(viewStore.tastingNoteData.totalCnt)개")
          .foregroundStyle(WineyKitAsset.main3.swiftUIColor)
        Text("의 테이스팅 노트가 있어요!")
          .foregroundStyle(.white)
      }
      .wineyFont(.title2)
      .frame(
        maxWidth: .infinity,
        alignment: .leading
      )
      .padding(.bottom, 20)
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      VStack(spacing: 0) {
        LazyVStack(spacing: 0) {
          ForEach(viewStore.tastingNoteData.contents, id: \.noteId) { tastingNote in
            Button(
              action: {
                viewStore.send(.tappedTastingNoteCell(noteId: tastingNote.noteId))
              }, label: {
                tastingNotesListCell(content: tastingNote)
              }
            )
          }
        }
        .padding(.bottom, 20)
        .padding(.leading, WineyGridRules.globalHorizontalPadding)
        .padding(.trailing, 17)
        
        Button(
          action: {
            viewStore.send(.tappedMoreTastingNote)
          },
          label: {
            HStack(spacing: 0) {
              Text("더 보러가기")
                .wineyFont(.bodyM2)
                .foregroundStyle(WineyKitAsset.gray400.swiftUIColor)
              
              WineyAsset.Assets.icArrowRight.swiftUIImage
            }
          }
        )
      }
      .navigationDestination(for: OtherTastingNoteNavigationDestination.self) { destination in
        switch destination {
        case .allTastingNotesList:
          allTastingNotesView
          
        case .tastingNoteDetail:
          IfLetStore(
            self.store.scope(
              state: \.noteDetail,
              action: SpecificWineTastingNotes.Action.noteDetail
            ),
            then: NoteDetailView.init
          )
        }
      }
    }
    .task {
      viewStore.send(._viewWillAppear)
    }
  }
  
  var allTastingNotesView: some View {
    ScrollView {
      NavigationBar(
        title: "테이스팅 노트 모음",
        leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
        leftIconButtonAction: {
          viewStore.send(.pathChanged(.init()))
        },
        backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
      )
      LazyVStack(spacing: 0) {
        ForEach(viewStore.tastingNoteData.contents, id: \.noteId) { tastingNote in
          Button(
            action: {
              viewStore.send(.tappedTastingNoteCell(noteId: tastingNote.noteId))
            }, label: {
              tastingNotesListCell(content: tastingNote)
                .padding(.leading, WineyGridRules.globalHorizontalPadding)
                .padding(.trailing, 17)
            }
          )
        }
      }
      Spacer()
    }
    .navigationBarHidden(true)
    .background(WineyKitAsset.mainBackground.swiftUIColor)
  }
  
  func tastingNotesListCell(content: NoteContent) -> some View {
    HStack {
      VStack(alignment: .leading, spacing: 3) {
        Text(content.userNickname)
          .wineyFont(.bodyB1)
          .foregroundStyle(WineyKitAsset.gray50.swiftUIColor)
        Text(content.noteDate.replacingHyphensWithDots())
          .wineyFont(.captionM2)
          .foregroundStyle(WineyKitAsset.gray700.swiftUIColor)
      }
      Spacer()
      Text("\(content.starRating) / \(content.buyAgain ? "재구매" : "재구매X")")
        .wineyFont(.bodyM1)
        .foregroundStyle(WineyKitAsset.gray400.swiftUIColor)
      
      WineyAsset.Assets.icArrowRight.swiftUIImage
    }
    .frame(height: 48)
  }
  
}

private extension String {
  func replacingHyphensWithDots() -> String {
    return self.replacingOccurrences(of: "-", with: ".")
  }
}

#Preview {
  SpecificWineTastingNotesView(
    store: .init(
      initialState: .init(wineId: 0),
      reducer: {SpecificWineTastingNotes()})
  )
}
