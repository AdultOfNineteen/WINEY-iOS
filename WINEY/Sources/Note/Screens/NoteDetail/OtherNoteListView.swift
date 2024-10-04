//
//  OtherNoteListView.swift
//  WINEY
//
//  Created by 정도현 on 10/5/24.
//


import ComposableArchitecture
import SwiftUI
import WineyKit

public struct OtherNoteListView: View {
  @Bindable var store: StoreOf<OtherNoteList>
  
  public init(store: StoreOf<OtherNoteList>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "테이스팅 노트 모음",
        leftIcon: Image(.navigationBack_buttonW),
        leftIconButtonAction: {
          store.send(.tappedBackButton)
        },
        backgroundColor: Color.wineyMainBackground
      )
      
      VStack(alignment: .leading, spacing: 20) {
        Text("Other Notes")
          .wineyFont(.display2)
          .foregroundStyle(.white)
        
        HStack(spacing: 0) {
          Text("\(store.totalCnt)개")
            .foregroundStyle(.wineyMain3)
          
          Text("의 테이스팅 노트가 있어요!")
            .foregroundStyle(.white)
          
          Spacer()
        }
        .wineyFont(.title2)
      }
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      
      Group {
        if store.totalCnt > 0 {
          ScrollView(.vertical) {
            LazyVStack(spacing: 5) {
              ForEachStore(
                store.scope(state: \.otherNotes, action: \.otherNote)
              ) { store in
                OtherNoteView(store: store)
                  .onAppear {
                    self.store.send(._checkPagination(data: store.noteData))
                  }
              }
            }
            .padding(.leading, 24)
            .padding(.trailing, 5)
            .padding(.top, 20)
          }
        } else {
          VStack(spacing: 13) {
            Image(.emptyNoteIconW)
            
            VStack(spacing: 6) {
              Text("등록된 노트가 없어요 :(")
                .wineyFont(.headLine)
              
              Text("이 와인의 첫 와이너가 되어보세요!")
                .wineyFont(.bodyM2)
            }
            .foregroundStyle(.wineyGray800)
            .padding(.top, 13)
          }
        }
      }
      .padding(.bottom, 80)
      .frame(maxHeight: .infinity)
    }
    .task {
      store.send(._viewWillAppear)
    }
    .background(.wineyMainBackground)
    .navigationBarBackButtonHidden()
  }
}

