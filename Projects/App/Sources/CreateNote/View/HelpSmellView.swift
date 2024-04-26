//
//  HelpSmellView.swift
//  Winey
//
//  Created by 정도현 on 1/18/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct HelpSmellView: View {
  private let store: StoreOf<HelpSmell>
  @ObservedObject var viewStore: ViewStoreOf<HelpSmell>
  
  public init(store: StoreOf<HelpSmell>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      NavigationBar(
        leftIcon: Image("navigationBack_button"),
        leftIconButtonAction: {
          viewStore.send(.tappedBackButton)
        },
        backgroundColor: .clear
      )
      
      title()
      
      wineScrollContent()
    }
    .ignoresSafeArea(edges: .bottom)
    .background(
      WineyKitAsset.mainBackground.swiftUIColor
    )
    .navigationBarHidden(true)
  }
}

extension HelpSmellView {
  
  @ViewBuilder
  private func title() -> some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("와인 품종에 따른")
      HStack(spacing: 0) {
        Text("대표적인 향")
          .foregroundStyle(WineyKitAsset.main2.swiftUIColor)
        
        Text("을 느껴보세요!")
      }
    }
    .wineyFont(.title2)
    .padding(.top, 20)
    .padding(.bottom, 15)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  @ViewBuilder
  private func wineScrollContent() -> some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 50) {
        smellCategory(type: .red)
        smellCategory(type: .white)
      }
      .padding(.top, 15)
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      .padding(.bottom, 140)
    }
  }
  
  @ViewBuilder
  private func smellCategory(
    type: WineType
  ) -> some View {
    VStack(alignment: .leading, spacing: 20) {
      Text(type.korName + "와인")
        .wineyFont(.headLine)
        .foregroundStyle(WineyKitAsset.gray500.swiftUIColor)
      
      VStack(alignment: .leading, spacing: 25) {
        ForEachStore(
          self.store.scope(
            state: type == .red ? \.redList : \.whiteList,
            action: { type == .red ? .redList(id: $0, action: $1) :.whiteList(id: $0, action: $1) }
          )
        ){
          SmellListView(store: $0)
        }
      }
    }
  }
}

#Preview {
  HelpSmellView(
    store: Store(
      initialState: HelpSmell.State(),
      reducer: {
        HelpSmell()
      }
    )
  )
}
