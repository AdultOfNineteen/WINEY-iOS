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
        
        Text("\(viewStore.wineCards.filter({ viewStore.userSearch.isEmpty ? true : $0.name.lowercased().contains(viewStore.userSearch.lowercased())}).count)개")
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
    if viewStore.wineCards.filter({
      viewStore.userSearch.isEmpty ?
      true : $0.name.lowercased().contains(viewStore.userSearch.lowercased()
      )}
    ).isEmpty {
      VStack {
        WineyAsset.Assets.noSearch.swiftUIImage
          .padding(.top, 151)
        
        VStack {
          Text("검색결과가 없어요!")
          Text("비슷한 와인명으로 입력해보세요")
        }
        .wineyFont(.headLine)
        .foregroundStyle(WineyKitAsset.gray800.swiftUIColor)
        
        Spacer()
      }
    } else {
      ScrollView {
        LazyVGrid(columns: columns, spacing: 20) {
          ForEach(viewStore.wineCards, id: \.id) { wine in
            wineCard(wineData: wine)
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
  }
  
  @ViewBuilder
  private func wineCard(wineData: WineCardData) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      VStack(spacing: -10) {
        HStack(spacing: 3) {
          Text(wineData.wineType.typeName)
            .wineyFont(.cardTitle)
          
          WineyAsset.Assets.star1.swiftUIImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 13)
            .offset(y: -2)
          
          Spacer()
        }
        .padding(.leading, 19)
        .padding(.top, 14)
        
        wineData.wineType.illustImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding(.bottom, 4)
      }
      .frame(width: UIScreen.main.bounds.width / 2 - 24 - 15, height: 163)
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(Color(red: 63/255, green: 63/255, blue: 63/255).opacity(0.4))
          .background(
            ZStack {
              Circle()
                .fill(
                  LinearGradient(
                    colors: [
                      wineData.wineType.backgroundColor.firstCircleStart,
                      wineData.wineType.backgroundColor.firstCircleEnd.opacity(0.25)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                  )
                )
                .frame(height: 70)
                .padding(.trailing, 55)
                .padding(.bottom, 70)
                .blur(radius: 10)
              
              RadialGradient(
                colors: [
                  wineData.wineType.backgroundColor.secondCircle,
                  .clear
                ],
                center: .center,
                startRadius: 5,
                endRadius: 75
              )
              .padding(.leading, 30)
              .padding(.top, 40)
            }
          )
          .blur(radius: 5)
          .overlay(
            RoundedRectangle(cornerRadius: 10)
              .stroke(
                LinearGradient(
                  colors: [
                    Color(red: 150/255, green: 113/255, blue: 1),
                    Color(red: 150/255, green: 113/255, blue: 1).opacity(0.2)
                  ],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                ),
                style: .init(lineWidth: 1)
              )
          )
      )
      
      VStack(alignment: .leading, spacing: 4) {
        Text(wineData.name)
          .wineyFont(.captionB1)
          .foregroundStyle(WineyKitAsset.gray50.swiftUIColor)
        Text("\(wineData.country) / \(wineData.wineType.korName)")
          .wineyFont(.captionM2)
          .foregroundStyle(WineyKitAsset.gray700.swiftUIColor)
      }
      .padding(.top, 10)
    }
  }
}

#Preview {
  WineSearchView(
    store: Store(
      initialState: WineSearch.State.init(),
      reducer: {
        WineSearch()
      }
    )
  )
}
