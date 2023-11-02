//
//  FilterListView.swift
//  Winey
//
//  Created by 정도현 on 10/23/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct FilterListView: View {
  private let store: StoreOf<FilterList>
  @ObservedObject var viewStore: ViewStoreOf<FilterList>
  
  public init(store: StoreOf<FilterList>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "필터",
        leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
        leftIconButtonAction: {
          viewStore.send(.tappedBackButton)
        },
        backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
      )
      
      // MARK: 최상단 필터
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 5) {
          ForEach(viewStore.wineTypeFilter.filter { $0.filterInfo.isSelected }, id: \.self) { filter in
            NoteFilterDisplayView(
              store: self.store.scope(
                state: \.wineTypeFilter[filter.id],
                action: { .noteFilter(id: filter.id, action: $0) }
              )
            )
          }
          
          ForEach(viewStore.wineCountryFilter.filter { $0.filterInfo.isSelected }, id: \.self) { filter in
            NoteFilterDisplayView(
              store: self.store.scope(
                state: \.wineCountryFilter[filter.id],
                action: { .noteFilter(id: filter.id, action: $0) }
              )
            )
          }
        }
        .padding(.leading, WineyGridRules.globalHorizontalPadding)
      }
      .padding(.top, 3)
      .frame(height: 40)
      
      Divider()
        .overlay(WineyKitAsset.gray900.swiftUIColor)
        .padding(.vertical, 20)
      
      
      ScrollView {
        VStack(alignment: .leading, spacing: 28) {
          VStack(alignment: .leading, spacing: 14) {
            Text("재구매")
              .wineyFont(.bodyB1)
          }
          
          // MARK: 와인 종류
          VStack(alignment: .leading, spacing: 14) {
            Text("와인종류")
              .wineyFont(.bodyB1)
            
            LazyVGrid(columns: [
              GridItem(.adaptive(minimum: 70, maximum: .infinity), spacing: 0)
            ], spacing: 10) {
              ForEachStore(
                self.store.scope(
                  state: \.wineTypeFilter,
                  action: { .noteFilter(id: $0, action: $1) }
                )
              ) {
                NoteFilterView(store: $0)
              }
            }
            
            //            LazyVGrid(columns: [
            //              GridItem(.adaptive(minimum: 50, maximum: .infinity)),
            //              GridItem(.adaptive(minimum: 54, maximum: .infinity)),
            //              GridItem(.adaptive(minimum: 50, maximum: .infinity))
            //            ], spacing: 10) {
            //              ForEachStore(
            //                self.store.scope(
            //                  state: \.wineTypeFilter,
            //                  action: { .noteFilter(id: $0, action: $1) }
            //                )
            //              ) {
            //                NoteFilterView(store: $0)
            //                  .border(.red)
            //              }
            //            }
            
            //            LazyHGrid(rows: [GridItem(.adaptive(minimum: 12, maximum: .infinity))]) {
            //              ForEachStore(
            //                self.store.scope(
            //                  state: \.wineTypeFilter,
            //                  action: { .noteFilter(id: $0, action: $1) }
            //                )
            //              ) {
            //                NoteFilterView(store: $0)
            //                  .border(.red)
            //              }
            //            }
          }
          
          // MARK: 생산지
          VStack(alignment: .leading, spacing: 14) {
            Text("생산지")
              .wineyFont(.bodyB1)
            
            LazyVGrid(columns: [
              GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 0)
            ], spacing: 10) {
              ForEachStore(
                self.store.scope(
                  state: \.wineCountryFilter,
                  action: { .noteFilter(id: $0, action: $1) }
                )
              ) {
                NoteFilterView(store: $0)
              }
            }
          }
        }
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
      
      Divider()
        .overlay(WineyKitAsset.gray900.swiftUIColor)
        .padding(.vertical, 20)
      
      HStack(spacing: 20) {
        Button(action: {
          viewStore.send(.tappedInitButton)
        }, label: {
          HStack(spacing: 2) {
            WineyAsset.Assets.reloadIcon.swiftUIImage
            
            Text("필터 초기화")
              .foregroundStyle(.white)
          }
          .foregroundColor(WineyKitAsset.gray100.swiftUIColor)
          .wineyFont(.bodyB2)
        })
        
        WineyConfirmButton(
          title: "개 옵션 적용하기",
          validBy: true,
          action: {
            viewStore.send(.tappedAdaptButton)
          }
        )
      }
      .padding(.vertical, 20)
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      .background(WineyKitAsset.gray950.swiftUIColor)
    }
    .navigationBarHidden(true)
    .background(
      WineyKitAsset.background1.swiftUIColor
    )
  }
}

#Preview {
  FilterListView(
    store: Store(
      initialState: FilterList.State(
        wineTypeFilter: [
          NoteFilter.State(id: 0, filterInfo: FilterInfo(title: WineType.red.korName, isSelected: false, count: 0)),
          NoteFilter.State(id: 1, filterInfo: FilterInfo(title: WineType.white.korName, isSelected: false, count: 2)),
          NoteFilter.State(id: 2, filterInfo: FilterInfo(title: WineType.rose.korName, isSelected: false, count: 13)),
          NoteFilter.State(id: 3, filterInfo: FilterInfo(title: WineType.sparkl.korName, isSelected: false, count: 2)),
          NoteFilter.State(id: 4, filterInfo: FilterInfo(title: WineType.port.korName, isSelected: false, count: 13)),
          NoteFilter.State(id: 5, filterInfo: FilterInfo(title: WineType.etc.korName, isSelected: false, count: 2))
        ], wineCountryFilter: [
          NoteFilter.State(id: 6, filterInfo: FilterInfo(title: WineCountry.italy.rawValue, isSelected: false, count: 2)),
          NoteFilter.State(id: 7, filterInfo: FilterInfo(title: WineCountry.france.rawValue, isSelected: false, count: 103)),
          NoteFilter.State(id: 8, filterInfo: FilterInfo(title: WineCountry.chile.rawValue, isSelected: false, count: 2)),
          NoteFilter.State(id: 9, filterInfo: FilterInfo(title: WineCountry.america.rawValue, isSelected: false, count: 10)),
          NoteFilter.State(id: 10, filterInfo: FilterInfo(title: WineCountry.spain.rawValue, isSelected: false, count: 12)),
          NoteFilter.State(id: 11, filterInfo: FilterInfo(title: WineCountry.germany.rawValue, isSelected: false, count: 42)),
          NoteFilter.State(id: 12, filterInfo: FilterInfo(title: WineCountry.greece.rawValue, isSelected: false, count: 12)),
          NoteFilter.State(id: 13, filterInfo: FilterInfo(title: WineCountry.australia.rawValue, isSelected: false, count: 12)),
          NoteFilter.State(id: 14, filterInfo: FilterInfo(title: WineCountry.southAfrica.rawValue, isSelected: false, count: 2)),
          NoteFilter.State(id: 15, filterInfo: FilterInfo(title: WineCountry.newZealand.rawValue, isSelected: false, count: 103)),
          NoteFilter.State(id: 16, filterInfo: FilterInfo(title: WineCountry.portugal.rawValue, isSelected: false, count: 103))
        ]),
      reducer: {
        FilterList()
      }
    )
  )
}
