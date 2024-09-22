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
  let store: StoreOf<WineyPolicy>

  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: store.viewType.navTitle,
        leftIcon: Image(.navigationBack_buttonW),
        leftIconButtonAction: {
          store.send(.tappedBackButton)
        },
        backgroundColor: .wineyMainBackground
      )
      
      WineyWebView(
        url: store.viewType.url
      )
    }
    .background(.wineyMainBackground)
    .ignoresSafeArea(edges: .bottom)
    .navigationBarHidden(true)
  }
}

#Preview {
  WineyPolicyView.init(
    store: .init(
      initialState: .init(viewType: .termsPolicy),
      reducer: { WineyPolicy() }
    )
  )
}
