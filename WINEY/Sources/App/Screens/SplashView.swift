//
//  SplashView.swift
//  WINEY
//
//  Created by 박혜운 on 9/17/24.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct SplashView: View {
  private let store: StoreOf<Splash>
  
  public init(store: StoreOf<Splash>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      Color.wineyMainBackground.ignoresSafeArea()
      
      mainLogoSpace
    }
    .task { store.send(._onAppear) }
    .navigationViewStyle(StackNavigationViewStyle())
    .navigationBarHidden(true)
  }
  
  private var mainLogoSpace: some View {
    VStack(spacing: 24) {
      Image("logo_imge")
      
      Image("logoText_imge")
    }
    .background {
      RadientCircleBackgroundView(backgroundType: .splash)
        .offset(y: -10)
    }
  }
}

#Preview {
  SplashView(
    store: Store(
      initialState: Splash.State(),
      reducer: {
        Splash()
      }
    )
  )
}
