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
          ForEach(viewStore.noteFilters.filter { $0.filterInfo.isSelected }, id: \.self) { filter in
            HStack(alignment: .center) {
              Text(filter.filterInfo.title)
              Text("x")
            }
            .foregroundColor(.white)
            .wineyFont(.captionB1)
            .padding(.vertical, 7.5)
            .padding(.horizontal, 10)
            .background(
              Capsule()
                .fill(WineyKitAsset.gray900.swiftUIColor)
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
            
            HStack {
              ForEachStore(
                self.store.scope(
                  state: \.noteFilters,
                  action: { .noteFilter(id: $0, action: $1) }
                )
              ) {
                NoteFilterView(store: $0)
              }
            }
          }
          
          // MARK: 생산지
          VStack(alignment: .leading, spacing: 14) {
            Text("생산지")
              .wineyFont(.bodyB1)
            
            VStack {
              
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

//#Preview {
//  FilterListView(
//    store: Store(
//      initialState: FilterList.State(noteFilterList: [NoteFilter(title: "test", isSelected: false, count: 0)]),
//      reducer: {
//        FilterList()
//      }
//    )
//  )
//}
