//
//  WineyPolicyView.swift
//  Winey
//
//  Created by 정도현 on 4/1/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WineyPolicyView: View {
  private let store: StoreOf<WineyPolicy>
  @ObservedObject var viewStore: ViewStoreOf<WineyPolicy>
  
  public init(store: StoreOf<WineyPolicy>) {
    self.store = store
    self.viewStore = ViewStore(
      self.store,
      observe: { $0 }
    )
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: viewStore.viewType.navTitle,
        leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
        leftIconButtonAction: {
          viewStore.send(.tappedBackButton)
        },
        backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
      )
      
      WineyWebView(
        url: viewStore.viewType.url
      )
    }
    .background(
      WineyKitAsset.mainBackground.swiftUIColor
    )
    .ignoresSafeArea(edges: .bottom)
    .navigationBarHidden(true)
  }
}

#Preview {
  WineyPolicyView(
    store: .init(
      initialState: WineyPolicy.State(viewType: .termsPolicy),
      reducer: {
        WineyPolicy()
      }
    )
  )
}
