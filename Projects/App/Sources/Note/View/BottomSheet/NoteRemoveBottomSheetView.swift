//
//  NoteRemoveBottomSheetView.swift
//  Winey
//
//  Created by 정도현 on 5/25/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct NoteRemoveBottomSheetView: View {
  private let store: StoreOf<NoteRemoveBottomSheet>
  @ObservedObject var viewStore: ViewStoreOf<NoteRemoveBottomSheet>
  
  public init(store: StoreOf<NoteRemoveBottomSheet>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    ZStack {
      WineyKitAsset.gray950.swiftUIColor.ignoresSafeArea(edges: .all)
      
      BottomSheet(
        backgroundColor: WineyKitAsset.gray950.swiftUIColor,
        isPresented: .constant(true),
        spacingBottomSafeArea: false,
        headerArea: {
          WineyAsset.Assets.noteColorImage.swiftUIImage
        },
        content: {
          bottomSheetContent()
        },
        bottomArea: {
          bottomSheetFooter()
        }
      )
    }
    .presentationDetents([.height(393)])
  }
}

private extension NoteRemoveBottomSheetView {
  
  @ViewBuilder
  func bottomSheetContent() -> some View {
    VStack(spacing: 4) {
      Text("테이스팅 노트를 삭제하시겠어요?")
        .foregroundStyle(WineyKitAsset.gray200.swiftUIColor)
      
      Text("삭제한 노트는 복구할 수 없어요 :(")
        .foregroundStyle(WineyKitAsset.gray600.swiftUIColor)
    }
    .wineyFont(.bodyB1)
  }
  
  @ViewBuilder
  func bottomSheetFooter() -> some View {
    TwoOptionSelectorButtonView(
      leftTitle: "아니오",
      leftAction: {
        viewStore.send(.tappedNoButton)
      },
      rightTitle: "네, 지울래요",
      rightAction: {
        viewStore.send(.tappedYesButton)
      }
    )
  }
}
