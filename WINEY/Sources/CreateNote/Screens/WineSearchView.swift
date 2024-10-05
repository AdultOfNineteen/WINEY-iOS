//
//  WineSearchView.swift
//  Winey
//
//  Created by 정도현 on 11/7/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WineSearchView: View {
  private let store: StoreOf<WineSearch>
  
  @FocusState var focusedField: Bool
  
  public init(store: StoreOf<WineSearch>) {
    self.store = store
  }
  
  let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible())]
  
  public var body: some View {
    VStack(spacing: 0) {
      topNavigation()
      
      countingSearch()
      
      noteCards()
    }
    .onAppear {
      store.send(._viewWillAppear)
    }
    .background(.wineyMainBackground)
    .onTapGesture {
      focusedField = false
    }
    .navigationBarHidden(true)
  }
}

extension WineSearchView {
  
  @ViewBuilder
  private func topNavigation() -> some View {
    ZStack {
      NavigationBar(
        leftIcon:
          Image(.navigationBack_buttonW),
        leftIconButtonAction: {
          store.send(.tappedBackButton)
        },
        backgroundColor: .wineyMainBackground
      )
      
      HStack {
        TextField(
          "기록할 와인을 검색해주세요!",
          text: .init(
            get: { store.userSearch },
            set: { set in  store.send(._settingSearchString(set)) }
          )
        )
        .tint(.wineyMain2)
        .frame(height: 44)
        .focused($focusedField)
        
        Spacer()
        
        Image(.ic_searchW)
      }
      .wineyFont(.bodyM1)
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 18)
      .background(
        Capsule()
          .foregroundStyle(.wineyGray900)
      )
      .onTapGesture {
        focusedField = true
      }
      .padding(.leading, 53)
      .padding(.trailing, 24)
    }
  }
  
  @ViewBuilder
  private func countingSearch() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 4) {
        Text("검색 결과")
          .wineyFont(.bodyM1)
          .foregroundStyle(.wineyGray400)
        
        Text("\(store.userSearch.isEmpty ? 0 : store.totalCnt)개")
          .wineyFont(.bodyB1)
          .foregroundStyle(.wineyMain3)
      }
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      .padding(.bottom, 20)
      
      Divider()
        .frame(height: 0.8)
        .overlay(.wineyGray900)
    }
    .padding(.top, 8)
  }
  
  @ViewBuilder
  private func noteCards() -> some View {
    if store.userSearch.isEmpty || store.searchCard.isEmpty {
      emptyCardView()
    } else {
      ScrollView(.vertical) {
        LazyVStack(spacing: 0) {
          ForEachStore(
            store.scope(state: \.searchCard, action: \.searchCard)
          ) { store in
            WineSearchCardView(store: store)
              .onAppear {
                self.store.send(._checkPagination(data: store.data))
              }
          }
        }
      }
    }
  }
  
  @ViewBuilder 
  private func emptyCardView() -> some View {
    VStack(spacing: 0) {
      Image(.noSearchW)
        .padding(.top, 151)

      VStack(spacing: 2) {
        Text("검색결과가 없어요!")
        Text("비슷한 와인명으로 입력해보세요")
      }
      .wineyFont(.headLine)
      .foregroundStyle(.wineyGray800)

      Spacer()
    }
  }
}
