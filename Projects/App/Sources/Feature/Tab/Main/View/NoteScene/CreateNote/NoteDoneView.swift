//
//  NoteDoneView.swift
//  Winey
//
//  Created by 정도현 on 12/12/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct NoteDoneView: View {
  
  private let store: StoreOf<NoteDone>
  @ObservedObject var viewStore: ViewStoreOf<NoteDone>
  
  public init(store: StoreOf<NoteDone>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    ZStack {
      WineyKitAsset.mainBackground.swiftUIColor
      
      colorBackground()
      
      bottomButton()
    }
    .ignoresSafeArea()
    .navigationBarHidden(true)
  }
}

extension NoteDoneView {
  
  @ViewBuilder
  private func colorBackground() -> some View {
    Image("noteBackground")
      .resizable()
      .scaledToFit()
  }
  
  @ViewBuilder
  private func bottomButton() -> some View {
    VStack {
      Spacer()
      
      WineyConfirmButton(
        title: "확인",
        validBy: true,
        action: {
          viewStore.send(.tappedButton)
        }
      )
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .padding(.bottom, 54)
  }
}

#Preview {
  NoteDoneView(
    store: Store(
      initialState: NoteDone.State(),
      reducer: {
        NoteDone()
      }
    )
  )
}
