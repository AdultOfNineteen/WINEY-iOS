//
//  TwoSectionBottomSheetView.swift
//  WineyKit
//
//  Created by 정도현 on 5/22/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct TripleSectionBottomSheetView: View {
  private let store: StoreOf<TwoSectionBottomSheet>
  @ObservedObject var viewStore: ViewStoreOf<TwoSectionBottomSheet>
  
  public init(store: StoreOf<TwoSectionBottomSheet>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    ZStack {
      WineyKitAsset.gray950.swiftUIColor.ignoresSafeArea(edges: .all)
      selectOptionView()
    }
    .presentationDetents([.height(248)])
    .presentationDragIndicator(.visible)
    .onAppear {
      viewStore.send(._onAppear)
    }
    .onDisappear {
      viewStore.send(._onDisappear)
    }
  }
}

private extension TripleSectionBottomSheetView {
  
  @ViewBuilder
  private func selectOptionView() -> some View {
    VStack(spacing: 0) {
      sectionContainer(
        title: viewStore.sheetMode.thirdTitle,
        action: {
          viewStore.send(.tappedThirdButton)
        }
      )
      
      Divider()
      .overlay(
        WineyKitAsset.gray900.swiftUIColor
      )
      
      sectionContainer(
        title: viewStore.sheetMode.firstTitle,
        action: {
          viewStore.send(.tappedFirstButton)
        }
      )
      
      Divider()
        .overlay(
          WineyKitAsset.gray900.swiftUIColor
        )
      
      sectionContainer(
        title: viewStore.sheetMode.secondTitle,
        action: { viewStore.send(.tappedSecondButton) }
      )
    }
  }
  
  @ViewBuilder
  private func sectionContainer(
    title: String,
    action: @escaping () -> Void
  ) -> some View {
    HStack {
      Text(title)
        .wineyFont(.bodyB1)
        .foregroundStyle(.white)
      
      Spacer()
    }
    .padding(.vertical, 20)
    .frame(height: 64)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .background(WineyKitAsset.gray950.swiftUIColor)
    .onTapGesture {
      action()
    }
  }
}
