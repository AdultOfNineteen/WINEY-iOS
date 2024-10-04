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
  @Bindable var store: StoreOf<Note>
  
  public init(store: StoreOf<Note>) { self.store = store }
  
  public var body: some View {
    content
      .navigationBarBackButtonHidden()
      .navigationDestination(
        item: $store.scope(state: \.destination?.detailFilter, action: \.destination.detailFilter),
        destination: { store in
          FilterDetailView(store: store)
        }
      )
      .background(.wineyMainBackground)
      .onAppear {
        store.send(._onAppear)
      }
  }
  
  @ViewBuilder
  var content: some View {
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
            store.send(.tappedNoteWriteButton)
          }, label: {
            Image(.pencilIconW)
              .background(
                Circle()
                  .fill(.wineyMain2)
                  .frame(width: 60, height: 60)
              )
          })
          .padding(.bottom, 114)
          .padding(.trailing, 44)
        }
      }
    }
  }
}

extension NoteView {
  
  // MARK: Header
  @ViewBuilder
  private func header() -> some View {
    HStack {
      Text("WINEY")
        .wineyFont(.display2)
        .foregroundColor(.wineyGray400)
      
      Spacer()
      
      RoundedRectangle(cornerRadius: 45)
        .fill(.wineyMain2)
        .frame(width: 95, height: 33)
        .shadow(color: .wineyMain2, radius: 7)
        .overlay(
          MainAnalysisButton(
            title: "분석하기", icon: Image(.analysis_iconW),
            action: {
              store.send(.tappedAnalysisButton)
            }
          )
        )
    }
    .padding(.top, 17)
    .padding(.bottom, 28)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  // MARK: Filter
  @ViewBuilder
  private func filteredNote() -> some View {
    FilteredNotesView(
      store: self.store.scope(
        state: \.filteredNote,
        action: \.filteredNote
      )
    )
  }
}


struct NoteView_Previews: PreviewProvider {
  static var previews: some View {
    NoteView(
      store: Store(
        initialState: Note.State.init(),
        reducer: {
          Note()
        }
      )
    )
  }
}
