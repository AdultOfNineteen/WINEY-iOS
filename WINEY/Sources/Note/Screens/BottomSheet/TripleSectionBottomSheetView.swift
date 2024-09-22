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
  let store: StoreOf<TripleSectionBottomSheet>
  
  public var body: some View {
    ZStack {
      Color.wineyGray950.ignoresSafeArea(edges: .all)
      selectOptionView()
    }
    .presentationDetents([.height(248)])
    .presentationDragIndicator(.visible)
//    .onAppear {
//      store.send(._onAppear)
//    }
//    .onDisappear {
//      store.send(._onDisappear)
//    }
  }
}

private extension TripleSectionBottomSheetView {
  
  @ViewBuilder
  private func selectOptionView() -> some View {
    VStack(spacing: 0) {
      sectionContainer(
        title: NoteDetailOption.shared.rawValue,
        action: {
          store.send(.tappedFirstButton)
        }
      )
      
      Divider()
      .overlay(.wineyGray900)
      
      sectionContainer(
        title: NoteDetailOption.remove.rawValue,
        action: {
          store.send(.tappedSecondButton)
        }
      )
      
      Divider()
        .overlay(.wineyGray900)
      
      sectionContainer(
        title: NoteDetailOption.modify.rawValue,
        action: { store.send(.tappedThirdButton) }
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
    .background(.wineyGray950)
    .onTapGesture { action() }
  }
}
