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

public struct FilteredNotesView: View {
  
  let store: StoreOf<FilteredNotes>
  
  public init(store: StoreOf<FilteredNotes>) { self.store = store }
  
  public var body: some View {
    VStack(spacing: 0) {
      noteCount()
      
      filterBar()
      
      noteList()
    }
    .sheet(
      isPresented: .init(
        get: {
          store.isPresentedBottomSheet
        }, set: { _ in 
          store.send(.tappedOutsideOfBottomSheet)
        }
      ), content: {
        ZStack {
          Color.wineyGray950.ignoresSafeArea(edges: .all)
          selectSortOptionView()
        }
        .presentationDetents([.height(187)])
        .presentationDragIndicator(.visible)
      }
    )
    .onAppear {
      store.send(._onAppear)
    }
  }
}

extension FilteredNotesView {
  
  @ViewBuilder
  private func noteCount() -> some View {
    HStack(spacing: 0) {
      Text("\(store.tastingNotes.noteListInfo.totalCnt)개")
        .foregroundStyle(.wineyMain3)
      
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
        .overlay(.wineyGray900)
      
      HStack(spacing: 0) {
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 8) {
            if store.filterOptions.rebuy || !store.filterOptions.type.isEmpty || !store.filterOptions.country.isEmpty {
              initButton()
            }
            
            emptyFilterButton(
              text: store.filterOptions.sortState.title,
              action: { store.send(.tappedSortState) }
            )
            
            filterCategoryButton(type: .rebuy, list: store.filterOptions.rebuy ? ["재구매 의사"] : [])
            filterCategoryButton(type: .type, list: Array(store.filterOptions.type))
            filterCategoryButton(type: .country, list: Array(store.filterOptions.country))
          }
        }
        .padding(.leading, WineyGridRules.globalHorizontalPadding)
        
        Divider()
          .frame(width: 0.8)
          .overlay(.wineyGray900)
          .border(.red)
        
        HStack {
          Button(action: {
            store.send(.tappedFilterButton)
          }, label: {
            Image(.filterIconW)
              .padding(.horizontal, 8)
              .padding(.vertical, 6)
              .background(
                Capsule()
                  .fill(.wineyPoint1)
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
        .overlay(.wineyGray900)
        .padding(.bottom, 16)
    }
  }
  
  @ViewBuilder
  private func initButton() -> some View {
    HStack(alignment: .center, spacing: 3) {
      Text("초기화")
        .wineyFont(.captionB1)
        .foregroundStyle(.wineyGray200)
      
      Image("reloadIcon")
        .foregroundStyle(.wineyGray500)
    }
    .padding(.horizontal, 10)
    .frame(height: 35)
    .background(
      Capsule()
        .stroke(.wineyGray900)
    )
    .padding(1)
    .onTapGesture {
      store.send(.tappedInitButton)
    }
  }
  
  @ViewBuilder
  private func filterCategoryButton(type: FilterType, list: [String]) -> some View {
    if list.isEmpty {
      if type != .rebuy {
        emptyFilterButton(
          text: type.title,
          action: { store.send(.tappedFilterButton) }
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
            store.send(.tappedFilterRemoveButton(type, list[0]))
          }
      } else {
        Image("filterArrow")
      }
    }
    .foregroundStyle(.wineyGray200)
    .padding(.horizontal, 10)
    .frame(height: 35)
    .background(
      Capsule()
        .fill(.wineyGray900)
    )
    .padding(1)
    .onTapGesture {
      if list.count > 1 {
        store.send(.tappedFilterButton)
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
    .foregroundStyle(.wineyGray700)
    .padding(10)
    .background(
      Capsule()
        .stroke(.wineyGray900)
    )
    .padding(1)
    .onTapGesture(perform: action)
  }
  
  // MARK: Note List
  @ViewBuilder
  private func noteList() -> some View {
      TastingNotesView(
        store: self.store.scope(
          state: \.tastingNotes,
          action: \.tastingNotes
        )
      )
  }
  
  @ViewBuilder
  private func selectSortOptionView() -> some View {
    VStack(spacing: 0) {
      sortOptionListCard(sortOption: .latest)
      Divider()
        .overlay(
          .wineyGray900
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
      
      if store.filterOptions.sortState == sortOption {
        Image(.checkIconW)
      }
    }
    .background(.wineyGray950)
    .padding(.vertical, 20)
    .frame(height: 64)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .onTapGesture {
      store.send(.tappedSortButton(sortOption))
    }
  }
}

#Preview {
  FilteredNotesView(
    store: Store(
      initialState: FilteredNotes.State.init(),
      reducer: {
        FilteredNotes()
      }
    )
  )
}
