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
  
  public init(store: StoreOf<TipCardDetail>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "와인 초보를 위한",
        coloredTitle: "TIP",
        leftIcon: Image(.navigationBack_buttonW),
        leftIconButtonAction: {
          store.send(.tappedBackButton)
        },
        backgroundColor: Color.wineyMainBackground
      )
      
      WineyWebView(url: store.url)
    }
    .navigationBarHidden(true)
    .background(.wineyMainBackground)
    .ignoresSafeArea(edges: .bottom)
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
