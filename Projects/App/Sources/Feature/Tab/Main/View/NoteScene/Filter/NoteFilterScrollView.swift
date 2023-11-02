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
          // MARK: Initial Button
          if shouldShowInitButton {
            NoteFilterIndicatorView(title: "초기화") {
              viewStore.send(.tappedInitButton)
            }
          }
          
          // MARK: 정렬 기준
          NoteFilterIndicatorView(title: viewStore.sortState.rawValue) {
            viewStore.send(.tappedSortState)
          }       
          
          // MARK: Wine Type
          if !shouldShowInitButton {
            NoteFilterIndicatorView(title: "와인종류") {
              viewStore.send(.tappedFilterButton)
            }
          }
          
          // MARK: Wine Country
          if !shouldShowInitButton {
            NoteFilterIndicatorView(title: "와인종류") {
              viewStore.send(.tappedFilterButton)
            }
          }
          
          if !rebuyFilters.isEmpty {
            NoteFilterDisplayView(
              store: self.store.scope(
                state: \.filterList[0],
                action: { .noteFilter(id: 0, action: $0) }
              )
            )
          }
          
          if !selectedWineTypeFilters.isEmpty {
            ForEach(selectedWineTypeFilters) { filter in
              NoteFilterDisplayView(
                store: self.store.scope(
                  state: \.filterList[filter.id],
                  action: { .noteFilter(id: filter.id, action: $0) }
                )
              )
            }
          }
          
          if !selectedWineCountryFilters.isEmpty {
            ForEach(selectedWineCountryFilters) { filter in
              NoteFilterDisplayView(
                store: self.store.scope(
                  state: \.filterList[filter.id],
                  action: { .noteFilter(id: filter.id, action: $0) }
                )
              )
            }
          }
        }
      }
      .padding(.leading, WineyGridRules.globalHorizontalPadding)
      
      Spacer()
      
      Divider().overlay(WineyKitAsset.gray900.swiftUIColor)
      
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
    .padding(.vertical, 10)
    .onAppear {
      viewStore.send(._viewWillAppear)
    }
    .sheet(
      isPresented: viewStore.binding(
        get: \.isPresentedBottomSheet,
        send: .tappedOutsideOfBottomSheet
      ), content: {
        ZStack {
          WineyKitAsset.gray950.swiftUIColor.ignoresSafeArea(edges: .all)
          selectSortOptionView()
        }
        .presentationDetents([.height(187)])
        .presentationDragIndicator(.visible)
      }
    )
  }
  
  
}

extension NoteFilterScrollView {
  private var shouldShowInitButton: Bool {
    !viewStore.filterList.filter({ $0.filterInfo.isSelected }).isEmpty
  }
  
  private var rebuyFilters: [NoteFilter.State] {
    viewStore.filterList.filter { $0.filterInfo.isSelected && $0.id == 0 }
  }
  
  private var selectedWineTypeFilters: [NoteFilter.State] {
    viewStore.filterList.filter { $0.filterInfo.isSelected && $0.id >= 1 && $0.id < 7 }
  }
  
  private var selectedWineCountryFilters: [NoteFilter.State] {
    viewStore.filterList.filter { $0.filterInfo.isSelected && $0.id >= 7}
  }
}

extension NoteFilterScrollView {
  
  @ViewBuilder
  private func selectSortOptionView() -> some View {
    VStack(spacing: 0) {
      sortOptionListCard(sortOption: .latest)
      Divider()
        .overlay(
          WineyKitAsset.gray900.swiftUIColor
        )
      sortOptionListCard(sortOption: .star)
    }
  }
  
  @ViewBuilder
  private func sortOptionListCard(sortOption: SortState) -> some View {
    HStack {
      Text(sortOption.rawValue)
        .wineyFont(.bodyB1)
        .foregroundStyle(.white)
      
      Spacer()
      
      if viewStore.sortState == sortOption {
        WineyAsset.Assets.checkIcon.swiftUIImage
      }
    }
    .padding(.vertical, 20)
    .frame(height: 64)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .onTapGesture {
      viewStore.send(.tappedSortCard(sortOption))
    }
  }
}

struct NoteFilterScrollView_Previews: PreviewProvider {
  static var previews: some View {
    NoteFilterScrollView(
      store: Store(
        initialState: NoteFilterScroll.State(),
        reducer: { NoteFilterScroll() }
      )
    )
  }
}
