//
//  SplashView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
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
      WineyKitAsset.mainBackground.swiftUIColor.ignoresSafeArea()
      
      mainLogoSpace
        .onAppear {
          store.send(._onAppear)
        }
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .navigationBarHidden(true)
  }
  
  private var mainLogoSpace: some View {
    VStack(spacing: 21) {
      Image("logo_imge")
        .background {
          RadientCircleBackgroundView()
            .offset(y: -15)
        }
      
      Image("logoText_imge")
    }
  }
}
