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
  let store: StoreOf<NoteRemoveBottomSheet>
  
  public var body: some View {
    ZStack {
      Color.wineyGray950.ignoresSafeArea(edges: .all)
      
      BottomSheet(
        backgroundColor: Color.wineyGray950,
        isPresented: .constant(true),
        spacingBottomSafeArea: false,
        headerArea: {
          Image(.noteColorImageW)
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
        .foregroundStyle(.wineyGray200)
      
      Text("삭제한 노트는 복구할 수 없어요 :(")
        .foregroundStyle(.wineyGray600)
    }
    .wineyFont(.bodyB1)
  }
  
  @ViewBuilder
  func bottomSheetFooter() -> some View {
    TwoOptionSelectorButtonView(
      leftTitle: "아니오",
      leftAction: {
        store.send(.tappedNoButton)
      },
      rightTitle: "네, 지울래요",
      rightAction: {
        store.send(.tappedYesButton(noteId: store.noteId))
      }
    )
  }
}
