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
  @FocusState var focusedField: Bool
  
  private let store: StoreOf<WineSearch>
  @ObservedObject var viewStore: ViewStoreOf<WineSearch>
  
  public init(store: StoreOf<WineSearch>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  let columns = [GridItem(.flexible()), GridItem(.flexible())]
  
  public var body: some View {
    VStack(spacing: 0) {
      topNavigation()
      
      countingSearch()
      
      noteCards()
    }
    .onAppear {
      viewStore.send(._viewWillAppear)
    }
    .background(WineyKitAsset.mainBackground.swiftUIColor)
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
        leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
        leftIconButtonAction: {
          viewStore.send(.tappedBackButton)
        },
        backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
      )
      
      HStack {
        TextField(
          "기록할 와인을 검색해주세요!",
          text: viewStore.binding(
            get: \.userSearch,
            send: WineSearch.Action._settingSearchString
          )
        )
        .tint(WineyKitAsset.main2.swiftUIColor)
        .frame(height: 44)
        .focused($focusedField)
        
        Spacer()
        
        WineyAsset.Assets.icSearch.swiftUIImage
      }
      .wineyFont(.bodyM1)
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 18)
      .background(
        Capsule()
          .foregroundStyle(WineyKitAsset.gray900.swiftUIColor)
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
          .foregroundStyle(WineyKitAsset.gray400.swiftUIColor)
        
        Text("\(viewStore.wineCards?.totalCnt ?? 0)개")
          .wineyFont(.bodyB1)
          .foregroundStyle(WineyKitAsset.main3.swiftUIColor)
      }
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      .padding(.bottom, 20)
      
      Divider()
        .frame(height: 0.8)
        .overlay(WineyKitAsset.gray900.swiftUIColor)
    }
    .padding(.top, 8)
  }
  
  @ViewBuilder
  private func noteCards() -> some View {
    if let wineCards = viewStore.wineCards {
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
                viewStore.send(._fetchNextWinePage)
              }
            }
            .onTapGesture {
              viewStore.send(.tappedWineCard(wine))
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
      WineyAsset.Assets.noSearch.swiftUIImage
        .padding(.top, 151)

      VStack(spacing: 2) {
        Text("검색결과가 없어요!")
        Text("비슷한 와인명으로 입력해보세요")
      }
      .wineyFont(.headLine)
      .foregroundStyle(WineyKitAsset.gray800.swiftUIColor)

      Spacer()
    }
  }
  
  @ViewBuilder
  private func wineCard(wineData: WineSearchContent) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      SmallWineCard(
        wineType: WineType.changeType(at: wineData.type),
        borderColor: Color(red: 150/255, green: 113/255, blue: 1)
      )
      
      VStack(alignment: .leading, spacing: 4) {
        Text(wineData.name)
          .wineyFont(.captionB1)
          .foregroundStyle(WineyKitAsset.gray50.swiftUIColor)
          .lineLimit(1)
        Text("\(wineData.country) / \(WineType.changeType(at: wineData.type).korName)")
          .wineyFont(.captionM2)
          .foregroundStyle(WineyKitAsset.gray700.swiftUIColor)
          .lineLimit(1)
      }
      .padding(.top, 10)
    }
  }
}
