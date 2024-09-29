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
  
  public init(store: StoreOf<SpecificWineTastingNotes>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Text("\( store.tastingNoteData.totalCnt)개")
          .foregroundStyle(.wineyMain3)
        
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
          ForEach( store.tastingNoteData.contents, id: \.noteId) { tastingNote in
            Button(
              action: {
                 store.send(.tappedTastingNoteCell(noteId: tastingNote.noteId))
              }, label: {
                tastingNotesListCell(content: tastingNote)
              }
            )
          }
        }
        .padding(.bottom, 20)
        .padding(.leading, WineyGridRules.globalHorizontalPadding)
        .padding(.trailing, 17)
        
        if  store.tastingNoteData.totalCnt > 5 {
          Button(
            action: {
               store.send(.tappedMoreTastingNote)
            },
            label: {
              HStack(spacing: 0) {
                Text("더 보러가기")
                  .wineyFont(.bodyM2)
                  .foregroundStyle(.wineyGray400)
                
                Image(.ic_arrow_rightW)
              }
            }
          )
        }
      }
//      .navigationDestination(for: OtherTastingNoteNavigationDestination.self) { destination in
//        switch destination {
//        case .allTastingNotesList:
//          allTastingNotesView
//          
//        case .tastingNoteDetail:
//          IfLetStore(
//            self.store.scope(
//              state: \.noteDetail,
//              action: SpecificWineTastingNotes.Action.noteDetail
//            ),
//            then: NoteDetailView.init
//          )
//        }
//      }
    }
    .task {
       store.send(._viewWillAppear)
    }
  }
  
  var allTastingNotesView: some View {
    ScrollView {
      NavigationBar(
        title: "테이스팅 노트 모음",
        leftIcon: Image(.navigationBack_buttonW),
        leftIconButtonAction: {
           store.send(.pathChanged(.init()))
        },
        backgroundColor: .wineyMainBackground
      )
      LazyVStack(spacing: 0) {
        ForEach( store.tastingNoteData.contents, id: \.noteId) { tastingNote in
          Button(
            action: {
               store.send(.tappedTastingNoteCell(noteId: tastingNote.noteId))
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
    .background(.wineyMainBackground)
  }
  
  func tastingNotesListCell(content: NoteContent) -> some View {
    HStack {
      VStack(alignment: .leading, spacing: 3) {
        Text(content.userNickname)
          .wineyFont(.bodyB1)
          .foregroundStyle(.wineyGray50)
        Text(content.noteDate.replacingHyphensWithDots())
          .wineyFont(.captionM2)
          .foregroundStyle(.wineyGray700)
      }
      Spacer()
      Text("\(content.starRating) / \(content.buyAgain ? "재구매" : "재구매X")")
        .wineyFont(.bodyM1)
        .foregroundStyle(.wineyGray400)
      
      Image(.ic_arrow_rightW)
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
