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
      selectedFilter()
      
      Divider()
        .overlay(WineyKitAsset.gray900.swiftUIColor)
        .padding(.vertical, 20)
      
      filterContent()
      
      
      Divider()
        .overlay(WineyKitAsset.gray900.swiftUIColor)
        .padding(.vertical, 20)
      
      bottomArea()
    }
    .navigationBarHidden(true)
    .background(
      WineyKitAsset.background1.swiftUIColor
    )
  }
}

extension FilterListView {
  private var shouldShowInitButton: Bool {
    !viewStore.filterList.filter({ $0.filterInfo.isSelected }).isEmpty
  }
  
  private var wineTypeFilters: [NoteFilter.State] {
    viewStore.filterList.filter { $0.id >= 1 && $0.id < 7 }
  }
  
  private var wineCountryFilters: [NoteFilter.State] {
    viewStore.filterList.filter({ $0.id >= 7 })
  }
}


extension FilterListView {

  @ViewBuilder
  private func selectedFilter() -> some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 5) {
        if viewStore.filterList[0].filterInfo.isSelected {
          NoteFilterDisplayView(
            store: store.scope(
              state: \.filterList[0],
              action: { .noteFilter(id: 0, action: $0) })
          )
        }
        
        ForEach(wineTypeFilters.filter { $0.filterInfo.isSelected }, id: \.self) { filter in
          NoteFilterDisplayView(
            store: self.store.scope(
              state: \.filterList[filter.id],
              action: { childAction in .noteFilter(id: filter.id, action: .tappedFilter) }
            )
          )
        }
        
        ForEach(wineCountryFilters.filter { $0.filterInfo.isSelected }, id: \.self) { filter in
          NoteFilterDisplayView(
            store: self.store.scope(
              state: \.filterList[filter.id],
              action: { childAction in .noteFilter(id: filter.id, action: .tappedFilter) }
            )
          )
        }
      }
      .padding(.leading, WineyGridRules.globalHorizontalPadding)
    }
    .padding(.top, 3)
    .frame(height: 40)
  }
  
  @ViewBuilder
  private func filterContent() -> some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 28) {
        VStack(alignment: .leading, spacing: 14) {
          Text("재구매")
            .wineyFont(.bodyB1)
          
          NoteFilterView(
            store: store.scope(
              state: \.filterList[0],
              action: { .noteFilter(id: 0, action: $0) })
          )
        }
        
        // MARK: 와인 종류
        VStack(alignment: .leading, spacing: 14) {
          Text("와인종류")
            .wineyFont(.bodyB1)
          
          LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 70, maximum: .infinity), spacing: 0)
          ], spacing: 10) {
            ForEach(wineTypeFilters) { filter in
              NoteFilterView(
                store: store.scope(
                  state: \.filterList[filter.id],
                  action: { .noteFilter(id: filter.id, action: $0) })
              )
            }
          }
        }
        
        // MARK: 생산지
        VStack(alignment: .leading, spacing: 14) {
          Text("생산지")
            .wineyFont(.bodyB1)
          
          LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 70, maximum: .infinity), spacing: 0)
          ], spacing: 10) {
            ForEach(wineCountryFilters) { filter in
              NoteFilterView(
                store: store.scope(
                  state: \.filterList[filter.id],
                  action: { .noteFilter(id: filter.id, action: $0) })
              )
            }
          }
        }
      }
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    }
  }
  
  @ViewBuilder
  private func bottomArea() -> some View {
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
}
