//
//  FilteredNoteView.swift
//  Winey
//
//  Created by 정도현 on 1/11/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct FilteredNoteView: View {
  
  private let store: StoreOf<FilteredNote>
  @ObservedObject var viewStore: ViewStoreOf<FilteredNote>
  
  public init(store: StoreOf<FilteredNote>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      noteCount()
      
      filterBar()
      
      noteList()
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
    .onAppear {
      viewStore.send(._viewWillAppear)
    }
  }
}

extension FilteredNoteView {
  
  @ViewBuilder
  private func noteCount() -> some View {
    HStack(spacing: 0) {
      Text("\(viewStore.noteCardList?.noteCards.totalCnt ?? 0)개")
        .foregroundStyle(WineyKitAsset.main3.swiftUIColor)
      
      Text("의 노트를 작성했어요!")
        .foregroundStyle(.white)
      
      Spacer()
    }
    .wineyFont(.headLine)
    .padding(.bottom, 14)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  // MARK: Filter Bar
  @ViewBuilder
  private func filterBar() -> some View {
    VStack(spacing: 0) {
      Divider()
        .frame(height: 0.8)
        .overlay(WineyKitAsset.gray900.swiftUIColor)
      
      HStack(spacing: 0) {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 8) {
            if !viewStore.rebuyFilter.isEmpty || !viewStore.typeFilter.isEmpty || !viewStore.countryFilter.isEmpty {
              initButton()
            }
            
            emptyFilterButton(
              text: viewStore.sortState.title,
              action: { viewStore.send(.tappedSortState) }
            )
            
            filterCategoryButton(type: .rebuy, list: Array(viewStore.rebuyFilter))
            filterCategoryButton(type: .type, list: Array(viewStore.typeFilter))
            filterCategoryButton(type: .country, list: Array(viewStore.countryFilter))
          }
        }
        .padding(.leading, WineyGridRules.globalHorizontalPadding)
        
        Divider()
          .frame(width: 0.8)
          .overlay(WineyKitAsset.gray900.swiftUIColor)
          .border(.red)
        
        HStack {
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
          .padding(.leading, 7)
        }
      }
      .padding(.leading, 4)
      .padding(.trailing, 20)
      .padding(.vertical, 10)
      .frame(height: 65)
      
      Divider()
        .frame(height: 0.8)
        .overlay(WineyKitAsset.gray900.swiftUIColor)
        .padding(.bottom, 16)
    }
  }
  
  @ViewBuilder
  private func initButton() -> some View {
    HStack(alignment: .center, spacing: 3) {
      Text("초기화")
        .wineyFont(.captionB1)
        .foregroundStyle(WineyKitAsset.gray200.swiftUIColor)
      
      Image("reloadIcon")
        .foregroundStyle(WineyKitAsset.gray500.swiftUIColor)
    }
    .padding(.horizontal, 10)
    .frame(height: 35)
    .background(
      Capsule()
        .stroke(WineyKitAsset.gray900.swiftUIColor)
    )
    .padding(1)
    .onTapGesture {
      viewStore.send(.tappedInitButton)
    }
  }
  
  @ViewBuilder
  private func filterCategoryButton(type: FilterType, list: [String]) -> some View {
    if list.isEmpty {
      if type != .rebuy {
        emptyFilterButton(
          text: type.title,
          action: { viewStore.send(.tappedFilterButton) }
        )
      }
    } else {
      activateFilterButton(type: type, list: list)
    }
  }
  
  @ViewBuilder
  private func activateFilterButton(type: FilterType, list: [String]) -> some View {
    HStack(alignment: .center, spacing: 1) {
      HStack(spacing: 2) {
        Text(list[0])
        
        if list.count > 1 {
          Text("+\(list.count - 1)")
        }
      }
      .wineyFont(.captionB1)
      
      if list.count == 1 {
        Image("filterXIcon")
          .onTapGesture {
            viewStore.send(.tappedFilterRemoveButton(type, list[0]))
          }
      } else {
        Image("filterArrow")
      }
    }
    .foregroundStyle(WineyKitAsset.gray200.swiftUIColor)
    .padding(.horizontal, 10)
    .frame(height: 35)
    .background(
      Capsule()
        .fill(WineyKitAsset.gray900.swiftUIColor)
    )
    .padding(1)
    .onTapGesture {
      if list.count > 1 {
        viewStore.send(.tappedFilterButton)
      }
    }
  }
  
  @ViewBuilder
  private func emptyFilterButton(text: String, action: @escaping () -> Void) -> some View {
    HStack(alignment: .center, spacing: 1) {
      Text(text)
        .wineyFont(.captionB1)
      
      Image("filterArrow")
    }
    .foregroundStyle(WineyKitAsset.gray700.swiftUIColor)
    .padding(10)
    .background(
      Capsule()
        .stroke(WineyKitAsset.gray900.swiftUIColor)
    )
    .padding(1)
    .onTapGesture(perform: action)
  }
  
  // MARK: Note List
  @ViewBuilder
  private func noteList() -> some View {
    IfLetStore(
      self.store.scope(
        state: \.noteCardList,
        action: FilteredNote.Action.noteCardScroll
      )
    ) {
      NoteCardScrollView(store: $0)
    } else: {
      noteEmptyView()
    }
  }
  
  @ViewBuilder
  private func noteEmptyView() -> some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 72)
      
      WineyAsset.Assets.emptyNoteIcon.swiftUIImage
      
      Spacer()
        .frame(height: 13)
      
      VStack(spacing: 2) {
        Text("아직 노트가 없어요!")
        Text("노트를 작성해주세요 :)")
      }
      
      Spacer()
    }
    .frame(maxWidth: .infinity)
    .wineyFont(.headLine)
    .foregroundColor(WineyKitAsset.gray800.swiftUIColor)
  }
  
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
      Text(sortOption.title)
        .wineyFont(.bodyB1)
        .foregroundStyle(.white)
      
      Spacer()
      
      if viewStore.sortState == sortOption {
        WineyAsset.Assets.checkIcon.swiftUIImage
      }
    }
    .background(WineyKitAsset.gray950.swiftUIColor)
    .padding(.vertical, 20)
    .frame(height: 64)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .onTapGesture {
      viewStore.send(.tappedSortButton(sortOption))
    }
  }
}

#Preview {
  FilteredNoteView(
    store: Store(
      initialState: FilteredNote.State(),
      reducer: {
        FilteredNote()
      }
    )
  )
}
