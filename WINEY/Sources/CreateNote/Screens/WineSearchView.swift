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
        
        Text("\(store.wineCards?.totalCnt ?? 0)개")
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
    if let wineCards = store.wineCards {
      if wineCards.totalCnt > 0 {
        wineCardList(wineCards: wineCards)
      } else {
        noCardView()
      }
    } else {
      noCardView()
    }
  }
  
  @ViewBuilder
  private func wineCardList(wineCards: WineSearchDTO) -> some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(wineCards.contents, id: \.wineId) { wine in
          wineCard(wineData: wine)
            .onAppear {
              // Pagination
              if wineCards.contents[wineCards.contents.count - 1] == wine && !wineCards.isLast {
                store.send(._fetchNextWinePage)
              }
            }
            .onTapGesture {
              store.send(.tappedWineCard(wine))
            }
        }
      }
      .padding(.top, 1)
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    }
    .padding(.top, 26)
  }
  
  @ViewBuilder 
  private func noCardView() -> some View {
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
  
  @ViewBuilder
  private func wineCard(wineData: WineSearchContent) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      SmallWineCard(
        wineType: WineType.changeType(at: wineData.type)
      )
      
      VStack(alignment: .leading, spacing: 4) {
        Text(wineData.name)
          .wineyFont(.captionB1)
          .foregroundStyle(.wineyGray50)
          .lineLimit(1)
        Text("\(wineData.country) / \(WineType.changeType(at: wineData.type).korName)")
          .wineyFont(.captionM2)
          .foregroundStyle(.wineyGray700)
          .lineLimit(1)
      }
      .padding(.top, 10)
    }
  }
}
