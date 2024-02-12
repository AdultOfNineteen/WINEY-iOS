//
//  TipCardDetailView.swift
//  Winey
//
//  Created by 정도현 on 2/4/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct TipCardDetailView: View {
  
  private let store: StoreOf<TipCardDetail>
  @ObservedObject var viewStore: ViewStoreOf<TipCardDetail>
  
  public init(store: StoreOf<TipCardDetail>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "와인 초보를 위한",
        coloredTitle: "TIP",
        leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
        leftIconButtonAction: {
          viewStore.send(.tappedBackButton)
        },
        backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
      )
      
      WineyWebView(url: viewStore.url)
    }
    .background(
      WineyKitAsset.mainBackground.swiftUIColor
    )
  }
}

#Preview {
  TipCardDetailView(
    store: Store(
      initialState: TipCardDetail.State(
        url: "test"
      ),
      reducer: {
        TipCardDetail()
      }
    )
  )
}
