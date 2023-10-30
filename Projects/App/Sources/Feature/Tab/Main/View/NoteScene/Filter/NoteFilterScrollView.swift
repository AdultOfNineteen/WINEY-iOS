//
//  NoteFilterScrollView.swift
//  Winey
//
//  Created by 정도현 on 10/23/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct NoteFilterScrollView: View {
  private let store: StoreOf<NoteFilterScroll>
  @ObservedObject var viewStore: ViewStoreOf<NoteFilterScroll>
  
  public init(store: StoreOf<NoteFilterScroll>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    HStack {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 8) {
          // MARK: Init Button
          if !viewStore.selectedWineTypeFilter.filter({ $0.filterInfo.isSelected }).isEmpty && viewStore.selectedWineCountryFilter.filter({ $0.filterInfo.isSelected }).isEmpty {
            NoteFilterIndicatorView(title: "초기화") {
              viewStore.send(.tappedInitButton)
            }
          }
          
          // MARK: Wine Type
          if viewStore.selectedWineTypeFilter.filter({ $0.filterInfo.isSelected }).isEmpty {
            NoteFilterIndicatorView(title: "와인종류") {
              viewStore.send(.tappedFilterButton)
            }
          } else {
            ForEach(viewStore.selectedWineTypeFilter.filter { $0.filterInfo.isSelected }, id: \.self) { filter in
              HStack(spacing: 8) {
                NoteFilterDisplayView(
                  store: self.store.scope(
                    state: \.selectedWineTypeFilter[filter.id],
                    action: { .noteFilter(id: filter.id, action: $0) }
                  )
                )
              }
            }
          }
          
          // MARK: Wine Country
          if viewStore.selectedWineCountryFilter.filter({ $0.filterInfo.isSelected }).isEmpty {
            NoteFilterIndicatorView(title: "생산지") {
              viewStore.send(.tappedFilterButton)
            }
          } else {
            ForEach(viewStore.selectedWineCountryFilter.filter { $0.filterInfo.isSelected }, id: \.self) { filter in
              HStack(spacing: 8) {
                NoteFilterDisplayView(
                  store: self.store.scope(
                    state: \.selectedWineCountryFilter[filter.id],
                    action: { .noteFilter(id: filter.id, action: $0) }
                  )
                )
              }
            }
          }
        }
      }
      .padding(.leading, WineyGridRules.globalHorizontalPadding)
      
      Spacer()
      
      Divider()
        .overlay(WineyKitAsset.gray900.swiftUIColor)
      
      Button(action: {
        viewStore.send(.tappedFilterButton)
      }, label: {
        WineyAsset.Assets.filterIcon.swiftUIImage
          .padding(.horizontal, 8)
          .padding(.vertical, 6)
          .background(
            Capsule()
              .fill(WineyKitAsset.point1.swiftUIColor)
          )
      })
    }
    .padding(.leading, 4)
    .padding(.trailing, 20)
    .onAppear {
      viewStore.send(._viewWillAppear)
    }
  }
}

#Preview {
  NoteFilterScrollView(
    store: Store(
      initialState: NoteFilterScroll.State(), reducer: {
        NoteFilterScroll()
      }
    )
  )
}
